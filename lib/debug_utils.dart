import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:meine_musik/utils/RateLimit.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'utils.dart';

typedef Level = SentryLevel;

class LogEntry {
  LogEntry(this.level, DateTime time, String message) : message = '${_timePrefix(time)} $message';

  final Level level;
  final String message;
}

class Log {
  static const _maxLogEntries = 1000;

  final _buffer = <LogEntry>[];
  int _start = 0;

  void clear() {
    _start = 0;
    _buffer.clear();
  }

  List<LogEntry> getSnapshot() {
    if (_start == 0) {
      return [..._buffer];
    }
    return [..._buffer.slice(_start, _buffer.length), ..._buffer.slice(0, _start)];
  }

  void add(LogEntry logEntry) {
    if (_buffer.length < _maxLogEntries) {
      _buffer.add(logEntry);
    } else {
      _buffer[_start] = logEntry;
      _start += 1;
      if (_start >= _maxLogEntries) {
        _start = 0;
      }
    }
  }
}

final Log log = Log();

Future<void> initSentry({required FutureOr<void> Function() appRunner}) => SentryFlutter.init((options) {
  options
    ..beforeSend = _beforeSend
    ..dsn = kDebugMode ? '' : 'https://c2b883d29f4630d569cf94e5533e66b4@o4510056611971072.ingest.de.sentry.io/4510056624619600'
    ..privacy.maskAllText = false
    ..privacy.maskAllImages = false
    ..privacy.maskAssetImages = false
    ..replay.onErrorSampleRate = 1.0
    ..sampleRate = 1.0
    ..sendDefaultPii = true
    ..tracesSampleRate = 1.0;
  [
    _IgnoreFastTransactions(),
    _IgnoreAbortedTransactions(),
    _LogSentryEvents(),
    _OnlyReportUnexpectedErrors(),
    _RespectReportRateLimit(),
  ].forEach(options.addEventProcessor);
}, appRunner: () {
  _debugPrint = debugPrint;
  debugPrint = (message, {int? wrapWidth}) {
    addBreadcrumb(message ?? '', level: Level.debug);
  };
  return appRunner();
});

late DebugPrintCallback _debugPrint;

/// Will never throw.
void addBreadcrumb(String message, {Level level = Level.debug, DateTime? t}) {
  try {
    t ??= DateTime.now();
    log.add(LogEntry(level, t, message));
    if (Sentry.isEnabled) {
      if (_breadcrumbRateLimit.withinRateLimit()) {
        Sentry.addBreadcrumb(Breadcrumb(message: '${_timePrefix(t)} $message', level: level));
      } else {
        ++_skippedBreadcrumbs;
      }
    } else {
      _debugPrint('${_timePrefix(t)} $message');
    }
  } catch (error, stack) {
    reportError('addBreadcrumb failed', error, stack);
  }
}

/// Reports an error only on the first occurrence -- all following calls with the same error are ignored,
/// will never throw.
void reportErrorOnce(String message, [Object? error, StackTrace? stack]) {
  try {
    final t0 = DateTime.now();
    stack ??= StackTrace.current;
    _reportError(t0, message, error, stack, null, doNotReport: !_reportedOnce.add(_reportedOnceKey(stack)));
  } catch (_) {
    // Ignored
  }
}

/// Will never throw.
void reportError(String message, [Object? error, StackTrace? stack, Map<String, dynamic>? data]) {
  try {
    final t0 = DateTime.now();
    stack ??= StackTrace.current;
    _reportError(t0, message, error, stack, data);
  } catch (ignored) {}
}

FutureOr<SentryEvent?> _beforeSend(SentryEvent event, Hint hint) {
  if (event is! SentryTransaction) {
    final moreBreadcrumbs = <Breadcrumb>[];
    if (_skippedBreadcrumbs > 0) {
      moreBreadcrumbs.add(Breadcrumb(message: '!!! Skipped $_skippedBreadcrumbs breadcrumb(s)', level: Level.info));
      _skippedBreadcrumbs = 0;
    }
    if (_skippedWarnings > 0) {
      moreBreadcrumbs.add(Breadcrumb(message: '!!! Skipped $_skippedWarnings warning(s)', level: Level.warning));
      _skippedWarnings = 0;
    }
    if (_skippedErrors > 0) {
      moreBreadcrumbs.add(Breadcrumb(message: '!!! Skipped $_skippedErrors error(s)', level: Level.error));
      _skippedErrors = 0;
    }
    if (moreBreadcrumbs.isNotEmpty) {
      final breadcrumbs = event.breadcrumbs ?? [];
      event.breadcrumbs = [...breadcrumbs, ...moreBreadcrumbs];
    }
  }
  return event;
}

final _breadcrumbRateLimit = RateLimit(max: 100, per: Duration(seconds: 3));
final _reportRateLimit = RateLimit(max: 5, per: Duration(seconds: 10));

/// A Sentry [EventProcessor] which drops all transactions, which finish within 500 milliseconds.
class _IgnoreFastTransactions implements EventProcessor {
  @override
  FutureOr<SentryEvent?> apply(SentryEvent event, Hint hint) {
    if (event is SentryTransaction) {
      final t1 = event.startTimestamp;
      final t2 = event.timestamp;
      if (t2 != null && t2.difference(t1).inMilliseconds < 500) {
        return null;
      }
    }
    return event;
  }
}

/// A Sentry [EventProcessor] which drops all aborted transactions.
class _IgnoreAbortedTransactions implements EventProcessor {
  @override
  FutureOr<SentryEvent?> apply(SentryEvent event, Hint hint) {
    if (event is SentryTransaction) {
      if (event.spans.any((it) => it.status == SpanStatus.aborted())) {
        return null;
      }
    }
    return event;
  }
}

/// A Sentry [EventProcessor] adds SentryEvents to [log] (if not already added).
class _LogSentryEvents implements EventProcessor {
  @override
  FutureOr<SentryEvent?> apply(SentryEvent event, Hint hint) async {
    try {
      if (event is! SentryTransaction && hint.get('breadcrumb-added') != true) {
        final level = event.level ?? Level.info;
        String? message = '';
        try {
          message = hint.get('message')?.toString() ?? event.message?.formatted;
        } catch (ignored) {}
        if (message == null) {
          try {
            final error = event.throwable;
            message = error == null ? event.toString() : safeErrorToString(error);
          } catch (ignored) {}
        }
        if (message != null) {
          final t = event.timestamp ?? (hint.get('t0') as DateTime?) ?? DateTime.now();
          log.add(LogEntry(level, t, message));
        }
      }
    } catch (error, stack) {
      reportErrorOnce('$_OnlyReportUnexpectedErrors.apply failed', error, stack);
    }
    return event;
  }
}

/// A Sentry [EventProcessor] which drops all expected errors, because only unexpected errors should be reported to Sentry.
class _OnlyReportUnexpectedErrors implements EventProcessor {
  @override
  FutureOr<SentryEvent?> apply(SentryEvent event, Hint hint) async {
    if (hint.get('do-not-report') == true) {
      return null;
    }
    final error = event.throwable;
    final level = event.level ?? Level.info;
    final t = event.timestamp ?? (hint.get('t0') as DateTime?) ?? DateTime.now();
    event.timestamp ??= t;
    if (event is! SentryTransaction && hint.get('breadcrumb-added') != true) {
      // Side effect: add the SentryEvent to [log] ...
      String? message = '';
      try {
        message = hint.get('message')?.toString() ?? event.message?.formatted;
      } catch (ignored) {}
      try {
        message ??= error == null ? event.toString() : safeErrorToString(error);
      } catch (ignored) {}
      if (message != null) {
        log.add(LogEntry(level, t, message));
      }
    }
    final category = _categorizeError(error, t);
    if (category != 'unexpected') {
      return null;
    }
    return event;
  }
}

DateTime? _lastTimeTemporaryErrorOccurred;

String _categorizeError(Object? error, DateTime t) {
  final isNetworkError_ = error != null && _isNetworkError(error);
  if (error != null && isTemporaryError(error, isNetworkError_)) {
    _lastTimeTemporaryErrorOccurred = t;
    return isNetworkError_ ? 'network' : 'temporary';
  } else {
    // Prevent false alarms: Do not report any errors to Sentry,
    // if a temporary error occurred within the last second ...
    final lastTimeTemporaryErrorOccurred = _lastTimeTemporaryErrorOccurred;
    return lastTimeTemporaryErrorOccurred != null && DateTime.now().difference(lastTimeTemporaryErrorOccurred).inSeconds < 1
        ? 'subsequent-error'
        : 'unexpected';
  }
}

bool isTemporaryError(Object error, [bool? isNetworkError_]) {
  if (isNetworkError_ == true) {
    return true;
  }
  final s = safeErrorToString(error).toLowerCase();
  if (s.contains('temporar') || s.contains('unavailable') || s.contains('timeout') || s.contains('timed out')) {
    return true;
  }
  return isNetworkError_ ?? _isNetworkError(error);
}

bool _isNetworkError(Object error) {
  if (error is SocketException) {
    return true;
  }
  if (error is HandshakeException) {
    return true;
  }
  if (error is HttpException) {
    final errorMessage = error.message;
    if (errorMessage.isEmpty /* <-- when there is no message, this is likely a network error */ ||
        errorMessage.contains(RegExp('connection', caseSensitive: false)) ||
        errorMessage == 'Bad file descriptor' ||
        errorMessage == 'Operation timed out') {
      return true;
    }
  }
  if (error is ClientException) {
    return true;
  }
  if (error is PlatformException && (error.code == 'unavailable' || error.code == 'network_error')) {
    return true;
  }
  return false;
}

/// A Sentry [EventProcessor] which drops all events if the report rate limit is exceeded.
class _RespectReportRateLimit implements EventProcessor {
  @override
  FutureOr<SentryEvent?> apply(SentryEvent event, Hint hint) {
    if (_reportRateLimit.withinRateLimit()) {
      return event;
    }
    if (event.level == Level.warning) {
      ++_skippedWarnings;
    } else if (event.level == Level.error || event.level == Level.fatal) {
      ++_skippedErrors;
    }
    return null;
  }
}

int _skippedBreadcrumbs = 0;
int _skippedWarnings = 0;
int _skippedErrors = 0;

int _reportErrorDepth = 0;

String _timePrefix(DateTime t) {
  final hh = t.hour.toString().padLeft(2, '0');
  final mm = t.minute.toString().padLeft(2, '0');
  final ss = t.second.toString().padLeft(2, '0');
  final sss = t.millisecond.toString().padLeft(3, '0');
  return '$hh:$mm:$ss.$sss';
}

Future<void> _reportError(
  DateTime t0,
  String message,
  Object? error,
  StackTrace stack,
  Map<String, dynamic>? data, {
  bool doNotReport = false,
}) async {
  ++_reportErrorDepth;
  try {
    if (_reportErrorDepth > 1) {
      // An error occurred while reporting an error!
      // Try to report that error in the simplest possible way ...
      try {
        await Sentry.captureException(error, stackTrace: stack);
      } catch (ignored) {}
    }
    var errorMessage = message;
    if (error != null) {
      errorMessage = '$message -- ${safeErrorToString(error)}';
    }
    // We add a breadcrumb with the error message here before reporting the error, so that
    // (a) this error will be visible in later reports too, and
    // (b) because we cannot pass a message to Sentry.captureException(...) ...
    addBreadcrumb(data == null ? errorMessage : '$errorMessage -- ${_stringifyMap(data)}', level: Level.error, t: t0);
    await Sentry.captureException(
      error ?? Exception(message),
      stackTrace: stack,
      withScope: (scope) async {
        if (data != null) {
          await scope.setContexts('data', data);
        }
      },
      hint: Hint.withMap({'t0': t0, 'breadcrumb-added': true, 'message': message, 'do-not-report': doNotReport}),
    );
  } catch (error, stack) {
    // Prevent reportError(...) stack overflow ...
    if (_reportErrorDepth == 1) {
      reportError('reportError(...) failed', error, stack);
    }
  } finally {
    --_reportErrorDepth;
  }
}

final _reportedOnce = <String>{};

String _reportedOnceKey(StackTrace stack) {
  String? s;
  try {
    s = stack.toString();
    final a = s.split('\n');
    if (a.length > 5) {
      return a.sublist(0, 5).join('\n');
    }
    return s;
  } catch (error, stack) {
    if (_reportedOnce.add('_reportedOnceKey(...) failed')) {
      reportError('_reportedOnceKey(...) failed', error, stack);
    }
    return '_reportedOnceKey(...) failed';
  }
}

String _stringifyMap(Map extras) {
  final sb = StringBuffer();
  for (final entry in extras.entries) {
    if (sb.isNotEmpty) {
      sb.write(', ');
    }
    sb
      ..write(entry.key)
      ..write(': ');
    final value = entry.value;
    if (value == null) {
      sb.write('null');
    } else if (value is String) {
      sb.write(jsonEncode(value));
    } else {
      String valueAsString;
      try {
        valueAsString = value.toString();
      } catch (error) {
        try {
          valueAsString = '${value.runtimeType}';
        } catch (ignored) {
          valueAsString = '???';
        }
      }
      sb.write(valueAsString);
    }
  }
  return sb.toString();
}

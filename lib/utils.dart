class Futures {
  static Future<(A, B)> tuple2<A, B>(Future<A> future1, Future<B> future2) async {
    final values = await Future.wait([future1, future2]);
    return (values[0] as A, values[1] as B);
  }

  static Future<(A, B, C)> tuple3<A, B, C>(Future<A> future1, Future<B> future2, Future<C> future3) async {
    final values = await Future.wait([future1, future2, future3]);
    return (values[0] as A, values[1] as B, values[2] as C);
  }

  static Future<(A, B, C, D)> tuple4<A, B, C, D>(
    Future<A> future1,
    Future<B> future2,
    Future<C> future3,
    Future<D> future4,
  ) async {
    final values = await Future.wait([future1, future2, future3, future4]);
    return (values[0] as A, values[1] as B, values[2] as C, values[3] as D);
  }

  static Future<Map<K, V>> map<K, V>(Iterable<K> keys, Future<V> Function(K) f) async {
    final values = await Future.wait(keys.map(f));
    return Map.fromIterables(keys, values);
  }
}

String formatSongDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  return switch (hours) {
    0 => '$minutes:${_twoDigits(seconds)}',
    _ => '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}',
  };
}

String _twoDigits(int n) => n >= 10 ? '$n' : '0$n';

String formatPlaylistDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  var minutesFormated = switch (minutes) {
    1 => '1 Minute',
    _ => '$minutes Minuten',
  };
  return switch (hours) {
    0 => minutesFormated,
    1 => '1 Stunde, $minutesFormated',
    _ => '$hours Stunden, $minutesFormated',
  };
}

extension IterableUtils<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing the results of applying the
  /// given [transform] function to each element and its index in the original
  /// collection.
  Iterable<R> mapIndexed<R>(R Function(E, int index) transform) sync* {
    var index = 0;
    for (final element in this) {
      yield transform(element, index++);
    }
  }

  /// Returns all elements that satisfy the given [predicate].
  Iterable<E> whereIndexed(bool Function(E, int index) predicate) sync* {
    var index = 0;
    for (final element in this) {
      if (predicate(element, index++)) {
        yield element;
      }
    }
  }

  Map<K, List<E>> groupBy<K>(K Function(E) selector) {
    final map = <K, List<E>>{};
    for (final element in this) {
      (map[selector(element)] ??= []).add(element);
    }
    return map;
  }

  List<E> sortBy(
    Comparable Function(E element) selector, {
    Comparable Function(E element)? thenBy,
  }) {
    final list = toList();
    list.sort((a, b) {
      var result = selector(a).compareTo(selector(b));
      if (result == 0 && thenBy != null) {
        result = thenBy(a).compareTo(thenBy(b));
      }
      return result;
    });
    return list;
  }

  /// Keeps the order.
  List<E> removeDuplicates() {
    final set = <E>{};
    final list = <E>[];
    for (final element in this) {
      if (set.add(element)) {
        list.add(element);
      }
    }
    return list;
  }
}

extension ListUtils<E> on List<E> {
  /// Returns a new [List] containing the results of applying the
  /// given [transform] function to each element and its index in
  /// the original list.
  List<R> mapIndexed<R>(R Function(E, int index) transform) {
    final result = <R>[];
    var index = 0;
    for (final element in this) {
      result.add(transform(element, index++));
    }
    return result;
  }
}

String safeErrorToString(Object? error) {
  try {
    final r = error.runtimeType.toString();
    try {
      final s = error.toString();
      // Special handling for errors created via factory `Exception(...)` ...
      if (error.runtimeType == Exception().runtimeType) {
        return s;
      }
      if (s.startsWith(r)) {
        return s;
      }
      // Include error.runtimeType in the error message ...
      return '$r: $s';
    } catch (ignored) {
      return r;
    }
  } catch (ignored) {
    return 'Unknown error';
  }
}

String safeToString(dynamic x) {
  try {
    return x == null ? 'null' : x.toString();
  } catch (ignored) {
    return Error.safeToString(x);
  }
}

String toDartString(dynamic value) {
  if (value is String) {
    final s = value.replaceAll(r'\', r'\\').replaceAll('\n', r'\n').replaceAll('\r', r'\r').replaceAll('\t', r'\t');
    if (!s.contains("'")) {
      return "'$s'";
    } else {
      if (!s.contains('"')) {
        return '"$s"';
      } else {
        return "'${s.replaceAll("'", r"\'")}'";
      }
    }
  } else if (value is Map) {
    return '{${value.entries.map((entry) => "'${toDartString(entry.key)}': ${toDartString(entry.value)}").join(', ')}}';
  } else if (value is Set) {
    return '{${value.map(toDartString).join(", ")}}';
  } else if (value is Iterable) {
    return '[${value.map(toDartString).join(", ")}]';
  } else {
    return safeToString(value);
  }
}


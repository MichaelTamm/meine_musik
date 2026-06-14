import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../debug_utils.dart';

class LogViewer extends ConsumerWidget {
  static final viewDataProvider = Provider.autoDispose<List<LogEntry>>((_) => log.getSnapshot());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logEntries = ref.watch(viewDataProvider);
    return Scaffold(
      body: SafeArea(
        child: InteractiveViewer(
          constrained: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...logEntries.map((logEntry) {
                final style = switch (logEntry.level) {
                  Level.debug => _debugStyle,
                  Level.info => _infoStyle,
                  Level.warning => _warningStyle,
                  _ => _errorStyle,
                };
                return Text(logEntry.message, style: style, maxLines: 1);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

final _baseStyle = TextStyle(fontFamily: 'monospace', fontSize: 10.0);
final _debugStyle = _baseStyle.copyWith(color: Colors.grey);
final _infoStyle = _baseStyle.copyWith(color: Colors.black);
final _warningStyle = _baseStyle.copyWith(color: Colors.orange);
final _errorStyle = _baseStyle.copyWith(color: Colors.red);

import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meine_musik/debug_utils.dart';

class FileViewerScreen extends StatelessWidget {
  FileViewerScreen(this.file, {super.key}) : _mimeType = file.mimeType;

  final File file;
  final String _mimeType;

  @override
  Widget build(BuildContext context) {
    final child = switch (_mimeType) {
      _ when _mimeType.startsWith('image/') => _ImageViewer(file),
      'text/plain' => _TextFileViewer(file),
      _ => _HexFileViewer(file),
    };
    return Scaffold(body: SafeArea(child: child));
  }
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer(this.file);

  final File file;

  @override
  Widget build(BuildContext context) => Center(child: Image.file(file, fit: BoxFit.contain));
}

class _TextViewer extends StatelessWidget {
  const _TextViewer(this.lines);

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontFamily: 'monospace', fontSize: 10);
    return InteractiveViewer(
      constrained: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...lines.map((line) => Text(line, style: style, maxLines: 1))],
      ),
    );
  }
}

class _TextFileViewer extends _TextViewer {
  _TextFileViewer(File file) : super(_splitTextIntoLines(file.readAsStringSync()));
}

List<String> _splitTextIntoLines(String text) {
  try {
    final data = jsonDecode(text);
    final json = JsonEncoder.withIndent("  ").convert(data);
    return json.split('\n');
  } catch (ignored) {
    return text.split('\n');
  }
}

class _HexFileViewer extends _TextViewer {
  _HexFileViewer(File file) : super(_linesForHexViewer(file));
}

List<String> _linesForHexViewer(File file) {
  final raf = file.openSync();
  try {
    final first4096Bytes = raf.readSync(4096);
    final lines = first4096Bytes.slices(16).map((bytes) {
      final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
      final ascii = bytes.map((byte) => byte < 32 || byte > 126 ? '.' : String.fromCharCode(byte)).join('');
      return '$hex $ascii';
    }).toList();
    lines.add('...');
    return lines;
  } finally {
    raf.closeSync();
  }
}

extension on File {
  String get mimeType {
    try {
      final raf = openSync();
      try {
        final first4096Bytes = raf.readSync(4096);
        bool headerMatches(int from, List<int> bytes) =>
            first4096Bytes.length >= from + bytes.length &&
            bytes.indexed.every((it) => first4096Bytes[from + it.$1] == it.$2);
        if (headerMatches(0, [0xFF, 0xD8, 0xFF])) return 'image/jpeg';
        if (headerMatches(0, [0x89, 0x50, 0x4E, 0x47])) return 'image/png';
        if (headerMatches(0, [0x47, 0x49, 0x46])) return 'image/gif';
        if (headerMatches(0, [0x52, 0x49, 0x46, 0x46]) && headerMatches(8, [0x57, 0x45, 0x42, 0x50])) return 'image/webp';
        raf.setPositionSync(0);
        if (first4096Bytes.every((it) => it != 0)) return 'text/plain';
      } finally {
        raf.closeSync();
      }
    } catch (error, stack) {
      reportErrorOnce('mimeType getter failed', error, stack);
    }
    return 'application/octet-stream';
  }
}

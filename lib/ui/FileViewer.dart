import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../env.dart';

class FileViewer extends StatelessWidget {
  FileViewer(this.file, {super.key}) : isTextFile = file.isTextFile;

  final File file;
  final bool isTextFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(file.name)),
      body: isTextFile ? _TextFileViewer(file) : _HexFileViewer(file),
    );
  }
}

class _TextViewer extends StatelessWidget {
  const _TextViewer(this.lines);

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontFamily: kIsAppleDevice ? 'Courier' : 'monospace', fontSize: 10);
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

extension on FileSystemEntity {
  String get name => path.substring(path.lastIndexOf('/') + 1);
}

extension on File {
  bool get isTextFile {
    try {
      final raf = openSync();
      try {
        final first4096Bytes = raf.readSync(4096);
        return first4096Bytes.every((it) => it != 0);
      } finally {
        raf.closeSync();
      }
    } catch (error, stack) {
      debugPrintStack(label: '$error', stackTrace: stack);
      return false;
    }
  }
}

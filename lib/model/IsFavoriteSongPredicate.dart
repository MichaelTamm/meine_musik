import 'dart:io';

import 'package:flutter/foundation.dart';

import 'AudioFile.dart';

@immutable
class IsFavoriteSongPredicate {
  static Future<IsFavoriteSongPredicate> fromFile(File file) async {
    final config = await _readIdsFromFile(file);
    return IsFavoriteSongPredicate._(config);
  }

  static Future<Set<int>> _readIdsFromFile(File file) async {
    if (!file.existsSync()) {
      return {};
    }
    final lines = await file.readAsLines();
    final Set<int> ids = {};
    for (final line in lines) {
      final id = int.tryParse(line);
      if (id != null) {
        ids.add(id);
      }
    }
    return ids;
  }

  const IsFavoriteSongPredicate() : _ids = const {};

  const IsFavoriteSongPredicate._(this._ids);

  final Set<int> _ids;

  bool call(AudioFile file) {
    return _ids.contains(file.id);
  }

  Future<void> writeToFile(File file) async {
    final sb = StringBuffer();
    for (final id in _ids) {
      sb.writeln(id.toString());
    }
    final s = sb.toString();
    await file.writeAsString(s);
  }

  IsFavoriteSongPredicate addFile(AudioFile file) {
    return IsFavoriteSongPredicate._({..._ids, file.id});
  }

  IsFavoriteSongPredicate removeFile(AudioFile file) {
    return IsFavoriteSongPredicate._({..._ids.where((id) => id != file.id)});
  }
}

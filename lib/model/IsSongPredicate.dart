import 'dart:io';

import 'package:flutter/foundation.dart';

import 'AudioFile.dart';
import 'AudioFolder.dart';
import 'logic.dart';

@immutable
class IsSongPredicate {
  static Future<IsSongPredicate> fromFile(File file) async {
    final config = await _readConfigFromFile(file);
    return IsSongPredicate._(config);
  }

  static Future<List<(String, bool)>> _readConfigFromFile(File file) async {
    if (!file.existsSync()) {
      return const [];
    }
    final lines = await file.readAsLines();
    final List<(String, bool)> config = [];
    for (final line in lines) {
      if (line.startsWith('+')) {
        final path = line.substring(1).trim();
        config.add((path, true));
      } else if (line.startsWith('-')) {
        final path = line.substring(1).trim();
        config.add((path, false));
      } else {
        continue; // Ignore invalid lines
      }
    }
    return config;
  }

  const IsSongPredicate() : _config = const [];

  const IsSongPredicate._(this._config);

  final List<(String, bool)> _config;

  bool call(AudioFile file) {
    for (final item in _config) {
      if (file.path.startsWith(item.$1)) {
        return item.$2;
      }
    }
    return isSongHeuristic(file);
  }

  Future<void> writeToFile(File file) async {
    final sb = StringBuffer();
    for (var item in _config) {
      sb.write(item.$2 ? '+' : '-');
      sb.write(item.$1);
      sb.write('\n');
    }
    final s = sb.toString();
    await file.writeAsString(s);
  }

  IsSongPredicate whitelistFolder(AudioFolder folder) {
    final path = '${folder.path}/';
    return IsSongPredicate._([(path, true), ..._config.where((item) => item.$1 != path)]);
  }

  IsSongPredicate blacklistFolder(AudioFolder folder) {
    final path = '${folder.path}/';
    return IsSongPredicate._([(path, false), ..._config.where((item) => item.$1 != path)]);
  }

  IsSongPredicate unlistFolder(AudioFolder folder) {
    final path = '${folder.path}/';
    return IsSongPredicate._([..._config.where((item) => item.$1 != path)]);
  }

  IsSongPredicate whitelistFile(AudioFile file) {
    final path = file.path;
    return IsSongPredicate._([(path, true), ..._config.where((item) => item.$1 != path)]);
  }

  IsSongPredicate blacklistFile(AudioFile file) {
    final path = file.path;
    return IsSongPredicate._([(path, false), ..._config.where((item) => item.$1 != path)]);
  }
}

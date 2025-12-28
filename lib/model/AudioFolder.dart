import 'dart:collection';

import 'AudioFile.dart';

/// A Folder on the device that contains audio files.
class AudioFolder {
  AudioFolder(this.name, [List<AudioFolder>? subfolders, List<AudioFile>? files])
    : _subfolders = subfolders ?? [],
      _subfoldersByName = {for (final subfolder in subfolders ?? []) subfolder.name: subfolder},
      _files = files ?? [];

  final String name;
  final List<AudioFolder> _subfolders;
  final Map<String, AudioFolder> _subfoldersByName;
  final List<AudioFile> _files;

  List<AudioFolder> get subfolders => UnmodifiableListView(_subfolders);

  List<AudioFile> get files => UnmodifiableListView(_files);

  String get path {
    final path = _files.isNotEmpty ? _files.first.path : _subfolders.first.path;
    return path.substring(0, path.lastIndexOf('/'));
  }

  /// Side effect: adds folder if not already present
  AudioFolder subfolder(String name) {
    return _subfoldersByName.putIfAbsent(name, () {
      final newSubfolder = AudioFolder(name);
      // TODO: [perf] use binary search instead of linear search
      final i = _subfolders.indexWhere((it) => it.name.compareTo(name) > 0);
      if (i >= 0) {
        _subfolders.insert(i, newSubfolder);
      } else {
        _subfolders.add(newSubfolder);
      }
      return newSubfolder;
    });
  }

  void addFile(AudioFile audioFile) {
    // TODO: [perf] use binary search instead of linear search
    final i = _files.indexWhere((it) => it.fileName.compareTo(name) > 0);
    if (i >= 0) {
      _files.insert(i, audioFile);
    } else {
      _files.add(audioFile);
    }
  }

  @override
  toString() => "$AudioFolder('$name')";
}

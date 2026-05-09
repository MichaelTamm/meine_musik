import 'package:collection/collection.dart';

import 'AudioFile.dart';
import 'AudioFolder.dart';
import 'Song.dart';

final _featuringRegExp = RegExp(r'(\s(ft\.|feat\.|featuring)\s)|,|(, and)');
final _andRegExp = RegExp(r'\s(and|et|e|und|y|&|\+)\s');

class MeineMusikLogic {
  /// Heuristic to determine whether an audio file is a song or not.
  bool isSongHeuristic(AudioFile audioFile) {
    if (audioFile.path.contains('/WhatsApp/')) {
      return false;
    }
    if (audioFile.artist.isEmpty || audioFile.album.isEmpty) {
      return false;
    }
    return audioFile.durationInMilliseconds > 60_000;
  }

  AudioFolder groupAudioFiles(List<AudioFile> audioFiles) {
    final root = AudioFolder('Dieses Gerät');
    for (final audioFile in audioFiles) {
      var path = audioFile.path;
      if (path.startsWith('/storage/emulated/')) {
        path = path.substring('/storage/emulated/'.length);
        final i = path.indexOf('/');
        if (i > 0) {
          path = path.substring(i + 1);
        }
      } else if (path.startsWith('/storage/')) {
        path = path.substring('/storage/'.length);
        final i = path.indexOf('/');
        if (i > 0) {
          path = path.substring(i + 1);
        }
      } else if (path.startsWith('/')) {
        path = path.substring(1);
      }
      final pathComponents = path.split('/');
      final folderNames = pathComponents.sublist(0, pathComponents.length - 1);
      var folder = root;
      for (final folderName in folderNames) {
        folder = folder.subfolder(folderName);
      }
      folder.addFile(audioFile);
    }
    return root;
  }

  /// Heuristic based algorithm to split an artist string into a list of artist names.
  Iterable<String> splitArtistStringHeuristic(String s) sync* {
    final a1 = s.split(_featuringRegExp).map((it) => it.trim()).where((it) => it.isNotEmpty);
    for (final a in a1) {
      final m = _andRegExp.firstMatch(a.toLowerCase());
      if (m == null) {
        yield a;
        continue;
      }
      final name1 = a.substring(0, m.start).trim();
      final name2 = a.substring(m.end).trim();
      final m2 = _andRegExp.firstMatch(name2);
      if (m2 == null) {
        // Heuristic:
        // - if either name1 or name2 is a single word keep the names together
        // - if name2 starts with "the" keep the names together
        // - otherwise split the names
        if (!name1.contains(' ') || !name2.contains(' ') || name2.toLowerCase().startsWith('the ')) {
          yield a;
        } else {
          yield name1;
          yield name2;
        }
      } else {
        // This is very unlikely, let's keep things simple ...
        final names = a.split(_andRegExp).map((it) => it.trim());
        yield* names;
      }
    }
  }

  /// Heuristic based algorithm to determine the artist of an album.
  /// Returns 'verschiedene Künstler' if no dominant artist is found.
  String determineAlbumKuenstlerHeuristic(Iterable<Song> songsOfAlbum) {
    final artistHistogram = <String, int>{};
    for (final artistName in [for (final song in songsOfAlbum) splitArtistStringHeuristic(song.artist)].flattened) {
      artistHistogram[artistName] = (artistHistogram[artistName] ?? 0) + 1;
    }
    final sortedList = artistHistogram.entries.toList()..sort((a, b) => b.value - a.value);
    if (sortedList.isEmpty) {
      return '';
    } else if (sortedList.length == 1) {
      return sortedList[0].key;
    } else {
      final mapEntry1 = sortedList[0];
      final mapEntry2 = sortedList[1];
      // Heuristic: ...
      if (mapEntry1.value >= songsOfAlbum.length * 0.8 && mapEntry2.value <= songsOfAlbum.length / 3) {
        return mapEntry1.key;
      }
      return 'verschiedene Künstler';
    }
  }
}

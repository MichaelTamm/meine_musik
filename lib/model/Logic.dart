import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/riverpod/media.dart';
import 'package:meine_musik/utils.dart';

import 'AudioFile.dart';
import 'AudioFolder.dart';
import 'Song.dart';

class Logic {
  final Map<String, Future<List<String>>> _splitArtistStringCache = {};

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

  Future<List<String>> splitArtistString(String s) => _splitArtistStringCache.putIfAbsent(s, () => _splitArtistString(s).toList());

  Stream<String> _splitArtistString(String s) async* {
    final a1 = s.split(RegExp(r'(\s(ft\.|feat\.|featuring)\s)|,')).map((it) => it.trim()).where((it) => it.isNotEmpty);
    for (final a in a1) {
      var a2 = a.split(RegExp(r'\s(and|und|&)\s')).map((it) => it.trim()).where((it) => it.isNotEmpty);
      try {
        final artist = await riverpodContainer.read(artistProvider(a).future);
        if (artist != null) {
          // Use the actual artist name to avoid duplicates in the Künstler tab ...
          yield artist.name;
          // When searching for "Hans Zimmer & Lisa Gerrard" the artist "Lisa Gerrard" is returned.
          // Make sure we don't ignore "Hans Zimmer" in such a case ...
          if (a2.length > 1 && a2.contains(artist.name)) {
            a2 = a2.where((it) => it != artist.name);
          } else {
            return;
          }
        }
      } catch (error, stack) {
        if (kIsTest) {
          rethrow;
        } else {
          debugPrintStack(label: 'Failed to get artist ${toDartString(a)} -- $error', stackTrace: stack);
        }
      }
      for (final a in a2) {
        try {
          final artist = await riverpodContainer.read(artistProvider(a).future);
          if (artist != null) {
            // Use the actual artist name to avoid duplicates in the Künstler tab ...
            yield artist.name;
          } else {
            yield a;
          }
        } catch (error, stack) {
          if (kIsTest) {
            rethrow;
          } else {
            debugPrintStack(label: 'Failed to get artist ${toDartString(a)} -- $error', stackTrace: stack);
            yield a;
          }
        }
      }
    }
  }

  Future<String> determineAlbumKuenstler(Iterable<Song> songs) async {
    final artistHistogram = <String, int>{};
    final artistNamesFutures = [for (final song in songs) splitArtistString(song.artist)];
    for (final artistName in (await Future.wait(artistNamesFutures)).flattened) {
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
      if (mapEntry1.value >= songs.length * 0.8 && mapEntry2.value <= songs.length / 3) {
        return mapEntry1.key;
      }
      return 'verschiedene Künstler';
    }
  }
}

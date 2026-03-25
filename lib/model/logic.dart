import 'AudioFile.dart';
import 'AudioFolder.dart';
import 'Song.dart';

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

Iterable<String> splitArtistString(String artist) {
  return artist.split(RegExp(r'(\s(and|und|feat\.|featuring)\s)|,|&')).map((it) => it.trim()).where((it) => it.isNotEmpty);
}

String determineAlbumKuenstler(Iterable<Song> songs) {
  final artistHistogram = <String, int>{};
  for (final song in songs) {
    for (final artist in splitArtistString(song.artist)) {
      artistHistogram[artist] = (artistHistogram[artist] ?? 0) + 1;
    }
  }
  final list = artistHistogram.entries.toList()..sort((a, b) => b.value - a.value);
  if (list.isEmpty) {
    return '';
  } else if (list.length == 1) {
    return list[0].key;
  } else {
    final mapEntry1 = list[0];
    final mapEntry2 = list[1];
    // Heuristic: ...
    if (mapEntry1.value >= songs.length * 0.8 && mapEntry2.value <= songs.length / 3) {
      return mapEntry1.key;
    }
    return 'verschiedene Künstler';
  }
}
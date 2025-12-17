import 'AudioFile.dart';
import 'AudioFolder.dart';

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

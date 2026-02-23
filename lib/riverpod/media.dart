import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../env.dart';
import '../model/AudioFile.dart';
import '../model/Playlist.dart';
import '../model/Song.dart';

part 'media.g.dart';

@Riverpod(keepAlive: true)
Future<List<AudioFile>> localAudioFiles(Ref ref) async {
  if (!kIsTest) {
    final apiLevel = await kMethodChannel.invokeMethod<int>("getApiLevel");
    if (apiLevel == null) {
      throw Exception('apiLevel == null');
    } else if (apiLevel < 33) {
      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        throw Exception('Permission.storage not granted');
      }
    } else {
      final permission = await Permission.audio.request();
      if (!permission.isGranted) {
        throw Exception('Permission.audio not granted');
      }
    }
  }
  final audioFiles = await audioService.findAll();
  if (kDebugMode) {
    debugPrint('Found ${audioFiles.length} audio files:');
    for (final audioFile in audioFiles) {
      debugPrint('    ${audioFile.path}');
    }
  }
  return audioFiles;
}

@Riverpod(keepAlive: true)
Future<Map<int, AudioFile>> localAudioFilesById(Ref ref) async {
  final localAudioFiles = await ref.watch(localAudioFilesProvider.future);
  final localAudioFilesById = <int, AudioFile>{};
  for (final audioFile in localAudioFiles) {
    localAudioFilesById[audioFile.id] = audioFile;
  }
  return localAudioFilesById;
}

@Riverpod(keepAlive: true)
Future<Uint8List?> songThumbnail(Ref ref, Song song) async {
  final albumCover = await audioService.getAlbumCover(song.path);
  return albumCover;
}

@Riverpod(keepAlive: true)
Future<Uint8List?> albumCover(Ref ref, Album album) async {
  final albumCover = await audioService.getAlbumCover(album.firstSong.path);
  return albumCover;
}

@Riverpod(keepAlive: true)
Future<Uint8List?> artistImage(Ref ref, String artistName) async {
  // TODO: ...
  return null;
}

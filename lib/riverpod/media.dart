import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../env.dart';
import '../model/AudioFile.dart';

part 'media.g.dart';

@riverpod
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

  ref.keepAlive();
  return audioFiles;
}

@riverpod
Future<Map<int, AudioFile>> localAudioFilesById(Ref ref) async {
  final localAudioFiles = await ref.watch(localAudioFilesProvider.future);
  final localAudioFilesById = <int, AudioFile>{};
  for (final audioFile in localAudioFiles) {
    localAudioFilesById[audioFile.id] = audioFile;
  }
  ref.keepAlive();
  return localAudioFilesById;
}

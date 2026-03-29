import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../drift/database.dart';
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
    final n = audioFiles.length;
    debugPrint(n == 0 ? 'Did not find an audio file.' : n == 1 ? 'Found 1 audio file:' : 'Found $n audio files:');
    for (final audioFile in audioFiles) {
      debugPrint('    ${audioFile.path} (artist: ${audioFile.artist}, title: ${audioFile.title}, album: ${audioFile.album})');
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
Future<MusicBrainzArtist?> artist(Ref ref, String artistName) {
  return musicBrainz.searchArtistByName(artistName);
}

@Riverpod(keepAlive: false)
Future<Uint8List?> songThumbnail(Ref ref, Song song) async {
  final albumCover = await audioService.getAlbumCover(song.path);
  // TODO: try to find album cover on the internet
  return albumCover;
}

@Riverpod(keepAlive: false)
Future<Uint8List?> albumCoverThumbnail(Ref ref, Album album) async {
  var albumCover = await audioService.getAlbumCover(album.firstSong.path);
  if (albumCover == null) {
    final release = await musicBrainz.searchReleaseByAlbum(album);
    if (release != null) {
      final mbid = release.mbid;
      final thumbnailDir = Directory('${applicationCacheDirectory.path}/album-thumbnails/${mbid.substring(0, 2)}');
      final thumbnailFile = File('${thumbnailDir.path}/$mbid.thumbnail');
      if (thumbnailFile.existsSync()) {
        albumCover = await thumbnailFile.readAsBytes();
      } else {
        albumCover = await coverArtArchive.getAlbumCoverThumbnail(mbid);
        if (albumCover != null) {
          if (!thumbnailDir.existsSync()) {
            thumbnailDir.createSync(recursive: true);
          }
          await thumbnailFile.writeAsBytes(albumCover);
        }
      }
    }
  }
  return albumCover;
}

@Riverpod(keepAlive: false)
Future<Uint8List?> artistThumbnail(Ref ref, String artistName) async {
  Uint8List? thumbnail;
  final artist = await ref.watch(artistProvider(artistName).future);
  if (artist != null) {
    final mbid = artist.mbid;
    final thumbnailDir = Directory('${applicationCacheDirectory.path}/artist-thumbnails/${mbid.substring(0, 2)}');
    final thumbnailFile = File('${thumbnailDir.path}/$mbid.thumbnail');
    if (thumbnailFile.existsSync()) {
      thumbnail = await thumbnailFile.readAsBytes();
    } else {
      thumbnail = await theAudioDB.getArtistThumbnail(mbid);
      if (thumbnail != null) {
        if (!thumbnailDir.existsSync()) {
          thumbnailDir.createSync(recursive: true);
        }
        await thumbnailFile.writeAsBytes(thumbnail);
      }
    }
  }
  return thumbnail;
}

@Riverpod(keepAlive: true)
Future<IconData> artistIcon(Ref ref, String artistName) async {
  final artist = await ref.watch(artistProvider(artistName).future);
  if (artist != null) {
    final type = artist.type;
    return type == 'Person' || type == 'Character' ? Icons.person : Icons.group;
  }
  return Icons.question_mark;
}

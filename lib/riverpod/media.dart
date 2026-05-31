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

@Riverpod(keepAlive: false)
Future<Song> songById(Ref ref, int songId) async {
  final localAudioFilesById = await ref.watch(localAudioFilesByIdProvider.future);
  final song = localAudioFilesById[songId];
  if (song == null) {
    throw Exception('Could not find song with id $songId');
  }
  return song;
}

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
  final audioFiles = await nativeMethods.findAll();
  if (kDebugMode) {
    final n = audioFiles.length;
    debugPrint(
      n == 0
          ? 'Did not find an audio file.'
          : n == 1
          ? 'Found 1 audio file:'
          : 'Found $n audio files:',
    );
    for (final audioFile in audioFiles) {
      debugPrint('    $audioFile');
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
Future<MusicBrainzArtist?> artist(Ref ref, KuenstlerSongs kuenstlerSongs) {
  return musicBrainz.searchArtist(kuenstlerSongs.kuenstler, kuenstlerSongs);
}

@Riverpod(keepAlive: false)
Future<Uint8List?> songThumbnail(Ref ref, Song song) async {
  final albumCover = await nativeMethods.getAlbumCover(song.path);
  // TODO: try to find album cover on the internet
  return albumCover;
}

@Riverpod(keepAlive: false)
Future<Uint8List?> albumCoverThumbnail(Ref ref, Album album) async {
  var albumCover = await nativeMethods.getAlbumCover(album.first.path);
  if (albumCover == null) {
    final release = await musicBrainz.searchRelease(album);
    if (release != null) {
      final mbid = release.mbid;
      final thumbnailsDir = Directory('${applicationCacheDirectory.path}/album-thumbnails');
      albumCover = await _loadOrFetchThumbnail(thumbnailsDir, mbid, fetch: () => coverArtArchive.getAlbumCoverThumbnail(mbid));
    }
  }
  return albumCover;
}

@Riverpod(keepAlive: false)
Future<Uint8List?> artistThumbnail(Ref ref, KuenstlerSongs kuenstlerSongs) async {
  Uint8List? thumbnail;
  final artist = await ref.watch(artistProvider(kuenstlerSongs).future);
  if (artist != null) {
    final mbid = artist.mbid;
    final thumbnailsDir = Directory('${applicationCacheDirectory.path}/artist-thumbnails');
    thumbnail = await _loadOrFetchThumbnail(thumbnailsDir, mbid, fetch: () => theAudioDB.getArtistThumbnail(mbid));
  }
  return thumbnail;
}

@Riverpod(keepAlive: true)
Future<IconData> artistIcon(Ref ref, KuenstlerSongs kuenstlerSongs) async {
  final artist = await ref.watch(artistProvider(kuenstlerSongs).future);
  if (artist != null) {
    final type = artist.type;
    return type == 'Person' || type == 'Character' ? Icons.person : Icons.group;
  }
  return Icons.question_mark;
}

Future<Uint8List?> _loadOrFetchThumbnail(Directory thumbnailsDir, String mbid, {required Future<Uint8List?> Function() fetch}) async {
  final thumbnailDir = Directory('${thumbnailsDir.path}/${mbid.substring(0, 2)}');
  final thumbnailFile = File('${thumbnailDir.path}/$mbid.thumbnail');
  if (thumbnailFile.existsSync()) {
    return thumbnailFile.readAsBytes();
  }
  final data = await fetch();
  if (data != null) {
    if (!thumbnailDir.existsSync()) {
      thumbnailDir.createSync(recursive: true);
    }
    await thumbnailFile.writeAsBytes(data);
  }
  return data;
}

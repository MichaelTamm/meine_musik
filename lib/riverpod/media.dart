import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:string_normalizer/string_normalizer.dart';

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
    debugPrint('Found ${audioFiles.length} audio files:');
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
Future<Artist?> artist(Ref ref, String artistName) async {
  final artist = await db.findArtistByName(artistName);
  if (artist == null) {
    final data = await musicBrainz.artists.search(artistName, limit: 5);
    final normalizedArtistName = artistName.normalize();
    final matches = (data['artists'] as List<dynamic>)
        .where((it) => (it['score'] as num) == 100 || (it['name'] as String).normalize() == normalizedArtistName)
        .toList();
    if (matches.length == 1) {
      final id = matches[0]['id'] as String;
      final type = matches[0]['type'] as String;
      await db.artists.insertOne(ArtistsCompanion.insert(mbid: id, name: artistName, type: type));
      return Artist(mbid: id, name: artistName, type: type);
    } else {
      // TODO: Disambiguate by querying and comparing known songs.
    }
  }
  return artist;
}

@Riverpod(keepAlive: true)
Future<Uint8List?> songThumbnail(Ref ref, Song song) async {
  final albumCover = await audioService.getAlbumCover(song.path);
  return albumCover;
}

@Riverpod(keepAlive: true)
Future<Uint8List?> albumCoverThumbnail(Ref ref, Album album) async {
  var albumCover = await audioService.getAlbumCover(album.firstSong.path);
  if (albumCover == null) {
    var release = await db.findReleaseBySongId(album.firstSong.id);
    if (release == null) {
      final kuenstler = album.kuenstler;
      if (kuenstler.isNotEmpty && kuenstler != 'verschiedene Künstler') {
        // Search release groups of artist ...
        final artist = await ref.watch(artistProvider(kuenstler).future);
        if (artist != null) {
          // TODO: ...final data = await musicBrainz.releaseGroups.search(album.name, artist: artist.mbid);
        }
      } else {
        // Search by album title ...
        final data = await musicBrainz.releases.search(album.name);
        final normalizedAlbumName = album.name.normalize();
        final matches = (data['releases'] as List<dynamic>)
            .where((it) => (it['score'] as num) == 100 || (it['title'] as String).normalize() == normalizedAlbumName)
            .toList();
        if (matches.length == 1) {
          final mbid = matches[0]['id'] as String;
          final songIds = '|${album.map((song) => song.id).join('|')}|';
          await db.releases.insertOne(ReleasesCompanion.insert(mbid: mbid, songIds: songIds));
          release = Release(mbid: mbid, songIds: songIds);
        } else {
          // TODO: Disambiguate by songs ...
          // for (final match in matches) {
          //   final id = match['id'] as String;
          //   final releaseData = await musicBrainz.releases.get(id, inc: ['recordings']);
          //   ...
          // }
        }
      }
    }
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

@Riverpod(keepAlive: true)
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

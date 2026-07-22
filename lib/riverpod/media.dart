import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meine_musik/debug_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../drift/database.dart';
import '../env.dart';
import '../model/AudioFile.dart';
import '../model/Playlist.dart';
import '../model/Song.dart';
import '../utils.dart';

part 'media.g.dart';

/// Re-checks the audio/storage permission status whenever the app comes to the foreground.
/// When resumed (i.e. Activity is visible on the phone), also calls .request() to show the
/// system permission dialog if needed. On Android Auto there is no Activity, so
/// didChangeAppLifecycleState(resumed) is never fired and .request() is never called.
@Riverpod(keepAlive: true)
class CanAccessAudioFiles extends _$CanAccessAudioFiles with WidgetsBindingObserver {
  @override
  bool build() {
    if (kIsTest) {
      return true;
    }
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    final isResumed = WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    checkPermission(requestIfNeeded: isResumed);
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkPermission(requestIfNeeded: true);
    }
  }

  Future<bool> checkPermission({bool requestIfNeeded = false}) async {
    final apiLevel = await kMethodChannel.invokeMethod<int>("getApiLevel");
    if (apiLevel == null) {
      throw Exception('apiLevel == null');
    }
    final permission = apiLevel < 33 ? Permission.storage : Permission.audio;
    var granted = await permission.status.isGranted;
    if (!granted && requestIfNeeded) {
      final result = await permission.request();
      granted = result.isGranted;
    }
    if (granted != state) {
      state = granted;
    }
    return granted;
  }
}

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
    final canAccess = ref.watch(canAccessAudioFilesProvider);
    if (!canAccess) {
      return [];
    }
  }
  final audioFiles = await nativeMethods.findAll();
  if (kDebugMode) {
    final n = audioFiles.length;
    debugPrint(
      n == 0
          ? 'Did not find an audio file.'
          : n == 1
          ? 'Found 1 audio file'
          : 'Found $n audio files',
    );
    for (final audioFile in audioFiles.take(3)) {
      debugPrint('    $audioFile');
    }
    if (n > 3) {
      if (n > 4) {
        debugPrint('    ...');
      }
      debugPrint('    ${audioFiles.last}');
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

  // 1. Check for *.jpg, *.png, and *.webp file ...
  for (final ext in ['jpg', 'png', 'webp']) {
    final file = File('${thumbnailDir.path}/$mbid.$ext');
    if (file.existsSync()) {
      return file.readAsBytes();
    }
  }

  // 2. Check for old *.thumbnail file and try to migrate it ...
  final thumbnailFile = File('${thumbnailDir.path}/$mbid.thumbnail');
  if (thumbnailFile.existsSync()) {
    final data = await thumbnailFile.readAsBytes();
    final ext = determineFilenameExtension(data);
    if (ext == null) {
      final hex = data.take(20).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
      reportErrorOnce('${thumbnailFile.name} has unknown image format. First 20 bytes: $hex');
    } else {
      try {
        await thumbnailFile.rename('${thumbnailDir.path}/$mbid.$ext');
        debugPrint('Renamed $mbid.thumbnail to $mbid.$ext');
      } catch (error) {
        reportErrorOnce('Failed to rename $mbid.thumbnail to $mbid.$ext', error);
      }
    }
    return data;
  }

  final data = await fetch();
  if (data != null) {
    if (!thumbnailDir.existsSync()) {
      thumbnailDir.createSync(recursive: true);
    }
    final ext = determineFilenameExtension(data);
    if (ext != null) {
      await File('${thumbnailDir.path}/$mbid.$ext').writeAsBytes(data);
    } else {
      final hex = data.take(20).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
      reportErrorOnce('Unknown image format for MBID $mbid. First 20 bytes: $hex');
      // Still save it as *.thumbnail file, so we don't fetch it again and again ...
      await File('${thumbnailDir.path}/$mbid.thumbnail').writeAsBytes(data);
    }
  }
  return data;
}

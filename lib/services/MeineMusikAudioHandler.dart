import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meine_musik/utils.dart';
import 'package:path/path.dart';

import '../env.dart';
import '../model/PlayingPausedOrCompleted.dart';
import '../model/Playlist.dart';
import '../model/Song.dart';
import '../riverpod/media.dart';
import '../riverpod/player_state.dart';
import '../riverpod/playlists.dart';
import '../ui/tabs/AlbenTab.dart';
import '../ui/tabs/KuenstlerTab.dart';

/// See https://github.com/ryanheise/audio_service/wiki/Tutorial
class MeineMusikAudioHandler extends BaseAudioHandler {
  void init() {
    riverpodContainer.listen(currentSongProvider, (_, currentSong) {
      debugPrint('[$MeineMusikAudioHandler] current song changed to: $currentSong');
      if (currentSong.id == 0) {
        return;
      }
      var title = currentSong.title;
      if (title.isEmpty || title.startsWith('<') || title == 'unknown' || title == 'null') {
        title = basename(currentSong.fileName);
      }
      mediaItem.add(
        MediaItem(
          id: currentSong.id.toString(),
          title: title,
          album: currentSong.album,
          artist: currentSong.artist,
          duration: Duration(milliseconds: currentSong.durationInMilliseconds),
          // TODO: add cover art
        ),
      );
      playbackState.add(playbackState.value.copyWith(updatePosition: Duration.zero));
    });
    riverpodContainer.listen<PlayingPausedOrCompleted>(isPlayingPausedOrCompletedProvider, (_, state) {
      debugPrint('[$MeineMusikAudioHandler] player state changed to: $state');
      playbackState.add(
        playbackState.value.copyWith(
          processingState: state == completed ? AudioProcessingState.completed : AudioProcessingState.ready,
          playing: state == playing,
          controls: [MediaControl.skipToPrevious, state == playing ? MediaControl.pause : MediaControl.play, MediaControl.skipToNext],
          systemActions: {MediaAction.skipToPrevious, state == playing ? MediaAction.pause : MediaAction.play, MediaAction.skipToNext},
          androidCompactActionIndices: [0, 1, 2],
          updatePosition: riverpodContainer.read(currentSongPositionProvider),
        ),
      );
    });
  }

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId, [Map<String, dynamic>? options]) async {
    debugPrint('$MeineMusikAudioHandler.getChildren(${toDartString(parentMediaId)}, ...) called');
    // 1. Ebene ...
    if (parentMediaId == AudioService.browsableRootId) {
      return [
        MediaItem(id: 'Playlists', title: 'Playlists', playable: false, extras: {'browsable': true}),
        MediaItem(id: 'Alben', title: 'Alben', playable: false, extras: {'browsable': true}),
        MediaItem(id: 'Künstler', title: 'Künstler', playable: false, extras: {'browsable': true}),
      ];
    }

    final canAccessAudioFiles = riverpodContainer.read(canAccessAudioFilesProvider);
    if (!canAccessAudioFiles) {
      return [
        const MediaItem(
          id: 'no_permission',
          title: 'Bitte öffne die App auf dem Handy und erlaube den Zugriff auf Musik- und Audiodateien.',
          playable: false,
        ),
      ];
    }

    // 2. Ebene: Playlists ...
    if (parentMediaId == 'Playlists') {
      final playlists = await riverpodContainer.read(playlistsProvider.future);
      return playlists
          .map((it) => MediaItem(id: 'Playlist: ${it.name}', title: it.name, playable: true, extras: {'browsable': true}))
          .toList();
    }
    // 2. Ebene: Alben ...
    if (parentMediaId == 'Alben') {
      final alben = await riverpodContainer.read(AlbenTab.viewDataProvider.future);
      return Future.wait(alben.map((it) => it.toMediaItem()));
    }
    // 2. Ebene: Künstler ...
    if (parentMediaId == 'Künstler') {
      final kuenstler = await riverpodContainer.read(KuenstlerTab.viewDataProvider.future);
      return Future.wait(kuenstler.map((it) => it.toMediaItem()));
    }
    // 3. Ebene: Lieder einer Playlist ...
    if (parentMediaId.startsWith('Playlist: ')) {
      final playlistName = parentMediaId.substring('Playlist: '.length);
      final playlists = await riverpodContainer.read(playlistsProvider.future);
      final playlist = playlists.firstWhereOrNull((it) => it.name == playlistName);
      if (playlist != null) {
        return Future.wait(playlist.map((song) => song.toMediaItem()));
      }
    }
    // 3. Ebene: Lieder eines Albums ...
    if (parentMediaId.startsWith('Album: ')) {
      final albums = await riverpodContainer.read(AlbenTab.viewDataProvider.future);
      final album = albums.firstWhereOrNull((it) => 'Album: ${it.name} (${it.kuenstler})' == parentMediaId);
      if (album != null) {
        return Future.wait(album.map((song) => song.toMediaItem()));
      }
    }
    // 3. Ebene: Lieder eines Künstlers ...
    if (parentMediaId.startsWith('Künstler: ')) {
      final kuenstlerName = parentMediaId.substring('Künstler: '.length);
      final kuenstler = await riverpodContainer.read(KuenstlerTab.viewDataProvider.future);
      final kuenstlerSongs = kuenstler.firstWhereOrNull((it) => it.kuenstler == kuenstlerName);
      if (kuenstlerSongs != null) {
        return Future.wait(kuenstlerSongs.map((song) => song.toMediaItem()));
      }
    }
    return [];
  }

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) async {
    debugPrint('$MeineMusikAudioHandler.playFromMediaId(${toDartString(mediaId)}) called');
    if (mediaId.startsWith('Playlist: ')) {
      final playlistName = mediaId.substring('Playlist: '.length);
      final playlists = await riverpodContainer.read(playlistsProvider.future);
      final playlist = playlists.firstWhereOrNull((it) => it.name == playlistName);
      if (playlist == null) {
        throw Exception('Playlist ${toDartString(playlistName)} not found');
      }
      debugPrint('[$MeineMusikAudioHandler.playFromMediaId(${toDartString(mediaId)})] play $playlist ...');
      _player.playPlaylist(playlist);
    } else if (mediaId.startsWith('Album: ')) {
      final albums = await riverpodContainer.read(AlbenTab.viewDataProvider.future);
      final album = albums.firstWhereOrNull((it) => 'Album: ${it.name} (${it.kuenstler})' == mediaId);
      if (album == null) {
        throw Exception('Album ${toDartString(mediaId.substring('Album: '.length))} not found');
      }
      debugPrint('[$MeineMusikAudioHandler.playFromMediaId(${toDartString(mediaId)})] play $album ...');
      _player.playPlaylist(album);
    } else if (mediaId.startsWith('Künstler: ')) {
      final kuenstlerName = mediaId.substring('Künstler: '.length);
      final kuenstlerSongsList = await riverpodContainer.read(KuenstlerTab.viewDataProvider.future);
      final kuenstlerSongs = kuenstlerSongsList.firstWhereOrNull((it) => it.kuenstler == kuenstlerName);
      if (kuenstlerSongs == null) {
        throw Exception('Künstler ${toDartString(kuenstlerName)} not found');
      }
      debugPrint('[$MeineMusikAudioHandler.playFromMediaId(${toDartString(mediaId)})] play $kuenstlerSongs ...');
      _player.playPlaylist(kuenstlerSongs);
    } else if (mediaId.startsWith('Song: ')) {
      final songId = int.parse(mediaId.substring('Song: '.length));
      final song = await riverpodContainer.read(songByIdProvider(songId).future);
      debugPrint('[$MeineMusikAudioHandler.playFromMediaId(${toDartString(mediaId)})] play $song ...');
      _player.playSong(song);
    } else {
      throw Exception('Unexpected mediaId: ${toDartString(mediaId)}');
    }
  }

  @override
  Future<void> play() async {
    try {
      final playerState = riverpodContainer.read(isPlayingPausedOrCompletedProvider);
      switch (playerState) {
        case playing:
          debugPrint('[$MeineMusikAudioHandler.play()] already playing -- do nothing');
        case paused:
          debugPrint('[$MeineMusikAudioHandler.play()] resume playing ...');
          _player.resume();
        case completed:
          debugPrint('[$MeineMusikAudioHandler.play()] play last song again ...');
          _player.playCurrentSongAgain();
      }
    } catch (error, stack) {
      debugPrintStack(label: '$MeineMusikAudioHandler.play() failed -- ${safeErrorToString(error)}', stackTrace: stack);
    }
  }

  @override
  Future<void> pause() async {
    try {
      final playerState = riverpodContainer.read(isPlayingPausedOrCompletedProvider);
      switch (playerState) {
        case playing:
          debugPrint('[$MeineMusikAudioHandler.pause()] pause playing ...');
          _player.pause();
          break;
        case paused:
        case completed:
          debugPrint('[$MeineMusikAudioHandler.pause()] not playing -- do nothing');
      }
    } catch (error, stack) {
      debugPrintStack(label: '$MeineMusikAudioHandler.pause() failed -- ${safeErrorToString(error)}', stackTrace: stack);
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      debugPrint('[$MeineMusikAudioHandler.seek(...)] seeking to position $position ...');
      _player.seekToPosition(position);
    } catch (error, stack) {
      debugPrintStack(label: '$MeineMusikAudioHandler.seek($position) failed -- ${safeErrorToString(error)}', stackTrace: stack);
    }
  }

  @override
  Future<void> skipToNext() async {
    try {
      final currentPlaylist = riverpodContainer.read(currentPlaylistProvider);
      final currentSong = riverpodContainer.read(currentSongProvider);
      if (currentSong == currentPlaylist.lastSong) {
        debugPrint('[$MeineMusikAudioHandler.skipToNext()] current song is the last song of the current play list -- do nothing');
      } else {
        debugPrint('[$MeineMusikAudioHandler.skipToNext()] playing next song ...');
        _player.playNextSong();
      }
    } catch (error, stack) {
      debugPrintStack(label: '$MeineMusikAudioHandler.skipToNext() failed: -- ${safeErrorToString(error)}', stackTrace: stack);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    try {
      final playerState = riverpodContainer.read(isPlayingPausedOrCompletedProvider);
      final currentPlaylist = riverpodContainer.read(currentPlaylistProvider);
      final currentSong = riverpodContainer.read(currentSongProvider);
      final currentSongPosition = riverpodContainer.read(currentSongPositionProvider);
      final atStartOfSong = currentSongPosition < Duration(milliseconds: min(5000, (currentSong.durationInMilliseconds / 5).round()));
      if (currentSong == currentPlaylist.firstSong) {
        debugPrint(
          '[$MeineMusikAudioHandler.skipToPrevious()] current song is first song of current playlist -- seeking to start of current song ...',
        );
        _player.seekToPosition(Duration.zero);
      } else if (playerState != playing || atStartOfSong) {
        debugPrint('[$MeineMusikAudioHandler.skipToPrevious()] playing previous song ...');
        _player.playPreviousSong();
      } else {
        debugPrint(
          '[$MeineMusikAudioHandler.skipToPrevious()] current song position is: $currentSongPosition -- seeking to start of current song ...',
        );
        _player.seekToPosition(Duration.zero);
      }
    } catch (error, stack) {
      debugPrintStack(label: '$MeineMusikAudioHandler.skipToPrevious() failed: -- ${safeErrorToString(error)}', stackTrace: stack);
    }
  }

  @override
  Future<void> stop() async {
    try {
      debugPrint('[$MeineMusikAudioHandler.stop()] resetting player ...');
      _player.reset();
      await super.stop();
    } catch (error, stack) {
      debugPrintStack(label: '$MeineMusikAudioHandler.stop() failed -- ${safeErrorToString(error)}', stackTrace: stack);
    }
  }

  AudioPlayerWrapper get _player => riverpodContainer.read(playerProvider);
}

extension on KuenstlerSongs {
  Future<MediaItem> toMediaItem() async {
    final artUri = await getArtUri();
    return MediaItem(
      id: 'Künstler: $kuenstler',
      title: kuenstler,
      artist: kuenstler,
      artUri: artUri,
      playable: true,
      duration: duration,
      extras: {'browsable': true},
    );
  }

  Future<Uri?> getArtUri() async {
    final artist = await db.findArtistByName(kuenstler);
    if (artist != null) {
      final thumbnailFile = File('${applicationCacheDirectory.path}/artist-thumbnails/${artist.mbid}.thumbnail');
      if (thumbnailFile.existsSync()) {
        return Uri.file(thumbnailFile.path);
      }
    }
    return null;
  }
}

extension on Album {
  Future<MediaItem> toMediaItem() async {
    final artUri = await firstSong.getArtUri();
    return MediaItem(
      id: 'Album: $name ($kuenstler)',
      title: name,
      album: name,
      artist: kuenstler,
      artUri: artUri,
      playable: true,
      duration: duration,
      extras: {'browsable': true},
    );
  }
}

extension on Song {
  Future<Uri?> getArtUri() async {
    final release = await db.findReleaseBySongId(id);
    if (release != null) {
      final thumbnailFile = File('${applicationCacheDirectory.path}/album-thumbnails/${release.mbid}.thumbnail');
      if (thumbnailFile.existsSync()) {
        return Uri.file(thumbnailFile.path);
      }
    }
    return null;
  }

  Future<MediaItem> toMediaItem() async {
    final artUri = await getArtUri();
    return MediaItem(
      id: 'Song: $id',
      title: title.isNotEmpty ? title : basename(fileName),
      album: album,
      artist: this.artist,
      artUri: artUri,
      duration: Duration(milliseconds: durationInMilliseconds),
      playable: true,
    );
  }
}

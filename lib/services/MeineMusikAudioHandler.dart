import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:meine_musik/utils.dart';
import 'package:path/path.dart';

import '../env.dart';
import '../model/PlayingPausedOrCompleted.dart';
import '../model/Song.dart';
import '../riverpod/player_state.dart';

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

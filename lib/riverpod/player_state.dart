import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:meine_musik/utils.dart';
import 'package:path/path.dart' show basename;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/PlayingPausedOrCompleted.dart';
import '../model/Playlist.dart';
import '../model/RepeatMode.dart';
import '../model/Song.dart';

part 'player_state.g.dart';

final _noSong = Song(id: 0, path: '', sizeInBytes: 0, title: "", artist: '', album: '', trackNumber: 0, durationInMilliseconds: 0);

/// The playlist, which is currently being played.
/// Initial value: `Playlist.empty`
@Riverpod(keepAlive: true)
class CurrentPlaylist extends _$CurrentPlaylist {
  @override
  Playlist build() => Playlist.empty;

  void set(Playlist playlist) {
    state = playlist;
    if (playlist.isEmpty) {
      _resetPlayerState(ref, setCurrentPlaylist: false);
    } else {
      ref.read(currentSongProvider.notifier)._set(playlist.firstSong, playlistIndex: playlist.playOrder[0], playOrderIndex: 0);
    }
  }
}

/// The song currently being played.
/// Initial value: [CurrentSong.none]
@Riverpod(keepAlive: true)
class CurrentSong extends _$CurrentSong {
  static final ({Song song, String label, Duration duration, int playlistIndex, int playOrderIndex}) none = (
    song: _noSong,
    label: '',
    duration: Duration.zero,
    playlistIndex: -1,
    playOrderIndex: -1,
  );

  @override
  ({Song song, String label, Duration duration, int playlistIndex, int playOrderIndex}) build() => none;

  void _set(Song song, {required int playlistIndex, required int playOrderIndex}) {
    var label = song.title;
    if (label.isEmpty || label.startsWith('<') || label == 'unknown' || label == 'null') {
      label = basename(song.fileName);
    } else {
      final artist = song.artist;
      if (artist.isNotEmpty && !artist.startsWith('<') && artist != 'unknown' && artist != 'null') {
        label = '$artist: $label';
      }
    }
    final newState = (
      song: song,
      label: label,
      duration: Duration(milliseconds: song.durationInMilliseconds),
      playlistIndex: playlistIndex,
      playOrderIndex: playOrderIndex,
    );
    state = newState;
  }

  void _reset() {
    state = none;
  }
}

@Riverpod(keepAlive: true)
class CurrentSongPosition extends _$CurrentSongPosition {
  @override
  Duration build() => Duration.zero;

  void set(Duration value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class IsPlayingPausedOrCompleted extends _$IsPlayingPausedOrCompleted {
  @override
  PlayingPausedOrCompleted build() => PlayingPausedOrCompleted.completed;

  void set(PlayingPausedOrCompleted value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class CurrentRepeatMode extends _$CurrentRepeatMode {
  @override
  RepeatMode build() => RepeatMode.none;

  void set(RepeatMode repeatMode) {
    state = repeatMode;
  }

  void _onSwitchedSongSamePlaylist() {
    if (state == RepeatMode.repeatSongOnce || state == RepeatMode.repeatSong) {
      set(RepeatMode.none);
    }
  }
}

class AudioPlayerWrapper {
  AudioPlayerWrapper(this._audioPlayer, this._ref);

  final AudioPlayer _audioPlayer;
  final Ref _ref;

  /// If not `null` this is the position the `AudioPlayer` is (or should be) seeking to.
  Duration? _seekToPosition;

  void playSong(Song song) {
    _seekToPosition = null;
    final currentPlaylist = _ref.read(currentPlaylistProvider);
    final indexes = currentPlaylist.indexesOf(song);
    if (indexes != null) {
      _ref.read(currentSongProvider.notifier)._set(song, playlistIndex: indexes.playlistIndex, playOrderIndex: indexes.playOrderIndex);
    } else {
      _ref.read(currentPlaylistProvider.notifier).set(PlayASongPlaylist(song));
      _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
    }
    _audioPlayer.play(song.source);
  }

  void playPlaylist(Playlist playlist) {
    _seekToPosition = null;
    _ref.read(currentPlaylistProvider.notifier).set(playlist);
    if (playlist.isEmpty) {
      _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(completed);
      _audioPlayer.stop();
    } else {
      _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
      _audioPlayer.play(playlist.firstSong.source);
    }
  }

  void playPreviousSong() {
    final currentPlaylist = _ref.read(currentPlaylistProvider);
    if (currentPlaylist.length <= 1) {
      throw StateError('Cannot play previous song: current playlist has length: ${currentPlaylist.length}');
    }
    final currentSong = _ref.read(currentSongProvider);
    final playOrderIndex = currentSong.playOrderIndex;
    if (playOrderIndex == 0) {
      throw StateError('Cannot play previous song: current song is first song of current playlist');
    }
    final prevPlayOrderIndex = playOrderIndex - 1;
    final prevPlaylistIndex = currentPlaylist.playOrder[prevPlayOrderIndex];
    final prevSong = currentPlaylist[prevPlaylistIndex];
    _seekToPosition = null;
    _ref.read(currentSongProvider.notifier)._set(prevSong, playlistIndex: prevPlaylistIndex, playOrderIndex: prevPlayOrderIndex);
    _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
    _audioPlayer.play(prevSong.source);
    _ref.read(currentRepeatModeProvider.notifier)._onSwitchedSongSamePlaylist();
  }

  void playNextSong() {
    final currentPlaylist = _ref.read(currentPlaylistProvider);
    if (currentPlaylist.length <= 1) {
      throw StateError('Cannot play next song: current playlist has length: ${currentPlaylist.length}');
    }
    final currentSong = _ref.read(currentSongProvider);
    final playOrderIndex = currentSong.playOrderIndex;
    final n = currentPlaylist.length;
    final nextPlayOrderIndex = playOrderIndex + 1;
    if (nextPlayOrderIndex >= n) {
      throw StateError('Cannot play next song: current song is last song of current playlist');
    }
    final nextPlaylistIndex = currentPlaylist.playOrder[nextPlayOrderIndex];
    final nextSong = currentPlaylist[nextPlaylistIndex];
    _seekToPosition = null;
    _ref.read(currentSongProvider.notifier)._set(nextSong, playlistIndex: nextPlaylistIndex, playOrderIndex: nextPlayOrderIndex);
    _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
    _audioPlayer.play(nextSong.source);
    _ref.read(currentRepeatModeProvider.notifier)._onSwitchedSongSamePlaylist();
  }

  void playCurrentSongAgain() {
    final currentSong = _ref.read(currentSongProvider);
    _seekToPosition = null;
    _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
    _audioPlayer.play(currentSong.song.source);
  }

  void pause() {
    var currentState = _ref.read(isPlayingPausedOrCompletedProvider);
    if (currentState == playing) {
      _seekToPosition = null;
      _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(paused);
      _audioPlayer.pause();
    } else {
      throw StateError('Cannot pause: current state is: ${currentState.name}');
    }
  }

  void resume() {
    var currentState = _ref.read(isPlayingPausedOrCompletedProvider);
    if (currentState == paused) {
      _seekToPosition = null;
      _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
      _audioPlayer.resume();
    } else {
      throw StateError('Cannot resume: current state is: ${currentState.name}');
    }
  }

  void seekToPosition(Duration position) {
    if (_seekToPosition != null) {
      _seekToPosition = position;
      return;
    }
    _seekToPosition = position;
    (() async {
      do {
        try {
          final nextPosition = _seekToPosition;
          if (nextPosition == null) {
            return;
          }
          position = nextPosition;
          await _audioPlayer.seek(position);
        } catch (error, stack) {
          debugPrintStack(label: safeErrorToString(error), stackTrace: stack);
        }
      } while (_seekToPosition != position);
      _seekToPosition = null;
    })();
  }
}

@Riverpod(keepAlive: true)
class Player extends _$Player {
  final _streams = <StreamSubscription>[];

  @override
  AudioPlayerWrapper build() {
    debugPrint('creating AudioPlayer');
    final audioPlayer = AudioPlayer()
      ..setPlayerMode(PlayerMode.mediaPlayer)
      ..setReleaseMode(ReleaseMode.stop);
    _streams.add(
      audioPlayer.onPositionChanged.listen((position) {
        if (position == Duration.zero) {
          if (ref.read(isPlayingPausedOrCompletedProvider) == completed) {
            // Ignored: The slider in the PlayerWidget should remain at the end.
            return;
          }
        }
        ref.read(currentSongPositionProvider.notifier).set(position);
      }),
    );
    final wrapper = AudioPlayerWrapper(audioPlayer, ref);
    _streams.add(
      audioPlayer.onPlayerStateChanged.listen((playerState) {
        debugPrint('[audioPlayer.onPlayerStateChanged] $playerState');
        switch (playerState) {
          case PlayerState.paused:
            ref.read(isPlayingPausedOrCompletedProvider.notifier).set(paused);
            break;
          case PlayerState.playing:
            ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
            break;
          case PlayerState.stopped:
            _resetPlayerState(ref);
            break;
          case PlayerState.completed:
            final currentPlaylist = ref.read(currentPlaylistProvider);
            final currentSong = ref.read(currentSongProvider);
            switch (ref.read(currentRepeatModeProvider)) {
              case RepeatMode.none:
                if (currentSong.song.id != currentPlaylist.lastSong.id) {
                  debugPrint('Current song completed, play next song ...');
                  wrapper.playNextSong();
                } else {
                  debugPrint('Last song completed.');
                  ref.read(isPlayingPausedOrCompletedProvider.notifier).set(completed);
                  // TODO: wenn das letzte Lied fertig abgespielt wurde, sollte
                  // die progress bar nicht auf Anfang zurückgesetzt werden. Das
                  // sollte erst passieren, wenn der Nutzer den Play-IconButton antippt.
                }
              case RepeatMode.repeatSongOnce:
                debugPrint('Current song completed, repeat it once ...');
                audioPlayer.play(currentSong.song.source);
                ref.read(currentRepeatModeProvider.notifier).set(RepeatMode.none);
              case RepeatMode.repeatSong:
                debugPrint('Current song completed, repeat it ...');
                audioPlayer.play(currentSong.song.source);
              case RepeatMode.repeatPlaylist:
                if (currentSong.song.id == currentPlaylist.lastSong.id) {
                  debugPrint('Last song completed, repeat playlist ...');
                  wrapper.playPlaylist(currentPlaylist);
                } else {
                  debugPrint('Current song completed, play next song ...');
                  wrapper.playNextSong();
                }
            }
          case PlayerState.disposed: // Do nothing.
        }
      }),
    );
    ref.onDispose(() {
      _disposeAudioPlayer(audioPlayer);
    });
    return wrapper;
  }

  void _disposeAudioPlayer(AudioPlayer? audioPlayer) {
    debugPrint('disposing AudioPlayer');
    for (final stream in _streams) {
      try {
        stream.cancel();
      } catch (ignored) {}
    }
    _streams.clear();
    try {
      audioPlayer?.dispose();
    } catch (ignored) {}
  }
}

void _resetPlayerState(Ref ref, {bool setCurrentPlaylist = true}) {
  if (setCurrentPlaylist) {
    // This will call _resetPlayerState with setCurrentPlaylist: false
    ref.read(currentPlaylistProvider.notifier).set(Playlist.empty);
  } else {
    ref.read(currentSongProvider.notifier)._reset();
    ref.read(currentSongPositionProvider.notifier).set(Duration.zero);
    ref.read(isPlayingPausedOrCompletedProvider.notifier).set(completed);
    ref.read(currentRepeatModeProvider.notifier).set(RepeatMode.none);
    ref.invalidate(playerProvider);
  }
}

extension on Song {
  Source get source => DeviceFileSource(path);
}

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
/// Initial value: an empty playlist
/// Updated by: [AudioPlayerWrapper] methods
@Riverpod(keepAlive: true)
class CurrentPlaylist extends _$CurrentPlaylist {
  @override
  Wiedergabeliste build() => Wiedergabeliste([]);

  void _reset() {
    state = build();
  }

  void _set(Iterable<Song> songs) {
    state = Wiedergabeliste(songs);
  }
}

/// The song currently being played.
/// Initial value: [_noSong]
/// Updated by: [AudioPlayerWrapper] methods
@Riverpod(keepAlive: true)
class CurrentSong extends _$CurrentSong {
  @override
  Song build() => _noSong;

  void _reset() {
    state = build();
  }

  void _set(Song song) {
    var label = song.title;
    if (label.isEmpty || label.startsWith('<') || label == 'unknown' || label == 'null') {
      label = basename(song.fileName);
    } else {
      final artist = song.artist;
      if (artist.isNotEmpty && !artist.startsWith('<') && artist != 'unknown' && artist != 'null') {
        label = '$artist: $label';
      }
    }
    state = song;
    ref.read(currentSongLabelProvider.notifier)._set(label);
  }
}

/// The label to be displayed for the current song.
/// Initial value: ''
/// Updated by: [CurrentSong._set]
@Riverpod(keepAlive: true)
class CurrentSongLabel extends _$CurrentSongLabel {
  @override
  String build() => '';

  void _set(String value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class CurrentSongPosition extends _$CurrentSongPosition {
  @override
  Duration build() => Duration.zero;

  void _reset() {
    state = build();
  }

  void _set(Duration value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class IsPlayingPausedOrCompleted extends _$IsPlayingPausedOrCompleted {
  @override
  PlayingPausedOrCompleted build() => PlayingPausedOrCompleted.completed;

  void _reset() {
    state = build();
  }

  void set(PlayingPausedOrCompleted value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class CurrentRepeatMode extends _$CurrentRepeatMode {
  @override
  RepeatMode build() => RepeatMode.none;

  void _reset() {
    state = build();
  }

  void set(RepeatMode repeatMode) {
    state = repeatMode;
  }

  void _onSongSwitched() {
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

  void playSong(Song song) => playPlaylist([song]);

  void playPlaylist(Iterable<Song> playlist) {
    _seekToPosition = null;
    _ref.read(currentPlaylistProvider.notifier)._set(Wiedergabeliste(playlist));
    if (playlist.isEmpty) {
      _resetPlayerState(_ref);
      _audioPlayer.stop();
    } else {
      _ref.read(currentSongProvider.notifier)._set(playlist.first);
      _ref.read(currentSongPositionProvider.notifier)._set(Duration.zero);
      _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
      _audioPlayer.play(playlist.first.source);
    }
  }

  void shuffleAndPlay(Playlist playlist) => playPlaylist([...playlist]..shuffle());

  void enqueueSong(Song song) {
    final currentPlaylist = _ref.read(currentPlaylistProvider);
    if (currentPlaylist.isEmpty) {
      playSong(song);
    } else {
      _ref.read(currentPlaylistProvider.notifier)._set(Wiedergabeliste([...currentPlaylist, song]));
      if (_ref.read(isPlayingPausedOrCompletedProvider) == completed) {
        _seekToPosition = null;
        _ref.read(currentSongProvider.notifier)._set(song);
        _ref.read(currentSongPositionProvider.notifier)._set(Duration.zero);
        _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
        _audioPlayer.play(song.source);
      }
    }
  }

  void enqueuePlaylist(Iterable<Song> playlist) {
    if (playlist.isEmpty) {
      return;
    }
    final currentPlaylist = _ref.read(currentPlaylistProvider);
    if (currentPlaylist.isEmpty) {
      playPlaylist(playlist);
    } else {
      _ref.read(currentPlaylistProvider.notifier)._set(Wiedergabeliste([...currentPlaylist, ...playlist]));
      if (_ref.read(isPlayingPausedOrCompletedProvider) == completed) {
        _seekToPosition = null;
        _ref.read(currentSongProvider.notifier)._set(playlist.first);
        _ref.read(currentSongPositionProvider.notifier)._set(Duration.zero);
        _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
        _audioPlayer.play(playlist.first.source);
      }
    }
  }

  void shuffleAndEnqueue(Playlist playlist) => enqueuePlaylist([...playlist]..shuffle());

  void playPreviousSong() {
    final currentPlaylist = _ref.read(currentPlaylistProvider);
    if (currentPlaylist.length <= 1) {
      throw StateError('Cannot play previous song: current playlist has length: ${currentPlaylist.length}');
    }
    final currentSong = _ref.read(currentSongProvider);
    final index = currentPlaylist.indexOf(currentSong);
    if (index < 0) {
      throw StateError('$currentSong not found in $currentPlaylist');
    } else if (index == 0) {
      throw StateError('Cannot play previous song: current song is first song of current playlist');
    }
    final previousSong = currentPlaylist[index - 1];
    _seekToPosition = null;
    _ref.read(currentSongProvider.notifier)._set(previousSong);
    _ref.read(currentSongPositionProvider.notifier)._set(Duration.zero);
    _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
    _audioPlayer.play(previousSong.source);
    _ref.read(currentRepeatModeProvider.notifier)._onSongSwitched();
  }

  void playNextSong() {
    final currentPlaylist = _ref.read(currentPlaylistProvider);
    final currentSong = _ref.read(currentSongProvider);
    final index = currentPlaylist.indexOf(currentSong);
    if (index < 0) {
      throw StateError('$currentSong not found in $currentPlaylist');
    } else if (index == currentPlaylist.length - 1) {
      throw StateError('Cannot play next song: current song is last song of current playlist');
    }
    final nextSong = currentPlaylist[index + 1];
    _seekToPosition = null;
    _ref.read(currentSongProvider.notifier)._set(nextSong);
    _ref.read(currentSongPositionProvider.notifier)._set(Duration.zero);
    _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
    _audioPlayer.play(nextSong.source);
    _ref.read(currentRepeatModeProvider.notifier)._onSongSwitched();
  }

  void playCurrentSongAgain() {
    final currentSong = _ref.read(currentSongProvider);
    _seekToPosition = null;
    _ref.read(isPlayingPausedOrCompletedProvider.notifier).set(playing);
    _audioPlayer.play(currentSong.source);
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
        ref.read(currentSongPositionProvider.notifier)._set(position);
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
                if (currentSong.id != currentPlaylist.last.id) {
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
                ref.read(currentSongPositionProvider.notifier)._set(Duration.zero);
                audioPlayer.play(currentSong.source);
                ref.read(currentRepeatModeProvider.notifier).set(RepeatMode.none);
              case RepeatMode.repeatSong:
                debugPrint('Current song completed, repeat it ...');
                ref.read(currentSongPositionProvider.notifier)._set(Duration.zero);
                audioPlayer.play(currentSong.source);
              case RepeatMode.repeatPlaylist:
                if (currentSong.id == currentPlaylist.last.id) {
                  debugPrint('Last song completed, repeat current playlist ...');
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

void _resetPlayerState(Ref ref) {
  ref.read(currentPlaylistProvider.notifier)._reset();
  ref.read(currentSongProvider.notifier)._reset();
  ref.read(currentSongPositionProvider.notifier)._reset();
  ref.read(isPlayingPausedOrCompletedProvider.notifier)._reset();
  ref.read(currentRepeatModeProvider.notifier)._reset();
  ref.invalidate(playerProvider);
}

extension on Song {
  Source get source => DeviceFileSource(path);
}

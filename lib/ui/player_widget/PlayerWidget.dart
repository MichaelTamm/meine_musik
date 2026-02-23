import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/PlayingPausedOrCompleted.dart';
import '../../riverpod/player_state.dart';
import './BookmarkIconButton.dart';
import './RepeatModeButton.dart';

class PlayerWidget extends ConsumerWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlaylist = ref.watch(currentPlaylistProvider);
    final currentSong = ref.watch(currentSongProvider);
    return Container(
      height: 16 /* padding */ + 20 /* song name */ + 44 /* slider */ + 64 /* buttons */ + 16 /* padding */,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: Text(currentSong.label, maxLines: 1, overflow: TextOverflow.ellipsis)),
                Text(' (${currentSong.playOrderIndex + 1}/${currentPlaylist.length})', maxLines: 1),
              ],
            ),
          ),
          const _PlayerSlider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RepeatModeButton(),
              IconButton(
                icon: Icon(Icons.skip_previous_rounded),
                onPressed: () {
                  final currentSongPosition = ref.read(currentSongPositionProvider);
                  final debugMessagePrefix =
                      'Tap on skip to previous icon button, current song position: ${currentSongPosition.inSeconds}s';
                  if (currentSong.playOrderIndex == 0) {
                    debugPrint(
                      '$debugMessagePrefix, current song is first song of current playlist -- seeking to start of current song ...',
                    );
                    ref.read(playerProvider).seekToPosition(Duration.zero);
                  } else if (currentSongPosition < Duration(milliseconds: min(5000, (currentSong.duration.inMilliseconds / 5).round()))) {
                    debugPrint('$debugMessagePrefix -- play previous song ...');
                    ref.read(playerProvider).playPreviousSong();
                  } else {
                    debugPrint('$debugMessagePrefix -- seeking to start of current song ...');
                    ref.read(playerProvider).seekToPosition(Duration.zero);
                  }
                },
              ),
              if (ref.watch(isPlayingPausedOrCompletedProvider) == playing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    iconSize: 48,
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      debugPrint('Tap on pause icon button -- pause playing ...');
                      ref.read(playerProvider).pause();
                    },
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    iconSize: 48,
                    icon: Icon(Icons.play_arrow_rounded),
                    onPressed: () {
                      final playerState = ref.read(isPlayingPausedOrCompletedProvider);
                      switch (playerState) {
                        case playing:
                          debugPrint('Tap on play icon button -- do nothing');
                          break;
                        case paused:
                          debugPrint('Tap on play icon button -- resume playing ...');
                          ref.read(playerProvider).resume();
                        case completed:
                          debugPrint('Tap on play icon button -- play last song again ...');
                          ref.read(playerProvider).playCurrentSongAgain();
                      }
                    },
                  ),
                ),
              IconButton(
                icon: Icon(Icons.skip_next_rounded),
                onPressed: currentSong.song.id == currentPlaylist.lastSong.id
                    ? null
                    : () {
                        debugPrint('Tap on skip to next icon button -- play next song ...');
                        ref.read(playerProvider).playNextSong();
                      },
              ),
              BookmarkIconButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerSlider extends ConsumerWidget {
  const _PlayerSlider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSongDuration = ref.watch(currentSongProvider.select((it) => it.duration.inMilliseconds.toDouble()));
    final currentSongPosition = ref.watch(currentSongPositionProvider);
    if (currentSongDuration == 0) {
      return Slider(value: 0, onChanged: null, min: 0, max: 1, padding: EdgeInsets.symmetric(horizontal: 0));
    }
    return Slider(
      value: currentSongPosition.inMilliseconds.toDouble().clamp(0, currentSongDuration),
      label: _formatCurrentSongPosition(currentSongPosition),
      onChanged: (double newValue) => ref.read(playerProvider).seekToPosition(Duration(milliseconds: newValue.round())),
      min: 0,
      max: currentSongDuration,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');

String _formatCurrentSongPosition(Duration currentSongPosition) {
  final mm = _twoDigits(currentSongPosition.inMinutes);
  final ss = _twoDigits(currentSongPosition.inSeconds % 60);
  return '$mm:$ss';
}

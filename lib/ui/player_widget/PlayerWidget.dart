import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/env.dart';

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
    final currentSongLabel = ref.watch(currentSongLabelProvider);
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
                Expanded(child: Text(currentSongLabel, maxLines: 1, overflow: TextOverflow.ellipsis)),
                Text(' (${currentPlaylist.indexOf(currentSong) + 1}/${currentPlaylist.length})', maxLines: 1),
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
                  debugPrint('[$PlayerWidget] tap on skip to previous icon button');
                  audioHandler.skipToPrevious();
                },
              ),
              if (ref.watch(isPlayingPausedOrCompletedProvider) == playing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    iconSize: 48,
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      debugPrint('[$PlayerWidget] tap on pause icon button');
                      audioHandler.pause();
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
                      debugPrint('[$PlayerWidget] tap on play icon button');
                      audioHandler.play();
                    },
                  ),
                ),
              IconButton(
                icon: Icon(Icons.skip_next_rounded),
                onPressed: currentSong.id == currentPlaylist.lastSong.id
                    ? null
                    : () {
                        debugPrint('[$PlayerWidget] tap on skip to next icon button');
                        audioHandler.skipToNext();
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
    final currentSongDuration = ref.watch(currentSongProvider.select((it) => it.durationInMilliseconds.toDouble()));
    final currentSongPosition = ref.watch(currentSongPositionProvider);
    if (currentSongDuration == 0) {
      return Slider(value: 0, onChanged: null, min: 0, max: 1, padding: EdgeInsets.symmetric(horizontal: 0));
    }
    return Slider(
      value: currentSongPosition.inMilliseconds.toDouble().clamp(0, currentSongDuration),
      label: _formatCurrentSongPosition(currentSongPosition),
      onChanged: (double newValue) {
        debugPrint('[$_PlayerSlider] slider moved to: $newValue');
        audioHandler.seek(Duration(milliseconds: newValue.round()));
      },
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

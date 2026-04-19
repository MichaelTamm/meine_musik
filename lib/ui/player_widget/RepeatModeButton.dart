import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/RepeatMode.dart';
import '../../riverpod/player_state.dart';
import '../MeineMusikIcons.dart';

class RepeatModeButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlaylistLength = ref.watch(currentPlaylistProvider.select((it) => it.length));
    final repeatMode = ref.watch(currentRepeatModeProvider);

    if (currentPlaylistLength == 1) {
      return IconButton(
        icon: Icon(switch (repeatMode) {
          RepeatMode.none => MeineMusikIcons.repeatOff,
          RepeatMode.repeatSongOnce => Icons.repeat_one,
          RepeatMode.repeatSong => Icons.repeat,
          RepeatMode.repeatPlaylist => Icons.repeat,
        }),
        onPressed: () => ref.read(currentRepeatModeProvider.notifier).set(switch (repeatMode) {
          RepeatMode.none => RepeatMode.repeatSongOnce,
          RepeatMode.repeatSongOnce => RepeatMode.repeatSong,
          RepeatMode.repeatSong => RepeatMode.none,
          RepeatMode.repeatPlaylist => RepeatMode.none,
        }),
      );
    }

    return Semantics(
      label: 'Wiederholungsmodus',
      child: PopupMenuButton<RepeatMode>(
        icon: switch (repeatMode) {
          RepeatMode.none => Icon(MeineMusikIcons.repeatOff),
          RepeatMode.repeatSongOnce => Icon(Icons.repeat_one),
          RepeatMode.repeatSong => Icon(Icons.repeat),
          RepeatMode.repeatPlaylist => Icon(Icons.repeat_on),
        },
        position: PopupMenuPosition.over,
        menuPadding: EdgeInsets.zero,
        tooltip: '',
        itemBuilder: (_) => const [
          PopupMenuItem<RepeatMode>(
            value: RepeatMode.none,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(MeineMusikIcons.repeatOff), SizedBox(width: 8), Text('keine Wiederholung')],
            ),
          ),
          PopupMenuItem<RepeatMode>(
            value: RepeatMode.repeatSongOnce,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.repeat_one), SizedBox(width: 8), Text('Lied einmal wiederholen')],
            ),
          ),
          PopupMenuItem<RepeatMode>(
            value: RepeatMode.repeatSong,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.repeat), SizedBox(width: 8), Text('Lied in Endlosschleife spielen')],
            ),
          ),
          PopupMenuItem<RepeatMode>(
            value: RepeatMode.repeatPlaylist,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.repeat_on), SizedBox(width: 8), Text('Wiedergabeliste in\nEndlosschleife spielen')],
            ),
          ),
        ],
        onSelected: (value) {
          ref.read(currentRepeatModeProvider.notifier).set(value);
        },
      ),
    );
  }
}

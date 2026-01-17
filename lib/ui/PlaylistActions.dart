import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/Playlist.dart';
import '../riverpod/player_state.dart';
import './MeineMusikIcons.dart';

class PlaylistActions extends ConsumerWidget {
  const PlaylistActions(this.playlist);

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 84,
      height: 48,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(MeineMusikIcons.playInOrder),
              onPressed: playlist.isEmpty
                  ? null
                  : () {
                      debugPrint('Tap on play in order icon button for playlist ${playlist.name}');
                      ref.read(playerProvider).playPlaylist(playlist);
                    },
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(MeineMusikIcons.playShuffled),
              onPressed: playlist.isEmpty
                  ? null
                  : () {
                      debugPrint('Tap on play shuffled icon button for playlist ${playlist.name}');
                      playlist.shuffle();
                      ref.read(playerProvider).playPlaylist(playlist);
                    },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/theme.dart';

import '../model/Playlist.dart';
import '../riverpod/player_state.dart';
import 'SongListTile.dart';

class PlaylistView extends ConsumerWidget {
  const PlaylistView(this.playlist, {required this.close});

  final Playlist playlist;
  final VoidCallback close;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentPlaylist = ref.watch(currentPlaylistProvider.select((it) => it == playlist));
    return Material(
      color: isCurrentPlaylist ? selectedPlaylistBackground : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            primary: false,
            child: Row(
              children: [
                IconButton(onPressed: close, icon: Icon(Icons.chevron_left_rounded)),
                Text(
                  playlist.name,
                  style: TextStyle(color: colorScheme.onSurface.withAlpha(97), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: playlist.isEmpty
                ? ColoredBox(
                    color: Color.fromARGB(0xFF, 0xF0, 0xEC, 0xF7),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Expanded(child: Image.asset('assets/empty_playlist.png')),
                        SizedBox(height: 16),
                        Text(
                          playlist is AlleLieder ? 'keine Lieder gefunden' : 'noch keine Lieder ausgewählt',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  )
                : ListView.builder(itemCount: playlist.length, itemBuilder: (context, index) => SongListTile(playlist[index], playlist)),
          ),
        ],
      ),
    );
  }
}

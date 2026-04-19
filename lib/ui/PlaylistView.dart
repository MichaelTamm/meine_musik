import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/riverpod/playlists.dart';
import 'package:meine_musik/theme.dart';

import '../model/Playlist.dart';
import '../riverpod/player_state.dart';
import 'SongListTile.dart';

class PlaylistView extends ConsumerWidget {
  const PlaylistView(this._playlist, {required this.close});

  final Playlist _playlist;
  final VoidCallback close;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistAsync = switch (_playlist) {
      AlleLieder() => ref.watch(alleLiederProvider),
      Favoriten() => ref.watch(favoritenProvider),
      ManuallyCreatedPlaylist() => ref.watch(manuallyCreatedPlaylistProvider(_playlist.id)),
      _ => AsyncValue<Playlist?>.data(null),
    };
    final playlist = playlistAsync.value ?? _playlist;
    final isFullySelected = ref.watch(currentPlaylistProvider.select((it) => playlist.isNotEmpty && it.includesAllOf(playlist)));
    return Material(
      color: isFullySelected ? fullySelectedPlaylistBackground : Colors.transparent,
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
                ? Column(
                    children: [
                      SizedBox(height: 16),
                      Expanded(child: Icon(Icons.music_off_rounded, size: 96, color: colorScheme.onSurface.withAlpha(97))),
                      SizedBox(height: 16),
                      Text(switch (playlist) {
                        AlleLieder() => 'keine Lieder gefunden',
                        Favoriten() => 'noch keine Favoriten ausgewählt',
                        _ => 'keine Lieder ausgewählt',
                      }, style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 80),
                    ],
                  )
                : ListView.builder(itemCount: playlist.length, itemBuilder: (context, index) => SongListTile(playlist[index], playlist)),
          ),
        ],
      ),
    );
  }
}

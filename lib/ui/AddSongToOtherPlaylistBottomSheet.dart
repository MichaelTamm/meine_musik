import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/navigation.dart';

import '../model/Song.dart';
import '../riverpod/playlists.dart';

class AddSongToOtherPlaylistBottomSheet extends ConsumerWidget {
  const AddSongToOtherPlaylistBottomSheet(this.song);

  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriten = ref.watch(favoritenProvider).value;
    final manuallyCreatedPlaylists = ref.watch(manuallyCreatedPlaylistsProvider).value;
    if (favoriten == null || manuallyCreatedPlaylists == null) {
      return Container();
    }
    return ListView.builder(
      itemCount: 2 + manuallyCreatedPlaylists.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
              leading: Icon(Icons.add_rounded),
              title: Text('Neue Playlist ...'),
              onTap: () {
                debugPrint('[$AddSongToOtherPlaylistBottomSheet] Tap on "Neue Playlist ..."');
                // TODO: ...
              }
          );
        } else if (index == 1) {
          return ListTile(
            leading: Icon(favoriten.contains(song) ? Icons.favorite_rounded : Icons.favorite_border_rounded),
            title: Text(favoriten.name),
            onTap: () {
              debugPrint('[$AddSongToOtherPlaylistBottomSheet] Tap on "${favoriten.name}"');
              closeBottomSheet(result: favoriten);
            },
          );
        } else {
          final playlist = manuallyCreatedPlaylists[index - 2];
          return ListTile(
            leading: Icon(playlist.contains(song) ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
            title: Text(playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              debugPrint('[$AddSongToOtherPlaylistBottomSheet] Tap on "${playlist.name}"');
              closeBottomSheet(result: playlist);
            },
          );
        }
      },
    );
  }
}

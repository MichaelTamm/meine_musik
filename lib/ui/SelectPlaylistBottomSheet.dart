import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/navigation.dart';

import '../riverpod/playlists.dart';

class SelectPlaylistBottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriten = ref.watch(favoriteSongsProvider).value;
    final manuallyCreatedPlaylists = ref.watch(manuallyCreatedPlaylistsProvider).value;
    if (favoriten == null || manuallyCreatedPlaylists == null) {
      return Container();
    }
    return ListView.builder(
      itemCount: 1 + manuallyCreatedPlaylists.length,
      itemBuilder: (context, index) {
        final playlist = index == 0 ? favoriten : manuallyCreatedPlaylists[index - 1];
        return ListTile(
          title: Text(playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () => closeBottomSheet(result: playlist),
        );
      },
    );
  }
}

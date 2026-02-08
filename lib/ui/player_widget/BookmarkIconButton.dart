import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/model/Playlist.dart';

import '../../navigation.dart';
import '../../riverpod/player_state.dart';
import '../../riverpod/playlists.dart';
import '../AddSongToOtherPlaylistBottomSheet.dart';
import '../showSnackBar.dart';

class BookmarkIconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final currentBookmarkTarget = ref.watch(currentBookmarkTargetProvider).value;
    if (currentBookmarkTarget == null) {
      return IconButton(icon: Container(), onPressed: null);
    }
    final isBookmarked = currentBookmarkTarget.contains(currentSong.song);
    return IconButton(
      icon: Icon(
        currentBookmarkTarget is Favoriten
            ? (isBookmarked ? Icons.favorite_rounded : Icons.favorite_border_rounded)
            : (isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
      ),
      onPressed: () async {
        if (currentBookmarkTarget is Favoriten) {
          debugPrint('[PlayerWidget] Tap on favorite icon button');
        } else {
          debugPrint('[PlayerWidget] Tap on bookmark icon button');
        }
        if (isBookmarked) {
          await currentBookmarkTarget.removeSong!.call(currentSong.song);
          if (context.mounted) {
            showSnackBar(
              context,
              'Von ${currentBookmarkTarget.name} entfernt.',
              action: (
                'Rückgängig machen',
                () async {
                  debugPrint('[SnackBar] Tap on "Rückgängig machen"');
                  await currentBookmarkTarget.addSong!.call(currentSong.song);
                },
              ),
            );
          }
        } else {
          await currentBookmarkTarget.addSong!.call(currentSong.song);
          if (context.mounted) {
            showSnackBar(
              context,
              'Zu ${currentBookmarkTarget.name} hinzugefügt.',
              action: (
                'andere Playlist ...',
                () async {
                  debugPrint('[SnackBar] Tap on "andere Playlist ..."');
                  await currentBookmarkTarget.removeSong!(currentSong.song);
                  final otherPlaylist = await openBottomSheet<Playlist?>(() => AddSongToOtherPlaylistBottomSheet(currentSong.song));
                  if (otherPlaylist == null) {
                    debugPrint('[$AddSongToOtherPlaylistBottomSheet] was closed without selecting a playlist');
                    await currentBookmarkTarget.addSong!.call(currentSong.song);
                  } else {
                    if (!otherPlaylist.contains(currentSong.song)) {
                      await otherPlaylist.addSong!(currentSong.song);
                    }
                    if (otherPlaylist != currentBookmarkTarget) {
                      ref.read(currentBookmarkTargetIdProvider.notifier).set(otherPlaylist);
                    }
                    if (context.mounted) {
                      showSnackBar(context, 'Zu ${otherPlaylist.name} hinzugefügt.');
                    }
                  }
                },
              ),
            );
          }
        }
      },
    );
  }
}

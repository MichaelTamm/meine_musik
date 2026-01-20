import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/model/Playlist.dart';

import '../../navigation.dart';
import '../../riverpod/player_state.dart';
import '../../riverpod/playlists.dart';
import '../SelectPlaylistBottomSheet.dart';

class BookmarkIconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final currentBookmarkTarget = ref.watch(currentBookmarkTargetProvider).value;
    final isBookmarked = currentBookmarkTarget?.contains(currentSong.song) ?? false;
    return IconButton(
      icon: Icon(
        currentBookmarkTarget == null || currentBookmarkTarget is Favoriten
            ? (isBookmarked ? Icons.favorite_rounded : Icons.favorite_border_rounded)
            : (isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
      ),
      onPressed: currentBookmarkTarget == null
          ? null
          : () async {
              if (currentBookmarkTarget is Favoriten) {
                debugPrint('Tap on favorite icon button');
              } else {
                debugPrint('Tap on bookmark icon button');
              }
              if (isBookmarked) {
                try {
                  await currentBookmarkTarget.removeSong!.call(currentSong.song);
                } catch (error, stack) {
                  debugPrintStack(label: 'Failed to remove ${currentSong.song} from $currentBookmarkTarget: $error', stackTrace: stack);
                }
              } else {
                try {
                  await currentBookmarkTarget.addSong!.call(currentSong.song);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Zu ${currentBookmarkTarget.name} hinzugefügt.'),
                        action: SnackBarAction(
                          label: 'andere Playlist ...',
                          onPressed: () async {
                            debugPrint('Tap on "andere Playlist ..."');
                            final otherPlaylist = await openBottomSheet<Playlist?>(SelectPlaylistBottomSheet.new);
                            if (otherPlaylist != null) {
                              try {
                                await currentBookmarkTarget.removeSong!(currentSong.song);
                                await otherPlaylist.addSong!(currentSong.song);
                                ref.read(currentBookmarkTargetProvider.notifier).set(otherPlaylist);
                              } catch (error, stack) {
                                debugPrintStack(
                                  label: 'Failed to move ${currentSong.song} from $currentBookmarkTarget to $otherPlaylist: $error',
                                  stackTrace: stack,
                                );
                              }
                            } else {
                              debugPrint('SelectPlaylistBottomSheet closed without selecting a playlist');
                            }
                          },
                        ),
                      ),
                    );
                  }
                } catch (error, stack) {
                  debugPrintStack(label: 'Failed to add ${currentSong.song} to $currentBookmarkTarget: $error', stackTrace: stack);
                }
              }
            },
    );
  }
}

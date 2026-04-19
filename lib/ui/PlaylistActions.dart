import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/Playlist.dart';
import '../riverpod/player_state.dart';
import 'dialogs/DeletePlaylistDialog.dart';
import 'dialogs/RenamePlaylistDialog.dart';

const _popupMenuItemPadding = EdgeInsets.only(left: 4, right: 12);

class PlaylistActions extends ConsumerWidget {
  const PlaylistActions(this.playlist);

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlist = this.playlist;
    final playIconButton = Semantics(
      label: 'Playlist abspielen',
      child: IconButton(
        icon: const Icon(Icons.play_arrow_rounded),
        tooltip: '',
        onPressed: playlist.isEmpty
            ? null
            : () {
                debugPrint('Tap on play icon button for $playlist');
                ref.read(playerProvider).playPlaylist(playlist);
              },
      ),
    );
    final popupMenuButton = Semantics(
      label: 'Popup-Menü mit weiteren Aktionen öffnen',
      child: PopupMenuButton<void Function()>(
        enabled: playlist.isNotEmpty || playlist is ManuallyCreatedPlaylist,
        tooltip: '',
        icon: const Icon(Icons.more_vert_rounded),
        position: PopupMenuPosition.under,
        menuPadding: EdgeInsets.zero,
        itemBuilder: (_) => [
          PopupMenuItem(
            enabled: playlist.isNotEmpty,
            padding: _popupMenuItemPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow_rounded),
                Icon(Icons.shuffle_rounded),
                SizedBox(width: 8),
                Text('in zufälliger Reihenfolge\nabspielen'),
              ],
            ),
            value: () {
              debugPrint("Popup menu item 'in zufälliger Reihenfolge abspielen' selected for $playlist");
              ref.read(playerProvider).shuffleAndPlay(playlist);
            },
          ),
          PopupMenuItem(
            enabled: playlist.isNotEmpty,
            padding: _popupMenuItemPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                Icon(Icons.format_list_numbered_rounded),
                SizedBox(width: 8),
                Text('zur Wiedergabeliste hinzufügen'),
              ],
            ),
            value: () {
              debugPrint("Popup menu item 'zur Wiedergabeliste hinzufügen' selected for $playlist");
              ref.read(playerProvider).enqueuePlaylist(playlist);
            },
          ),
          PopupMenuItem(
            enabled: playlist.isNotEmpty,
            padding: _popupMenuItemPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                Icon(Icons.shuffle_rounded),
                SizedBox(width: 8),
                Text('in zufälliger Reihenfolge\nzur Wiedergabeliste hinzufügen'),
              ],
            ),
            value: () {
              debugPrint("Popup menu item 'in zufälliger Reihenfolge zur Wiedergabeliste hinzufügen' selected for $playlist");
              ref.read(playerProvider).shuffleAndEnqueue(playlist);
            },
          ),
          if (playlist is ManuallyCreatedPlaylist) ...[
            PopupMenuItem(
              padding: _popupMenuItemPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [SizedBox(width: 24), Icon(Icons.edit), SizedBox(width: 8), Text('Playlist umbenennen')],
              ),
              value: () {
                debugPrint("Popup menu item 'Playlist umbenennen' selected for $playlist");
                unawaited(showDialog(context: context, builder: (_) => RenamePlaylistDialog(playlist)));
              },
            ),
            PopupMenuItem(
              padding: _popupMenuItemPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [SizedBox(width: 24), Icon(Icons.delete_rounded), SizedBox(width: 8), Text('Playlist löschen')],
              ),
              value: () {
                debugPrint("Popup menu item 'Playlist löschen' selected for $playlist");
                unawaited(showDialog(context: context, builder: (_) => DeletePlaylistDialog(playlist)));
              },
            ),
          ],
        ],
        onSelected: (value) => value(),
      ),
    );

    return SizedBox(
      width: 84,
      height: 48,
      child: Stack(
        children: [
          // [UX]: There is a small overlap between both buttons (by intent).
          //       We render  the `playIconButton` after the `popupMenuButton`
          //       so that the `playIconButton` wins when the overlapping area is touched ...
          Positioned(right: 4, top: 0, child: popupMenuButton),
          Positioned(left: 0, top: 0, child: playIconButton),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/Playlist.dart';
import '../riverpod/player_state.dart';
import '../theme.dart';
import 'dialogs/DeletePlaylistDialog.dart';
import 'dialogs/RenamePlaylistDialog.dart';

class PlaylistActions extends ConsumerWidget {
  const PlaylistActions(this.playlist);

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlist = this.playlist;
    final playIconButton = IconButton(
      icon: const Icon(Icons.play_arrow_rounded),
      tooltip: 'Jetzt spielen',
      onPressed: playlist.isEmpty
          ? null
          : () {
              debugPrint('tap on play icon button for $playlist');
              ref.read(playerProvider).playPlaylist(playlist);
            },
    );
    final popupMenuButton = PopupMenuButton<void Function()>(
      icon: const Icon(Icons.more_vert_rounded),
      tooltip: 'Popup-Menü mit weiteren Aktionen öffnen',
      enabled: playlist.isNotEmpty || playlist is ManuallyCreatedPlaylist,
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.zero,
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: playlist.isNotEmpty,
          padding: popupMenuItemPadding,
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
          padding: popupMenuItemPadding,
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
          padding: popupMenuItemPadding,
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
            padding: popupMenuItemPadding,
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
            padding: popupMenuItemPadding,
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

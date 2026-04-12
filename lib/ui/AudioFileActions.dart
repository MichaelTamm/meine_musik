import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/model/AudioFile.dart';
import 'package:open_file_manager/open_file_manager.dart';

import '../riverpod/player_state.dart';

const _popupMenuItemPadding = EdgeInsets.only(left: 4, right: 12);

class AudioFileActions extends ConsumerWidget {
  const AudioFileActions(this.file);

  final AudioFile file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playIconButton = IconButton(
      icon: const Icon(Icons.play_arrow_rounded),
      onPressed: () {
        debugPrint('Tap on play icon button for file ${file.fileName}');
        ref.read(playerProvider).playSong(file);
      },
    );
    final popupMenuButton = PopupMenuButton<FutureOr<void> Function()>(
      tooltip: '',
      icon: const Icon(Icons.more_vert_rounded),
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.zero,
      itemBuilder: (_) => [
        PopupMenuItem(
          padding: _popupMenuItemPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox(width: 24), Icon(Icons.edit), SizedBox(width: 8), Text('Datei umbenennen')],
          ),
          value: () {
            debugPrint("Popup menu item 'Datei umbenennen' selected for file ${file.fileName}");
            // TODO: return showDialog(context: context, builder: (_) => RenameFileDialog(file));
          },
        ),
        PopupMenuItem(
          padding: _popupMenuItemPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox(width: 24), Icon(Icons.delete_rounded), SizedBox(width: 8), Text('Datei löschen')],
          ),
          value: () {
            debugPrint("Popup menu item 'Datei löschen' selected for file ${file.fileName}");
            // TODO: return showDialog(context: context, builder: (_) => DeleteFileDialog(file));
          },
        ),
        PopupMenuItem(
          padding: _popupMenuItemPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [SizedBox(width: 24), Icon(Icons.open_in_new_rounded), SizedBox(width: 8), Text('Ordner öffnen')],
          ),
          value: () {
            debugPrint("Popup menu item 'Ordner öffnen' selected for file ${file.fileName}");
            openFileManager(
              androidConfig: AndroidConfig(folderType: AndroidFolderType.other, folderPath: file.dir),
            );
          },
        ),
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
          //       so that the `popupMenuButton` wins when the overlapping area is touched ...
          Positioned(right: 4, top: 0, child: popupMenuButton),
          Positioned(left: 0, top: 0, child: playIconButton),
        ],
      ),
    );
  }
}

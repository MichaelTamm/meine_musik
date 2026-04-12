import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meine_musik/model/Playlist.dart';

class DeletePlaylistDialog extends HookWidget {
  const DeletePlaylistDialog(this.playlist);

  final ManuallyCreatedPlaylist playlist;

  @override
  Widget build(BuildContext context) {
    final navigatorState = Navigator.of(context);

    Future<void> delete() async {
      await playlist.delete();
      navigatorState.pop();
    }

    return SimpleDialog(
      title: AutoSizeText('Playlist löschen?', maxLines: 1, style: Theme.of(context).textTheme.titleMedium),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text('Soll die Playlist "${playlist.name}" wirklich gelöscht werden?'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: FilledButton(onPressed: delete, child: const Text('Playlist löschen')),
        ),
      ],
    );
  }
}

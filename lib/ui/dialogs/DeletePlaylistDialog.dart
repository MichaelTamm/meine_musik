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
      if (context.mounted) {
        navigatorState.pop();
      }
    }

    return SimpleDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: AutoSizeText('Playlist löschen?', maxLines: 1, style: Theme.of(context).textTheme.titleMedium)),
          IconButton(onPressed: () => navigatorState.pop(), tooltip: 'Dialog schließen', icon: const Icon(Icons.close)),
        ],
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 8, 8, 0),
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Text('Soll die Playlist "${playlist.name}" wirklich gelöscht werden?'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: FilledButton(onPressed: delete, child: const Text('Playlist löschen')),
        ),
      ],
    );
  }
}

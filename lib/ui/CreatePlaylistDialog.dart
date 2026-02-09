import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meine_musik/riverpod/playlists.dart';

import '../env.dart';

class CreatePlaylistDialog extends HookWidget {
  const CreatePlaylistDialog();

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final nameFocusNode = useFocusNode();
    final name = nameController.text.trim();
    final validationState = useState<bool>(false);
    final navigatorState = Navigator.of(context);

    void submit() async {
      final name = nameController.text.trim();
      if (name.isEmpty) {
        validationState.value = true;
        nameFocusNode.requestFocus();
        return;
      }
      final newPlaylistId = await db.createPlaylist(name);
      final newPlaylist = await riverpodContainer.read(manuallyCreatedPlaylistProvider(newPlaylistId).future);
      navigatorState.pop(newPlaylist);
    }

    return SimpleDialog(
      title: AutoSizeText('Neue Playlist', maxLines: 1, style: Theme.of(context).textTheme.titleLarge),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: TextField(
            focusNode: nameFocusNode,
            autofocus: true,
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: validationState.value && name.isEmpty ? 'Bitte hier den Namen eingeben.' : null,
            ),
            onSubmitted: (_) => submit(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: FilledButton(onPressed: submit, child: const Text('Playlist erstellen')),
        ),
      ],
    );
  }
}

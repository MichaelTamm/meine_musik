import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/ui/dialogs/CreatePlaylistDialog.dart';
import 'package:meine_musik/ui/dialogs/DeletePlaylistDialog.dart';
import 'package:meine_musik/ui/dialogs/RenamePlaylistDialog.dart';
import 'package:meine_musik/ui/tabs/AlbenTab.dart';
import 'package:meine_musik/ui/tabs/PlaylistsTab.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spot/spot.dart';

import '../../testdata.dart';
import '../../widget_test_utils.dart';

void main() {
  testWidgets('A playlist can be opened', (tester) async {
    final song = anAudioFile(path: '/storage/emulated/0/Samsung/Music/Over the Horizon.mp3');
    when(() => audioService.findAll()).thenAnswer((_) async => [song]);
    await tester.startApp();
    spot<ListTile>().spotText('Favoriten').existsAtLeastOnce();
    spotText(song.title).doesNotExist();
    await act.tap(spot<ListTile>().spotText('Alle Lieder'));
    await tester.pumpAndSettle();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').doesNotExist();
    spotText(song.title).existsOnce();
  });

  testWidgets('An opened playlist is restored when user switches tabs', (tester) async {
    when(() => audioService.findAll()).thenAnswer((_) async => []);
    await tester.startApp();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').existsAtLeastOnce();
    await act.tap(spot<ListTile>().spotText('Alle Lieder'));
    await tester.pumpAndSettle();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').doesNotExist();
    await act.tap(spot<TabBar>().spotIcon(Icons.album_rounded));
    await tester.pumpAndSettle();
    spot<AlbenTab>().existsOnce();
    spot<PlaylistsTab>().doesNotExist();
    await act.tap(spot<TabBar>().spotIcon(Icons.library_music_rounded));
    await tester.pumpAndSettle();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').doesNotExist();
  });

  testWidgets('An opened playlist can be closed by tapping on the (<) icon button', (tester) async {
    when(() => audioService.findAll()).thenAnswer((_) async => []);
    await tester.startApp();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').existsAtLeastOnce();
    await act.tap(spot<ListTile>().spotText('Alle Lieder'));
    await tester.pumpAndSettle();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').doesNotExist();
    await act.tap(spot<IconButton>().spotIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').existsAtLeastOnce();
  });

  testWidgets('An opened playlist can be closed by pressing the back button', (tester) async {
    when(() => audioService.findAll()).thenAnswer((_) async => []);
    await tester.startApp();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').existsAtLeastOnce();
    await act.tap(spot<ListTile>().spotText('Alle Lieder'));
    await tester.pumpAndSettle();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').doesNotExist();
    await tester.pressBackButton();
    await tester.pumpAndSettle();
    spotText('Alle Lieder').existsOnce();
    spotText('Favoriten').existsAtLeastOnce();
  });

  testWidgets('Add a playlist via FAB', (tester) async {
    await tester.startApp();
    spotText('Meine neue Playlist').doesNotExist();

    await act.tap(spot<FloatingActionButton>());
    await tester.pumpAndSettle();

    spot<CreatePlaylistDialog>().existsOnce();
    await act.enterText(spot<CreatePlaylistDialog>().spot<TextField>(), 'Meine neue Playlist');
    await act.tap(spot<FilledButton>().spotText('Playlist erstellen'));
    await tester.pumpAndSettle();

    spot<CreatePlaylistDialog>().doesNotExist();
    spot<ListTile>().spotText('Meine neue Playlist').existsOnce();
    expect(await (db.select(db.playlists)..where((t) => t.name.equals('Meine neue Playlist'))).get(), hasLength(1));
  });

  testWidgets('Rename a playlist', (tester) async {
    final playlistId = await db.createPlaylist('Alter Name');
    await tester.startApp();
    await act.tap(spot<ListTile>().withChild(spotText('Alter Name')).spotIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();
    await act.tap(spotText('Playlist umbenennen'));
    await tester.pumpAndSettle();
    spot<RenamePlaylistDialog>().spot<TextField>().existsOnce().hasWidgetProp(
      prop: widgetProp<TextField, String>('controller.text', (textField) => textField.controller!.text),
      match: (text) => text.equals('Alter Name'),
    );
    await act.enterText(spot<RenamePlaylistDialog>().spot<TextField>(), 'Neuer Name');
    await tester.pumpAndSettle();
    await act.tap(spot<RenamePlaylistDialog>().spot<FilledButton>().spotText('Speichern'));
    await tester.pumpAndSettle();
    spotText('Alter Name').doesNotExist();
    spotText('Neuer Name').existsOnce();
    expect((await (db.select(db.playlists)..where((t) => t.id.equals(playlistId))).getSingle()).name, equals('Neuer Name'));
  });

  testWidgets('Delete a playlist', (tester) async {
    final playlistId = await db.createPlaylist('Playlist zum Löschen');
    await tester.startApp();
    await act.tap(spot<ListTile>().withChild(spotText('Playlist zum Löschen')).spotIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();
    await act.tap(spotText('Playlist löschen'));
    await tester.pumpAndSettle();
    spot<DeletePlaylistDialog>().existsOnce();
    spotText('Soll die Playlist "Playlist zum Löschen" wirklich gelöscht werden?').existsOnce();
    await act.tap(spot<FilledButton>().spotText('Playlist löschen'));
    await tester.pumpAndSettle();
    spotText('Playlist zum Löschen').doesNotExist();
    expect(await (db.select(db.playlists)..where((t) => t.id.equals(playlistId))).get(), isEmpty);
  });
}

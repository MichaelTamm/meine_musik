import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/riverpod/playlists.dart';
import 'package:meine_musik/ui/AddSongToOtherPlaylistBottomSheet.dart';
import 'package:meine_musik/ui/dialogs/CreatePlaylistDialog.dart';
import 'package:meine_musik/ui/player_widget/PlayerWidget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spot/spot.dart';

import '../../testdata.dart';
import '../../widget_test_utils.dart';

void main() {
  testWidgets("add current song to Favoriten, remove it again, undo", (tester) async {
    final audioFile = anAudioFile(path: '/storage/emulated/0/some audio file.mp3');
    when(() => audioService.findAll()).thenAnswer((_) async => [audioFile]);
    await tester.startApp();
    await act.tap(spot<AppBar>().spotText("Ordner"));
    await tester.pumpAndSettle();
    await act.tap(spotText('some audio file.mp3'));
    await tester.pumpAndSettle();
    // add current song to Favoriten ...
    await act.tap(spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();
    spot<SnackBar>().spotText('Zu Favoriten hinzugefügt.').existsOnce();
    await tester.pumpAndSettle(Duration(seconds: 4));
    spot<SnackBar>().doesNotExist();
    spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.favorite_rounded).existsOnce();
    expect(await riverpodContainer.read(favoritenProvider.future), contains(audioFile));
    // remove it again ..
    await act.tap(spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.favorite_rounded));
    await tester.pumpAndSettle();
    spot<SnackBar>().spotText('Von Favoriten entfernt.').existsOnce();
    expect(await riverpodContainer.read(favoritenProvider.future), isNot(contains(audioFile)));
    // undo ...
    await act.tap(spot<SnackBar>().spotText('Rückgängig machen'));
    await tester.pumpAndSettle(Duration(seconds: 4));
    spot<SnackBar>().doesNotExist();
    spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.favorite_rounded).existsOnce();
    expect(await riverpodContainer.read(favoritenProvider.future), contains(audioFile));
  });

  testWidgets("add current song to another playlist", (tester) async {
    final audioFile1 = anAudioFile(path: '/storage/emulated/0/audio file 1.mp3');
    final audioFile2 = anAudioFile(path: '/storage/emulated/0/audio file 2.mp3');
    final testPlaylistId = await db.createPlaylist('Test-Playlist');
    when(() => audioService.findAll()).thenAnswer((_) async => [audioFile1, audioFile2]);
    await tester.startApp();
    await act.tap(spot<AppBar>().spotText("Ordner"));
    await tester.pumpAndSettle();
    await act.tap(spotText('audio file 1.mp3'));
    await tester.pumpAndSettle();
    await act.tap(spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();
    spot<SnackBar>().spotText('Zu Favoriten hinzugefügt.').existsOnce();
    expect(await riverpodContainer.read(favoritenProvider.future), contains(audioFile1));
    // Add song to 'Test-Playlist' instead ...
    await act.tap(spot<SnackBar>().spotText('andere Playlist ...'));
    await tester.pumpAndSettle();
    expect(await riverpodContainer.read(favoritenProvider.future), isNot(contains(audioFile1)));
    await act.tap(spot<AddSongToOtherPlaylistBottomSheet>().spotText('Test-Playlist'));
    await tester.pumpAndSettle();
    spot<AddSongToOtherPlaylistBottomSheet>().doesNotExist();
    spot<SnackBar>().spotText('Zu Test-Playlist hinzugefügt').existsOnce();
    expect(await riverpodContainer.read(favoritenProvider.future), isNot(contains(audioFile1)));
    expect(await riverpodContainer.read(manuallyCreatedPlaylistProvider(testPlaylistId).future), contains(audioFile1));
    await tester.pumpAndSettle(Duration(seconds: 4));
    spot<SnackBar>().doesNotExist();
    spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.bookmark_rounded).existsOnce();
  });

  testWidgets("add current song to a new playlist", (tester) async {
    final audioFile = anAudioFile(path: '/storage/emulated/0/some audio file.mp3');
    when(() => audioService.findAll()).thenAnswer((_) async => [audioFile]);
    await tester.startApp();
    await act.tap(spot<AppBar>().spotText("Ordner"));
    await tester.pumpAndSettle();
    await act.tap(spotText('some audio file.mp3'));
    await tester.pumpAndSettle();
    // add current song to Favoriten ...
    await act.tap(spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();
    spot<SnackBar>().spotText('Zu Favoriten hinzugefügt.').existsOnce();
    await act.tap(spot<SnackBar>().spotText('andere Playlist ...'));
    await tester.pumpAndSettle();
    await act.tap(spot<AddSongToOtherPlaylistBottomSheet>().spotText('Neue Playlist ...'));
    await tester.pumpAndSettle();
    await act.enterText(spot<CreatePlaylistDialog>().spot<TextField>(), 'Meine 1. Playlist');
    await tester.pumpAndSettle();
    await act.tap(spot<CreatePlaylistDialog>().spotText('Playlist erstellen'));
    await tester.pumpAndSettle();
    spot<CreatePlaylistDialog>().doesNotExist();
    spot<AddSongToOtherPlaylistBottomSheet>().doesNotExist();
    spot<SnackBar>().spotText('Zu Meine 1. Playlist hinzugefügt.').existsOnce();
    await tester.pumpAndSettle(Duration(seconds: 4));
    spot<SnackBar>().doesNotExist();
    spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.bookmark_rounded).existsOnce();
  });
}

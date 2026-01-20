import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
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
}

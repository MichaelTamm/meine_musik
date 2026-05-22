import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/ui/tabs/AlbenTab.dart';
import 'package:meine_musik/ui/tabs/KuenstlerTab.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spot/spot.dart';

import '../../testdata.dart';
import '../../widget_test_utils.dart';

void main() {
  testWidgets('songs are grouped by album', (tester) async {
    when(
      () => nativeMethods.findAll(),
    ).thenAnswer((_) async => [anAudioFile(album: 'Test Album 1'), anAudioFile(album: 'Test Album 1'), anAudioFile(album: 'Test Album 2')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotIcon(Icons.album_rounded));
    await tester.pumpAndSettle();
    spot<ListTile>().existsExactlyNTimes(2);
    spot<ListTile>().first().spotText('Test Album 1').existsOnce();
    spot<ListTile>().first().spotText('2 Lieder').existsOnce();
    spot<ListTile>().last().spotText('Test Album 2').existsOnce();
    spot<ListTile>().last().spotText('1 Lied').existsOnce();
  });

  testWidgets('An album can be opened', (tester) async {
    final song1 = anAudioFile(album: 'Test Album 1');
    when(() => nativeMethods.findAll()).thenAnswer((_) async => [song1, anAudioFile(album: 'Test Album 2')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotIcon(Icons.album_rounded));
    await tester.pumpAndSettle();
    await act.tap(spotText('Test Album 1'));
    await tester.pumpAndSettle();
    spotText('Test Album 1').existsOnce();
    // TODO: spotText(song1.title).existsOnce();
    spotText('Test Album 2').doesNotExist();
  });

  testWidgets('An opened album is restored when user switches tabs', (tester) async {
    when(() => nativeMethods.findAll()).thenAnswer((_) async => [anAudioFile(album: 'Test Album 1'), anAudioFile(album: 'Test Album 2')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Alben'));
    await tester.pumpAndSettle();
    spotText('Test Album 1').existsOnce();
    spotText('Test Album 2').existsOnce();
    await act.tap(spotText('Test Album 1'));
    await tester.pumpAndSettle();
    spotText('Test Album 1').existsOnce();
    spotText('Test Album 2').doesNotExist();
    await act.tap(spot<TabBar>().spotText('Künstler'));
    await tester.pumpAndSettle();
    spot<AlbenTab>().doesNotExist();
    spot<KuenstlerTab>().existsOnce();
    await act.tap(spot<TabBar>().spotText('Alben'));
    await tester.pumpAndSettle();
    spotText('Test Album 1').existsOnce();
    spotText('Test Album 2').doesNotExist();
  });

  testWidgets('An opened album can be closed by tapping on the (<) icon button', (tester) async {
    when(() => nativeMethods.findAll()).thenAnswer((_) async => [anAudioFile(album: 'Test Album 1'), anAudioFile(album: 'Test Album 2')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Alben'));
    await tester.pumpAndSettle();
    spotText('Test Album 1').existsOnce();
    spotText('Test Album 2').existsOnce();
    await act.tap(spotText('Test Album 2'));
    await tester.pumpAndSettle();
    spotText('Test Album 1').doesNotExist();
    spotText('Test Album 2').existsOnce();
    await act.tap(spot<IconButton>().spotIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    spotText('Test Album 1').existsOnce();
    spotText('Test Album 2').existsOnce();
  });

  testWidgets('An opened album can be closed by pressing the back button', (tester) async {
    when(() => nativeMethods.findAll()).thenAnswer((_) async => [anAudioFile(album: 'Test Album 1'), anAudioFile(album: 'Test Album 2')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Alben'));
    await tester.pumpAndSettle();
    spotText('Test Album 1').existsOnce();
    spotText('Test Album 2').existsOnce();
    await act.tap(spotText('Test Album 2'));
    await tester.pumpAndSettle();
    spotText('Test Album 1').doesNotExist();
    spotText('Test Album 2').existsOnce();
    await tester.pressBackButton();
    await tester.pumpAndSettle();
    spotText('Test Album 1').existsOnce();
    spotText('Test Album 2').existsOnce();
  });
}

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
  testWidgets('songs are grouped by kuenstler', (tester) async {
    when(() => audioService.findAll()).thenAnswer(
      (_) async => [anAudioFile(artist: 'Test Artist 1'), anAudioFile(artist: 'Test Artist 1'), anAudioFile(artist: 'Test Artist 2')],
    );
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Künstler'));
    await tester.pumpAndSettle();
    spot<ListTile>().existsExactlyNTimes(2);
    spot<ListTile>().first().spotText('Test Artist 1').existsOnce();
    spot<ListTile>().first().spotText('2 Lieder').existsOnce();
    spot<ListTile>().last().spotText('Test Artist 2').existsOnce();
    spot<ListTile>().last().spotText('1 Lied').existsOnce();
  });

  testWidgets('Tapping on an artist show all songs of that artist', (tester) async {
    when(() => audioService.findAll()).thenAnswer(
      (_) async => [
        anAudioFile(artist: 'Test Artist 1'),
        anAudioFile(artist: 'Test Artist 1'),
        anAudioFile(artist: 'Test Artist 1'),
        anAudioFile(artist: 'Test Artist 2'),
      ],
    );
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Künstler'));
    await tester.pumpAndSettle();
    await act.tap(spotText('Test Artist 1'));
    await tester.pumpAndSettle();
    // TODO: spot<ListTile>().existsExactlyNTimes(3);
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').doesNotExist();
  });

  testWidgets('A selected artist is restored when user switches tabs', (tester) async {
    when(
      () => audioService.findAll(),
    ).thenAnswer((_) async => [anAudioFile(artist: 'Test Artist 1'), anAudioFile(artist: 'Test Artist 2')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Künstler'));
    await tester.pumpAndSettle();
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
    await act.tap(spotText('Test Artist 1'));
    await tester.pumpAndSettle();
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').doesNotExist();
    await act.tap(spot<TabBar>().spotText('Alben'));
    await tester.pumpAndSettle();
    spot<AlbenTab>().existsOnce();
    spot<KuenstlerTab>().doesNotExist();
    await act.tap(spot<TabBar>().spotText('Künstler'));
    await tester.pumpAndSettle();
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').doesNotExist();
  });

  testWidgets('Go back to overview by tapping on the (<) icon button', (tester) async {
    when(
      () => audioService.findAll(),
    ).thenAnswer((_) async => [anAudioFile(artist: 'Test Artist 1'), anAudioFile(artist: 'Test Artist 2')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Künstler'));
    await tester.pumpAndSettle();
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
    await act.tap(spotText('Test Artist 2'));
    await tester.pumpAndSettle();
    spotText('Test Artist 1').doesNotExist();
    spotText('Test Artist 2').existsOnce();
    await act.tap(spot<IconButton>().spotIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
  });

  testWidgets('Go back to overview by pressing the back button', (tester) async {
    when(
      () => audioService.findAll(),
    ).thenAnswer((_) async => [anAudioFile(artist: 'Test Artist 1'), anAudioFile(artist: 'Test Artist 2')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Künstler'));
    await tester.pumpAndSettle();
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
    await act.tap(spotText('Test Artist 2'));
    await tester.pumpAndSettle();
    spotText('Test Artist 1').doesNotExist();
    spotText('Test Artist 2').existsOnce();
    await tester.pressBackButton();
    await tester.pumpAndSettle();
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
  });
}

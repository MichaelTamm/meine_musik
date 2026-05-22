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
    when(() => nativeMethods.findAll()).thenAnswer(
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

  testWidgets('Tapping on an artist shows all songs of that artist', (tester) async {
    final song1 = anAudioFile(artist: 'Test Artist 1');
    final song2 = anAudioFile(artist: 'Test Artist 1');
    when(() => nativeMethods.findAll()).thenAnswer((_) async => [song1, song2, anAudioFile(artist: 'Test Artist 2')]);
    await tester.startApp();
    await act.tapAndSettle(spot<TabBar>().spotText('Künstler'));
    await act.tapAndSettle(spotText('Test Artist 1'));
    spot<ListTile>().existsExactlyNTimes(2);
    spotText(song1.title).existsOnce();
    spotText(song2.title).existsOnce();
    spotText('Test Artist 2').doesNotExist();
  });

  testWidgets('A selected artist is restored when user switches tabs', (tester) async {
    when(
      () => nativeMethods.findAll(),
    ).thenAnswer((_) async => [anAudioFile(artist: 'Test Artist 1'), anAudioFile(artist: 'Test Artist 2')]);
    await tester.startApp();
    // Switch to 'Künstler' tab ...
    await act.tapAndSettle(spot<TabBar>().spotText('Künstler'));
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
    // Open 'Test Artist 1' ...
    await act.tapAndSettle(spotText('Test Artist 1'));
    spotText('Test Artist 1').existsAtLeastOnce();
    spotText('Test Artist 2').doesNotExist();
    // Switch to 'Alben' tab ...
    await act.tapAndSettle(spot<TabBar>().spotText('Alben'));
    spot<AlbenTab>().existsOnce();
    spot<KuenstlerTab>().doesNotExist();
    // Switch back to 'Künstler' tab ...
    await act.tapAndSettle(spot<TabBar>().spotText('Künstler'));
    spotText('Test Artist 1').existsAtLeastOnce();
    spotText('Test Artist 2').doesNotExist();
  });

  testWidgets('Go back to overview by tapping on the (<) icon button', (tester) async {
    when(
      () => nativeMethods.findAll(),
    ).thenAnswer((_) async => [anAudioFile(artist: 'Test Artist 1'), anAudioFile(artist: 'Test Artist 2')]);
    await tester.startApp();
    // Switch to 'Künstler' tab ...
    await act.tapAndSettle(spot<TabBar>().spotText('Künstler'));
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
    // Open 'Test Artist 2' ...
    await act.tapAndSettle(spotText('Test Artist 2'));
    spotText('Test Artist 1').doesNotExist();
    spotText('Test Artist 2').existsAtLeastOnce();
    // Go back to overview by tapping on the (<) icon button ...
    await act.tapAndSettle(spot<IconButton>().spotIcon(Icons.chevron_left_rounded));
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
  });

  testWidgets('Go back to overview by pressing the back button', (tester) async {
    when(
      () => nativeMethods.findAll(),
    ).thenAnswer((_) async => [anAudioFile(artist: 'Test Artist 1'), anAudioFile(artist: 'Test Artist 2')]);
    await tester.startApp();
    // Switch to 'Künstler' tab ...
    await act.tapAndSettle(spot<TabBar>().spotText('Künstler'));
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
    // Open 'Test Artist 2' ...
    await act.tapAndSettle(spotText('Test Artist 2'));
    spotText('Test Artist 1').doesNotExist();
    spotText('Test Artist 2').existsAtLeastOnce();
    // Go back to overview by pressing the back button ...
    await tester.pressBackButton();
    await tester.pumpAndSettle();
    spotText('Test Artist 1').existsOnce();
    spotText('Test Artist 2').existsOnce();
  });
}

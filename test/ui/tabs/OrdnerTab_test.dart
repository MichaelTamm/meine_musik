import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/ui/player_widget/PlayerWidget.dart';
import 'package:meine_musik/ui/tabs/AlbenTab.dart';
import 'package:meine_musik/ui/tabs/OrdnerTab.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spot/spot.dart';

import '../../testdata.dart';
import '../../widget_test_utils.dart';

void main() {
  testWidgets('Folder navigation', (tester) async {
    when(() => nativeMethods.findAll()).thenAnswer(
      (_) async => [
        anAudioFile(path: '/storage/emulated/0/Samsung/Music/Over the Horizon.mp3'),
        anAudioFile(path: '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/01 - Alicia Keys - Piano & I.mp3'),
        anAudioFile(path: '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/02 - Alicia Keys - Girlfriend.mp3'),
      ],
    );
    await tester.startApp();
    await act.tap(spot<TabBar>().spotIcon(Icons.folder_rounded));
    await tester.pumpAndSettle();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().existsOnce();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Dieses Gerät").existsOnce();
    spot<OrdnerTab>().spot<ListTile>().existsExactlyNTimes(2);
    spot<OrdnerTab>().spot<ListTile>().spotText("Samsung").existsOnce();
    spot<OrdnerTab>().spot<ListTile>().spotText("Musik").existsOnce();
    await act.tap(spot<ListTile>().spotText("Samsung"));
    await tester.pumpAndSettle();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().existsExactlyNTimes(2);
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Dieses Gerät").existsOnce();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Samsung").existsOnce();
    spot<OrdnerTab>().spot<ListTile>().spotText("Samsung").doesNotExist();
    await act.tap(spot<OrdnerTab>().spot<ListTile>().spotText("Music"));
    await tester.pumpAndSettle();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().existsExactlyNTimes(3);
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Dieses Gerät").existsOnce();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Samsung").existsOnce();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Music").existsOnce();
    spot<OrdnerTab>().spot<ListTile>().existsOnce();
    spot<OrdnerTab>().spot<ListTile>().spotText("Samsung").doesNotExist();
    spot<OrdnerTab>().spot<ListTile>().spotText("Music").doesNotExist();
    spot<OrdnerTab>().spot<ListTile>().spotText("Over the Horizon.mp3").existsOnce();
    // Pressing the back button should go back to the previous folder ...
    await tester.pressBackButton();
    await tester.pumpAndSettle();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().existsExactlyNTimes(2);
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Dieses Gerät").existsOnce();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Samsung").existsOnce();
    spot<OrdnerTab>().spot<ListTile>().spotText("Samsung").doesNotExist();
    spot<OrdnerTab>().spot<ListTile>().spotText("Music").existsOnce();
    spot<OrdnerTab>().spot<ListTile>().spotText("Over the Horizon.mp3").doesNotExist();
    // User can tap on a folder to go back there ...
    await act.tap(spot<OrdnerTabNavigationBar>().spotText("Dieses Gerät"));
    await tester.pumpAndSettle();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().existsOnce();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Dieses Gerät").existsOnce();
    spot<OrdnerTabNavigationBar>().spotText("Samsung").doesNotExist();
    spot<OrdnerTabNavigationBar>().spotText("Music").doesNotExist();
    spot<OrdnerTab>().spot<ListTile>().existsExactlyNTimes(2);
    spot<OrdnerTab>().spot<ListTile>().spotText("Samsung").existsOnce();
    spot<OrdnerTab>().spot<ListTile>().spotText("Musik").existsOnce();
  });

  testWidgets('Tapping on an audio file will play it', (tester) async {
    when(() => nativeMethods.findAll()).thenAnswer((_) async => [anAudioFile(path: '/storage/emulated/0/some audio file.mp3')]);
    await tester.startApp();
    await act.tap(spot<TabBar>().spotText('Ordner'));
    await tester.pumpAndSettle();
    await act.tap(spotText('some audio file.mp3'));
    await tester.pumpAndSettle();
    spot<PlayerWidget>().spot<IconButton>().spotIcon(Icons.pause).existsOnce();
  });

  testWidgets('Current folder is restored when user switches tabs', (tester) async {
    when(() => nativeMethods.findAll()).thenAnswer(
      (_) async => [
        anAudioFile(path: '/storage/emulated/0/Samsung/Music/Over the Horizon.mp3'),
        anAudioFile(path: '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/01 - Alicia Keys - Piano & I.mp3'),
        anAudioFile(path: '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/02 - Alicia Keys - Girlfriend.mp3'),
      ],
    );
    await tester.startApp();
    await act.tap(spot<TabBar>().spotIcon(Icons.folder_rounded));
    await tester.pumpAndSettle();
    await act.tap(spot<ListTile>().spotText("Musik"));
    await tester.pumpAndSettle();
    await act.tap(spot<TabBar>().spotIcon(Icons.album_rounded));
    await tester.pumpAndSettle();
    spot<AlbenTab>().existsOnce();
    spot<OrdnerTab>().doesNotExist();
    await act.tap(spot<TabBar>().spotIcon(Icons.folder_rounded));
    await tester.pumpAndSettle();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().existsExactlyNTimes(2);
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Dieses Gerät").existsOnce();
    spot<OrdnerTabNavigationBar>().spot<TextButton>().spotText("Musik").existsOnce();
    spot<OrdnerTab>().spot<ListTile>().existsOnce();
    spot<OrdnerTab>().spot<ListTile>().spotText("Musik").doesNotExist();
    spot<OrdnerTab>().spot<ListTile>().spotText("Alicia Keys - Songs In A Minor").existsOnce();
  });
}

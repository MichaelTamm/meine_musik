import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/ui/tabs/AlbenTab.dart';
import 'package:meine_musik/ui/tabs/OrdnerTab.dart';
import 'package:meine_musik/ui/tabs/PlaylistsTab.dart';
import 'package:spot/spot.dart';

import '../widget_test_utils.dart';

void main() {
  testWidgets('Tab navigation', (tester) async {
    await tester.startApp();
    spot<PlaylistsTab>().existsOnce();
    spot<AlbenTab>().doesNotExist();
    await act.tap(spot<TabBar>().spotText("Alben"));
    await tester.pumpAndSettle();
    spot<AlbenTab>().existsOnce();
    spot<PlaylistsTab>().doesNotExist();
    await act.tap(spot<TabBar>().spotIcon(Icons.folder_rounded));
    await tester.pumpAndSettle();
    spot<AlbenTab>().doesNotExist();
    spot<OrdnerTab>().existsOnce();
  });
}
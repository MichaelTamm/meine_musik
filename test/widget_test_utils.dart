import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/model/IsSongPredicate.dart';
import 'package:meine_musik/riverpod/playlists.dart';
import 'package:meine_musik/ui/MeineMusikApp.dart';
import 'package:spot/spot.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> startApp({List<Override> riverpodOverrides = const [], Size screenSize = const Size(360, 640)}) async {
    view
      ..devicePixelRatio = 1
      ..physicalSize = screenSize;
    await binding.setSurfaceSize(screenSize);
    await pumpWidget(
      MeineMusikApp(riverpodOverrides: [isSongPredicateProvider.overrideWith((_) async => IsSongPredicate()), ...riverpodOverrides]),
    );
    await loadAppFonts();
    await pumpAndSettle();
  }

  Future<void> pressBackButton() async {
    final ByteData message = const JSONMethodCodec().encodeMethodCall(const MethodCall('popRoute'));
    await binding.defaultBinaryMessenger.handlePlatformMessage('flutter/navigation', message, (_) {});
  }
}

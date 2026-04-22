import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/model/IsSongPredicate.dart';
import 'package:meine_musik/riverpod/playlists.dart';
import 'package:meine_musik/ui/MeineMusikApp.dart';
import 'package:spot/spot.dart';

class MeineMusikTestBinding extends AutomatedTestWidgetsFlutterBinding {
  MeineMusikTestBinding() {
    showAppDumpInErrors = true;
  }

  @override
  DebugPrintCallback get debugPrintOverride => _onlyPrintOnError;
}

extension WidgetTesterExtension on WidgetTester {
  Future<void> startApp({List<Override> riverpodOverrides = const [], Size screenSize = const Size(360, 640)}) async {
    __tester = this;
    addTearDown(() {
      __tester = null;
    });
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

extension ActExtension on Act {
  Future<void> tapAndSettle(WidgetSelector selector) async {
    await tap(selector);
    await _tester.pumpAndSettle();
  }
}

final debugPrintBuffer = <String>[];

void _onlyPrintOnError(String? message, {int? wrapWidth}) {
  if (StackTrace.current.toString().contains('dumpErrorToConsole')) {
    debugPrintBuffer.forEach(debugPrintSynchronously);
    debugPrintSynchronously(message);
  } else {
    debugPrintBuffer.add(message ?? '');
  }
}

WidgetTester? __tester;

WidgetTester get _tester {
  final tester = __tester;
  if (tester == null) {
    throw StateError('WidgetTester not known until tester.startApp() is called.');
  }
  return tester;
}

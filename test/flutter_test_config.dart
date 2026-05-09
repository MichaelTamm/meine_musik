import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/drift/database.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/model/MeineMusikLogic.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';
import 'testdata.dart';
import 'widget_test_utils.dart';

late MeineMusikTestBinding binding;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  binding = MeineMusikTestBinding();
  initTestdata();

  setUp(() {
    debugPrintBuffer.clear();
    // See https://drift.simonbinder.eu/testing/ ...
    db = Database(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    riverpodContainer = ProviderContainer.test();
    logic = MeineMusikLogic();
    nativeMethods = MockMeineMusikNativeMethods();
    when(() => nativeMethods.findAll()).thenAnswer(
      (_) async => [
        anAudioFile(
          id: 1,
          path: '/storage/emulated/0/Samsung/Music/Over the Horizon.mp3',
          artist: 'Samsung',
          title: 'Over the Horizon',
          album: 'Brand Music',
        ),
      ],
    );
    when(() => nativeMethods.getAlbumCover(any())).thenAnswer((_) async => null);
    musicBrainz = DummyMusicBrainz();
  });

  tearDown(() async {
    await db.close();
  });

  return testMain();
}

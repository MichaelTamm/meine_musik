import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/drift/database.dart';
import 'package:meine_musik/env.dart';

import 'mocks.dart';
import 'testdata.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  initTestdata();

  setUp(() {
    audioService = MockAudioService();
    // See https://drift.simonbinder.eu/testing/ ...
    db = Database(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  return testMain();
}

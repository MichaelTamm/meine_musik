import 'package:audio_session/audio_session.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'env.dart';
import 'services/AudioApi.dart';
import 'drift/database.dart';
import 'ui/MeineMusikApp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeDilation = kSlowDownAnimations ? 10 : 1;
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.music());
  audioService = AudioService();
  db = Database(driftDatabase(name: 'database'));
  // ignore: missing_provider_scope
  runApp(const MeineMusikApp());
}

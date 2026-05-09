import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:audio_session/audio_session.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';

import 'drift/database.dart';
import 'env.dart';
import 'model/MeineMusikLogic.dart';
import 'services/MeineMusikPigeonApi.dart';
import 'services/CoverArtArchive.dart';
import 'services/LoggingHttpClient.dart';
import 'services/MeineMusikAudioHandler.dart';
import 'services/MusicBrainz.dart';
import 'services/TheAudioDB.dart';
import 'ui/MeineMusikApp.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    timeDilation = kSlowDownAnimations ? 10 : 1;
    final getApplicationDocumentsDirectoryFuture = getApplicationDocumentsDirectory();
    final getApplicationCacheDirectoryFuture = getApplicationCacheDirectory();
    final session = await AudioSession.instance;
    final sessionConfigureFuture = session.configure(AudioSessionConfiguration.music());
    nativeMethods = MeineMusikNativeMethods();
    audioHandler = await audio_service.AudioService.init(
      builder: () => MeineMusikAudioHandler(),
      config: const audio_service.AudioServiceConfig(
        androidNotificationChannelId: 'de.michaeltamm.meine_musik.audio',
        androidNotificationChannelName: 'Meine Musik',
        androidNotificationOngoing: true,
      ),
    );
    logic = MeineMusikLogic();
    final loggingHttpClient = LoggingHttpClient();
    musicBrainz = MusicBrainz(loggingHttpClient);
    theAudioDB = TheAudioDB(loggingHttpClient);
    coverArtArchive = CoverArtArchive(loggingHttpClient);
    applicationDocumentsDirectory = await getApplicationDocumentsDirectoryFuture;
    applicationCacheDirectory = await getApplicationCacheDirectoryFuture;
    db = Database(SqfliteQueryExecutor(path: '${applicationDocumentsDirectory.path}/database.sqlite', logStatements: kDebugDrift));
    await sessionConfigureFuture;
    // ignore: missing_provider_scope
    runApp(const MeineMusikApp());
  } catch (error, stack) {
    debugPrintStack(label: 'main() failed -- $error', stackTrace: stack);
  }
}

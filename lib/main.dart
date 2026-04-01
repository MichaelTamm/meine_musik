import 'package:audio_session/audio_session.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';

import 'drift/database.dart';
import 'env.dart';
import 'model/Logic.dart';
import 'services/AudioApi.dart';
import 'services/CoverArtArchive.dart';
import 'services/LoggingHttpClient.dart';
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
    audioService = AudioService();
    db = Database(driftDatabase(name: 'database'));
    logic = Logic();
    final loggingHttpClient = LoggingHttpClient();
    musicBrainz = MusicBrainz(loggingHttpClient);
    theAudioDB = TheAudioDB(loggingHttpClient);
    coverArtArchive = CoverArtArchive(loggingHttpClient);
    applicationDocumentsDirectory = await getApplicationDocumentsDirectoryFuture;
    applicationCacheDirectory = await getApplicationCacheDirectoryFuture;
    await sessionConfigureFuture;
    // ignore: missing_provider_scope
    runApp(const MeineMusikApp());
  } catch (error, stack) {
    debugPrintStack(label: 'main() failed -- $error', stackTrace: stack);
  }
}

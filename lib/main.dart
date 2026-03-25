import 'package:audio_session/audio_session.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meine_musik/services/CoverArtArchive.dart';
import 'package:meine_musik/services/LoggingHttpClient.dart';
import 'package:meine_musik/services/TheAudioDB.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';
import 'package:path_provider/path_provider.dart';

import 'drift/database.dart';
import 'env.dart';
import 'services/AudioApi.dart';
import 'ui/MeineMusikApp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeDilation = kSlowDownAnimations ? 10 : 1;
  final getApplicationDocumentsDirectoryFuture = getApplicationDocumentsDirectory();
  final getApplicationCacheDirectoryFuture = getApplicationCacheDirectory();
  final session = await AudioSession.instance;
  final sessionConfigureFuture = session.configure(AudioSessionConfiguration.music());
  audioService = AudioService();
  db = Database(driftDatabase(name: 'database'));
  final loggingHttpClient = LoggingHttpClient();
  musicBrainz = MusicBrainzApiClient(httpClient: loggingHttpClient, isSilent: false);
  theAudioDB = TheAudioDB(loggingHttpClient);
  coverArtArchive = CoverArtArchive(loggingHttpClient);
  applicationDocumentsDirectory = await getApplicationDocumentsDirectoryFuture;
  applicationCacheDirectory = await getApplicationCacheDirectoryFuture;
  await sessionConfigureFuture;
  // ignore: missing_provider_scope
  runApp(const MeineMusikApp());
}

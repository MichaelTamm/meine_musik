import 'dart:io';

import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:audio_session/audio_session.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'debug_utils.dart';
import 'drift/database.dart';
import 'env.dart';
import 'model/MeineMusikLogic.dart';
import 'services/CoverArtArchive.dart';
import 'services/LoggingHttpClient.dart';
import 'services/MeineMusikAudioHandler.dart';
import 'services/MeineMusikPigeonApi.dart';
import 'services/MusicBrainz.dart';
import 'services/TheAudioDB.dart';
import 'ui/MeineMusikApp.dart';

Future<void> main() async {
  try {
    SentryWidgetsFlutterBinding.ensureInitialized();
    timeDilation = kSlowDownAnimations ? 10 : 1;
    final getApplicationDocumentsDirectoryFuture = getApplicationDocumentsDirectory();
    final getApplicationCacheDirectoryFuture = getApplicationCacheDirectory();
    audioHandler = await audio_service.AudioService.init(
      builder: () => MeineMusikAudioHandler(),
      config: const audio_service.AudioServiceConfig(
        androidNotificationChannelId: 'de.michaeltamm.meine_musik.audio',
        androidNotificationChannelName: 'Meine Musik',
        androidNotificationOngoing: true,
      ),
    );
    final session = await AudioSession.instance;
    final sessionConfigureFuture = session.configure(AudioSessionConfiguration.music());
    nativeMethods = MeineMusikNativeMethods();
    logic = MeineMusikLogic();
    final loggingHttpClient = LoggingHttpClient();
    musicBrainz = MusicBrainz(loggingHttpClient);
    theAudioDB = TheAudioDB(loggingHttpClient);
    coverArtArchive = CoverArtArchive(loggingHttpClient);
    applicationDocumentsDirectory = await getApplicationDocumentsDirectoryFuture;
    applicationSupportDirectory = await getApplicationDocumentsDirectoryFuture;
    applicationCacheDirectory = await getApplicationCacheDirectoryFuture;
    db = Database(SqfliteQueryExecutor(path: '${applicationDocumentsDirectory.path}/database.sqlite', logStatements: kDebugDrift));
    await sessionConfigureFuture;
    // ignore: missing_provider_scope
    await initSentry(
      appRunner: () => runApp(
        SentryWidget(
          child: MeineMusikApp(
            init: () async {
              try {
                final appVersion_ = await kMethodChannel.invokeMethod<String>("getAppVersion");
                if (appVersion_ != null) {
                  appVersion = appVersion_;
                }
              } catch (error, stack) {
                debugPrintStack(label: 'Failed to invoke getAppVersion: $error', stackTrace: stack);
              }
              Sentry.configureScope((scope) {
                scope.setTag('appVersion', appVersion);
                scope.setTag('timezone', DateTime.now().timeZoneName);
                scope.setTag('locale', Platform.localeName);
              });
              WidgetsBinding.instance.addObserver(_WidgetsBindingObserver());
              addBreadcrumb('Meine Musik app (version: $appVersion) started.');
            },
          ),
        ),
      ),
    );
  } catch (error, stack) {
    debugPrintStack(label: 'main() failed -- $error', stackTrace: stack);
  }
}

class _WidgetsBindingObserver extends WidgetsBindingObserver {
  String _lastState = '???';

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      lastTimeAppLifecycleStateChanged = DateTime.now();
      addBreadcrumb('AppLifecycleState changed: $_lastState => ${state.name}');
      _lastState = state.name;
    } catch (error, stack) {
      reportError('$_WidgetsBindingObserver.didChangeAppLifecycleState($state) failed', error, stack);
    }
  }
}

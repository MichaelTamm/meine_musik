import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'drift/database.dart';
import 'model/Logic.dart';
import 'services/AudioApi.dart';
import 'services/CoverArtArchive.dart';
import 'services/MusicBrainz.dart';
import 'services/TheAudioDB.dart';

/// Set to true to slow down animations (e.g. for testing purposes).
const kSlowDownAnimations = false;

final kIsTest = Platform.environment.containsKey('FLUTTER_TEST');

final bool kIsAppleDevice = Platform.isIOS || Platform.isMacOS;

const kMethodChannel = MethodChannel('de.michaeltamm.meine_musik');

/// Set to `true` to enable logging of riverpod activity.
const kDebugRiverpod = false;

late Directory applicationDocumentsDirectory;
late Directory applicationCacheDirectory;
late AudioService audioService;
late CoverArtArchive coverArtArchive;
late Database db;
late Logic logic;
late MusicBrainz musicBrainz;
late ProviderContainer riverpodContainer;
late TheAudioDB theAudioDB;

final class _RiverpodObserver extends ProviderObserver {
  static const _blacklist = {'currentSongPositionProvider'};

  final Set<ProviderBase> activeProviders = {};

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    activeProviders.add(context.provider);
    if (!kDebugRiverpod) {
      return;
    }
    final p = _providerToString(context.provider);
    if (_blacklist.contains(p)) {
      return;
    }
    final v = _valueToString(value);
    debugPrint('[riverpod] $p added, initial value: $v');
  }

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    final p = _providerToString(context.provider);
    debugPrintStack(label: '[riverpod] $p failed: $error', stackTrace: stackTrace);
  }

  @override
  void didUpdateProvider(ProviderObserverContext context, Object? oldValue, Object? newValue) {
    if (!kDebugRiverpod) {
      return;
    }
    final p = _providerToString(context.provider);
    if (_blacklist.contains(p)) {
      return;
    }
    final v1 = _valueToString(oldValue);
    final v2 = _valueToString(newValue);
    debugPrint('[riverpod] $p updated: $v1 => $v2');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    activeProviders.remove(context.provider);
    if (!kDebugRiverpod) {
      return;
    }
    final p = _providerToString(context.provider);
    if (_blacklist.contains(p)) {
      return;
    }
    debugPrint('[riverpod] $p disposed');
  }

  String _providerToString(ProviderBase provider) {
    final name = provider.name ?? provider.runtimeType.toString();
    return provider.argument == null ? name : '$name(${provider.argument})';
  }

  String _valueToString(Object? value) {
    if (value == null) {
      return 'null';
    }
    if (value is bool || value is num || value is DateTime) {
      return value.toString();
    }
    if (value is String) {
      final i = value.indexOf('\n');
      return jsonEncode(i >= 0 ? value.substring(0, i) : value);
    }
    final s = value.toString();
    final i = s.indexOf('\n');
    return i > 0 ? '${s.substring(0, i)}...' : s;
  }
}

final riverpodObserver = _RiverpodObserver();

void clearCaches() {
  coverArtArchive.clearCache();
  musicBrainz.clearCache();
  theAudioDB.clearCache();
  final activeProvidersSnapshot = [...riverpodObserver.activeProviders];
  for (final provider in activeProvidersSnapshot) {
    riverpodContainer.invalidate(provider);
  }
}

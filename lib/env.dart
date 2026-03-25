import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:meine_musik/drift/database.dart';
import 'package:meine_musik/services/CoverArtArchive.dart';
import 'package:meine_musik/services/TheAudioDB.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

import 'services/AudioApi.dart';

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
late Database db;
late MusicBrainzApiClient musicBrainz;
late TheAudioDB theAudioDB;
late CoverArtArchive coverArtArchive;

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

class _RiverpodContainer {
  BuildContext? context;

  T read<T>(ProviderListenable<T> provider) {
    final context_ = context;
    if (context_ == null) {
      throw StateError('MeineMusikApp not mounted');
    }
    return ProviderScope.containerOf(context_, listen: false).read(provider);
  }

  void refresh(ProviderBase provider) {
    final context_ = context;
    if (context_ == null) {
      throw StateError('MeineMusikApp not mounted');
    }
    ProviderScope.containerOf(context_).refresh(provider);
  }

  void invalidate(ProviderBase provider) {
    final context_ = context;
    if (context_ == null) {
      throw StateError('MeineMusikApp not mounted');
    }
    ProviderScope.containerOf(context_).invalidate(provider);
  }

  void invalidateAll() {
    final context_ = context;
    if (context_ == null) {
      throw StateError('MeineMusikApp not mounted');
    }
    final providerScope = ProviderScope.containerOf(context_);
    for (final provider in riverpodObserver.activeProviders) {
      providerScope.invalidate(provider);
    }
  }
}

final riverpodContainer = _RiverpodContainer();

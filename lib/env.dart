import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:meine_musik/drift/database.dart';

import 'services/AudioApi.dart';

/// Set to true to slow down animations (e.g. for testing purposes).
const kSlowDownAnimations = false;

final kIsTest = Platform.environment.containsKey('FLUTTER_TEST');

final bool kIsAppleDevice = Platform.isIOS || Platform.isMacOS;

const kMethodChannel = MethodChannel('de.michaeltamm.meine_musik');

/// Set to `true` to enable logging of riverpod activity.
const kDebugRiverpod = false;

late AudioService audioService;
late Database db;

final riverpodContainer = _RiverpodContainer();

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
}

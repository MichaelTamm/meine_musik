// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The playlist, which is currently being played.
/// Initial value: an empty playlist
/// Updated by: [AudioPlayerWrapper] methods

@ProviderFor(CurrentPlaylist)
const currentPlaylistProvider = CurrentPlaylistProvider._();

/// The playlist, which is currently being played.
/// Initial value: an empty playlist
/// Updated by: [AudioPlayerWrapper] methods
final class CurrentPlaylistProvider extends $NotifierProvider<CurrentPlaylist, Wiedergabeliste> {
  /// The playlist, which is currently being played.
  /// Initial value: an empty playlist
  /// Updated by: [AudioPlayerWrapper] methods
  const CurrentPlaylistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPlaylistProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPlaylistHash();

  @$internal
  @override
  CurrentPlaylist create() => CurrentPlaylist();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Wiedergabeliste value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Wiedergabeliste>(value));
  }
}

String _$currentPlaylistHash() => r'9d52fce491f4840f1af03d53fb9bea5e97844e1a';

/// The playlist, which is currently being played.
/// Initial value: an empty playlist
/// Updated by: [AudioPlayerWrapper] methods

abstract class _$CurrentPlaylist extends $Notifier<Wiedergabeliste> {
  Wiedergabeliste build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Wiedergabeliste, Wiedergabeliste>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<Wiedergabeliste, Wiedergabeliste>, Wiedergabeliste, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// The song currently being played.
/// Initial value: [_noSong]
/// Updated by: [AudioPlayerWrapper] methods

@ProviderFor(CurrentSong)
const currentSongProvider = CurrentSongProvider._();

/// The song currently being played.
/// Initial value: [_noSong]
/// Updated by: [AudioPlayerWrapper] methods
final class CurrentSongProvider extends $NotifierProvider<CurrentSong, Song> {
  /// The song currently being played.
  /// Initial value: [_noSong]
  /// Updated by: [AudioPlayerWrapper] methods
  const CurrentSongProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSongProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSongHash();

  @$internal
  @override
  CurrentSong create() => CurrentSong();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Song value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Song>(value));
  }
}

String _$currentSongHash() => r'4cd3dbe4de3e5aebbf8dba538f3b5d327a561da2';

/// The song currently being played.
/// Initial value: [_noSong]
/// Updated by: [AudioPlayerWrapper] methods

abstract class _$CurrentSong extends $Notifier<Song> {
  Song build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Song, Song>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<Song, Song>, Song, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// The label to be displayed for the current song.
/// Initial value: ''
/// Updated by: [CurrentSong._set]

@ProviderFor(CurrentSongLabel)
const currentSongLabelProvider = CurrentSongLabelProvider._();

/// The label to be displayed for the current song.
/// Initial value: ''
/// Updated by: [CurrentSong._set]
final class CurrentSongLabelProvider extends $NotifierProvider<CurrentSongLabel, String> {
  /// The label to be displayed for the current song.
  /// Initial value: ''
  /// Updated by: [CurrentSong._set]
  const CurrentSongLabelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSongLabelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSongLabelHash();

  @$internal
  @override
  CurrentSongLabel create() => CurrentSongLabel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String>(value));
  }
}

String _$currentSongLabelHash() => r'f61602984286fd2c88a56442e9ae8a447422b776';

/// The label to be displayed for the current song.
/// Initial value: ''
/// Updated by: [CurrentSong._set]

abstract class _$CurrentSongLabel extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CurrentSongPosition)
const currentSongPositionProvider = CurrentSongPositionProvider._();

final class CurrentSongPositionProvider extends $NotifierProvider<CurrentSongPosition, Duration> {
  const CurrentSongPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSongPositionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSongPositionHash();

  @$internal
  @override
  CurrentSongPosition create() => CurrentSongPosition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Duration>(value));
  }
}

String _$currentSongPositionHash() => r'e19206ec3775d24c61be54d97c882682cba9126f';

abstract class _$CurrentSongPosition extends $Notifier<Duration> {
  Duration build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Duration, Duration>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<Duration, Duration>, Duration, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(IsPlayingPausedOrCompleted)
const isPlayingPausedOrCompletedProvider = IsPlayingPausedOrCompletedProvider._();

final class IsPlayingPausedOrCompletedProvider extends $NotifierProvider<IsPlayingPausedOrCompleted, PlayingPausedOrCompleted> {
  const IsPlayingPausedOrCompletedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isPlayingPausedOrCompletedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isPlayingPausedOrCompletedHash();

  @$internal
  @override
  IsPlayingPausedOrCompleted create() => IsPlayingPausedOrCompleted();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayingPausedOrCompleted value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PlayingPausedOrCompleted>(value));
  }
}

String _$isPlayingPausedOrCompletedHash() => r'34ed484066b4d30af6de90cfb2c49ade1c77ebf3';

abstract class _$IsPlayingPausedOrCompleted extends $Notifier<PlayingPausedOrCompleted> {
  PlayingPausedOrCompleted build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PlayingPausedOrCompleted, PlayingPausedOrCompleted>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayingPausedOrCompleted, PlayingPausedOrCompleted>,
              PlayingPausedOrCompleted,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CurrentRepeatMode)
const currentRepeatModeProvider = CurrentRepeatModeProvider._();

final class CurrentRepeatModeProvider extends $NotifierProvider<CurrentRepeatMode, RepeatMode> {
  const CurrentRepeatModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentRepeatModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentRepeatModeHash();

  @$internal
  @override
  CurrentRepeatMode create() => CurrentRepeatMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RepeatMode value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RepeatMode>(value));
  }
}

String _$currentRepeatModeHash() => r'b14f2a0dd1795d7027faf3fbb12766f7b73f209e';

abstract class _$CurrentRepeatMode extends $Notifier<RepeatMode> {
  RepeatMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RepeatMode, RepeatMode>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<RepeatMode, RepeatMode>, RepeatMode, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Player)
const playerProvider = PlayerProvider._();

final class PlayerProvider extends $NotifierProvider<Player, AudioPlayerWrapper> {
  const PlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerHash();

  @$internal
  @override
  Player create() => Player();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioPlayerWrapper value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AudioPlayerWrapper>(value));
  }
}

String _$playerHash() => r'0b469b766c578ad7e3066d95d79d4405621cd8d4';

abstract class _$Player extends $Notifier<AudioPlayerWrapper> {
  AudioPlayerWrapper build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AudioPlayerWrapper, AudioPlayerWrapper>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AudioPlayerWrapper, AudioPlayerWrapper>, AudioPlayerWrapper, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

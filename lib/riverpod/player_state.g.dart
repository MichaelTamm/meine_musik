// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The playlist, which is currently being played.
/// Initial value: `Playlist.empty`

@ProviderFor(CurrentPlaylist)
const currentPlaylistProvider = CurrentPlaylistProvider._();

/// The playlist, which is currently being played.
/// Initial value: `Playlist.empty`
final class CurrentPlaylistProvider extends $NotifierProvider<CurrentPlaylist, Playlist> {
  /// The playlist, which is currently being played.
  /// Initial value: `Playlist.empty`
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
  Override overrideWithValue(Playlist value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Playlist>(value));
  }
}

String _$currentPlaylistHash() => r'b65026ae68dcaa2a5b3044462a084228900ef822';

/// The playlist, which is currently being played.
/// Initial value: `Playlist.empty`

abstract class _$CurrentPlaylist extends $Notifier<Playlist> {
  Playlist build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Playlist, Playlist>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<Playlist, Playlist>, Playlist, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// The song currently being played.
/// Initial value: [CurrentSong.none]

@ProviderFor(CurrentSong)
const currentSongProvider = CurrentSongProvider._();

/// The song currently being played.
/// Initial value: [CurrentSong.none]
final class CurrentSongProvider
    extends $NotifierProvider<CurrentSong, ({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song})> {
  /// The song currently being played.
  /// Initial value: [CurrentSong.none]
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
  Override overrideWithValue(({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song})>(value),
    );
  }
}

String _$currentSongHash() => r'9bccff7ea85f6eb135b2d2b15550549d68951976';

/// The song currently being played.
/// Initial value: [CurrentSong.none]

abstract class _$CurrentSong extends $Notifier<({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song})> {
  ({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song}) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              ({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song}),
              ({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song})
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song}),
                ({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song})
              >,
              ({Duration duration, String label, int playOrderIndex, int playlistIndex, Song song}),
              Object?,
              Object?
            >;
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

String _$currentSongPositionHash() => r'8a1f4954f9dbb9deeee044a7e4851de7c9817ea4';

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

String _$isPlayingPausedOrCompletedHash() => r'ececa06445945456720cf6412436cb6689075ac4';

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

String _$currentRepeatModeHash() => r'890476eac02e0fdb743f2741d0d055bdf3d121a0';

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

String _$playerHash() => r'438602698dca3bae42e2c5dfcbf6b17234541cbd';

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

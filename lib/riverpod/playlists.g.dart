// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playlists)
const playlistsProvider = PlaylistsProvider._();

final class PlaylistsProvider extends $FunctionalProvider<AsyncValue<List<Playlist>>, List<Playlist>, FutureOr<List<Playlist>>>
    with $FutureModifier<List<Playlist>>, $FutureProvider<List<Playlist>> {
  const PlaylistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistsHash();

  @$internal
  @override
  $FutureProviderElement<List<Playlist>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Playlist>> create(Ref ref) {
    return playlists(ref);
  }
}

String _$playlistsHash() => r'12766938c42e41d515671961e979353bae171c54';

@ProviderFor(alleLieder)
const alleLiederProvider = AlleLiederProvider._();

final class AlleLiederProvider extends $FunctionalProvider<AsyncValue<AlleLieder>, AlleLieder, FutureOr<AlleLieder>>
    with $FutureModifier<AlleLieder>, $FutureProvider<AlleLieder> {
  const AlleLiederProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alleLiederProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alleLiederHash();

  @$internal
  @override
  $FutureProviderElement<AlleLieder> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<AlleLieder> create(Ref ref) {
    return alleLieder(ref);
  }
}

String _$alleLiederHash() => r'4ea3cefb784bf34cf8e10f073c66254a1c90c1cc';

@ProviderFor(favoriten)
const favoritenProvider = FavoritenProvider._();

final class FavoritenProvider extends $FunctionalProvider<AsyncValue<Favoriten>, Favoriten, FutureOr<Favoriten>>
    with $FutureModifier<Favoriten>, $FutureProvider<Favoriten> {
  const FavoritenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritenHash();

  @$internal
  @override
  $FutureProviderElement<Favoriten> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Favoriten> create(Ref ref) {
    return favoriten(ref);
  }
}

String _$favoritenHash() => r'070df12961913aa3484b40820b0917ef7a5813b9';

@ProviderFor(manuallyCreatedPlaylistIds)
const manuallyCreatedPlaylistIdsProvider = ManuallyCreatedPlaylistIdsProvider._();

final class ManuallyCreatedPlaylistIdsProvider extends $FunctionalProvider<AsyncValue<List<int>>, List<int>, FutureOr<List<int>>>
    with $FutureModifier<List<int>>, $FutureProvider<List<int>> {
  const ManuallyCreatedPlaylistIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manuallyCreatedPlaylistIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manuallyCreatedPlaylistIdsHash();

  @$internal
  @override
  $FutureProviderElement<List<int>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<int>> create(Ref ref) {
    return manuallyCreatedPlaylistIds(ref);
  }
}

String _$manuallyCreatedPlaylistIdsHash() => r'bde284e8f449a6bea41974c20b9f1abd26369c17';

@ProviderFor(manuallyCreatedPlaylist)
const manuallyCreatedPlaylistProvider = ManuallyCreatedPlaylistFamily._();

final class ManuallyCreatedPlaylistProvider
    extends $FunctionalProvider<AsyncValue<ManuallyCreatedPlaylist>, ManuallyCreatedPlaylist, FutureOr<ManuallyCreatedPlaylist>>
    with $FutureModifier<ManuallyCreatedPlaylist>, $FutureProvider<ManuallyCreatedPlaylist> {
  const ManuallyCreatedPlaylistProvider._({required ManuallyCreatedPlaylistFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'manuallyCreatedPlaylistProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manuallyCreatedPlaylistHash();

  @override
  String toString() {
    return r'manuallyCreatedPlaylistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ManuallyCreatedPlaylist> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<ManuallyCreatedPlaylist> create(Ref ref) {
    final argument = this.argument as int;
    return manuallyCreatedPlaylist(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ManuallyCreatedPlaylistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$manuallyCreatedPlaylistHash() => r'22781b3fcee370d26e052950d0f632c699602ae9';

final class ManuallyCreatedPlaylistFamily extends $Family with $FunctionalFamilyOverride<FutureOr<ManuallyCreatedPlaylist>, int> {
  const ManuallyCreatedPlaylistFamily._()
    : super(
        retry: null,
        name: r'manuallyCreatedPlaylistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ManuallyCreatedPlaylistProvider call(int playlistId) => ManuallyCreatedPlaylistProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'manuallyCreatedPlaylistProvider';
}

@ProviderFor(manuallyCreatedPlaylists)
const manuallyCreatedPlaylistsProvider = ManuallyCreatedPlaylistsProvider._();

final class ManuallyCreatedPlaylistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ManuallyCreatedPlaylist>>,
          List<ManuallyCreatedPlaylist>,
          FutureOr<List<ManuallyCreatedPlaylist>>
        >
    with $FutureModifier<List<ManuallyCreatedPlaylist>>, $FutureProvider<List<ManuallyCreatedPlaylist>> {
  const ManuallyCreatedPlaylistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manuallyCreatedPlaylistsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manuallyCreatedPlaylistsHash();

  @$internal
  @override
  $FutureProviderElement<List<ManuallyCreatedPlaylist>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ManuallyCreatedPlaylist>> create(Ref ref) {
    return manuallyCreatedPlaylists(ref);
  }
}

String _$manuallyCreatedPlaylistsHash() => r'0eb39ecccfa38e44a8c002e2b3e4156f29f315f0';

@ProviderFor(isSongPredicate)
const isSongPredicateProvider = IsSongPredicateProvider._();

final class IsSongPredicateProvider extends $FunctionalProvider<AsyncValue<IsSongPredicate>, IsSongPredicate, FutureOr<IsSongPredicate>>
    with $FutureModifier<IsSongPredicate>, $FutureProvider<IsSongPredicate> {
  const IsSongPredicateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isSongPredicateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isSongPredicateHash();

  @$internal
  @override
  $FutureProviderElement<IsSongPredicate> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<IsSongPredicate> create(Ref ref) {
    return isSongPredicate(ref);
  }
}

String _$isSongPredicateHash() => r'05ff583a4e6c5116b991e791889f83a4c045cd02';

/// The id of the manually created playlist, to which a song is added, when the bookmark button is pressed.
/// If id == null the bookmark target is the Favoriten playlist.
/// Initial value: null

@ProviderFor(CurrentBookmarkTargetId)
const currentBookmarkTargetIdProvider = CurrentBookmarkTargetIdProvider._();

/// The id of the manually created playlist, to which a song is added, when the bookmark button is pressed.
/// If id == null the bookmark target is the Favoriten playlist.
/// Initial value: null
final class CurrentBookmarkTargetIdProvider extends $NotifierProvider<CurrentBookmarkTargetId, int?> {
  /// The id of the manually created playlist, to which a song is added, when the bookmark button is pressed.
  /// If id == null the bookmark target is the Favoriten playlist.
  /// Initial value: null
  const CurrentBookmarkTargetIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBookmarkTargetIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBookmarkTargetIdHash();

  @$internal
  @override
  CurrentBookmarkTargetId create() => CurrentBookmarkTargetId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<int?>(value));
  }
}

String _$currentBookmarkTargetIdHash() => r'1ebcbd51fe18256b947784fdd83b74d01338c61c';

/// The id of the manually created playlist, to which a song is added, when the bookmark button is pressed.
/// If id == null the bookmark target is the Favoriten playlist.
/// Initial value: null

abstract class _$CurrentBookmarkTargetId extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int?, int?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<int?, int?>, int?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(currentBookmarkTarget)
const currentBookmarkTargetProvider = CurrentBookmarkTargetProvider._();

final class CurrentBookmarkTargetProvider extends $FunctionalProvider<AsyncValue<Playlist>, Playlist, FutureOr<Playlist>>
    with $FutureModifier<Playlist>, $FutureProvider<Playlist> {
  const CurrentBookmarkTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBookmarkTargetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBookmarkTargetHash();

  @$internal
  @override
  $FutureProviderElement<Playlist> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Playlist> create(Ref ref) {
    return currentBookmarkTarget(ref);
  }
}

String _$currentBookmarkTargetHash() => r'f7e89566ac5348d2490c8ba4d9591076be88fd93';

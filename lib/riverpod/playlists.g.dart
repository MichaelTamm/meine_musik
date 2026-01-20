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
        isAutoDispose: true,
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

String _$playlistsHash() => r'bb97eec4e596a48d6628485d634067e115a32671';

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
        isAutoDispose: true,
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

String _$alleLiederHash() => r'defd4c7abafe1642ef0192fc7b34a59b56ba59f0';

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
        isAutoDispose: true,
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

String _$favoritenHash() => r'31eff24c1145993726faa26270ef675afadee05d';

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
        isAutoDispose: true,
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

String _$manuallyCreatedPlaylistsHash() => r'f2e798c895deadecedcbed3269b5250aef87245b';

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
        isAutoDispose: true,
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

String _$isSongPredicateHash() => r'7c1340f34b24c5dd7bf288dba0ee0e4b63aa865d';

@ProviderFor(isFavoriteSongPredicate)
const isFavoriteSongPredicateProvider = IsFavoriteSongPredicateProvider._();

final class IsFavoriteSongPredicateProvider
    extends $FunctionalProvider<AsyncValue<IsFavoriteSongPredicate>, IsFavoriteSongPredicate, FutureOr<IsFavoriteSongPredicate>>
    with $FutureModifier<IsFavoriteSongPredicate>, $FutureProvider<IsFavoriteSongPredicate> {
  const IsFavoriteSongPredicateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isFavoriteSongPredicateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isFavoriteSongPredicateHash();

  @$internal
  @override
  $FutureProviderElement<IsFavoriteSongPredicate> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<IsFavoriteSongPredicate> create(Ref ref) {
    return isFavoriteSongPredicate(ref);
  }
}

String _$isFavoriteSongPredicateHash() => r'27432341621af69c44630239d63ad1008b7f8dfa';

/// The playlist, to which a song is added, when the bookmark button is pressed.
/// Initial value: Favoriten

@ProviderFor(CurrentBookmarkTarget)
const currentBookmarkTargetProvider = CurrentBookmarkTargetProvider._();

/// The playlist, to which a song is added, when the bookmark button is pressed.
/// Initial value: Favoriten
final class CurrentBookmarkTargetProvider extends $AsyncNotifierProvider<CurrentBookmarkTarget, Playlist> {
  /// The playlist, to which a song is added, when the bookmark button is pressed.
  /// Initial value: Favoriten
  const CurrentBookmarkTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBookmarkTargetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBookmarkTargetHash();

  @$internal
  @override
  CurrentBookmarkTarget create() => CurrentBookmarkTarget();
}

String _$currentBookmarkTargetHash() => r'56ee774a76c6522d42af4858ff54505f1dc12f63';

/// The playlist, to which a song is added, when the bookmark button is pressed.
/// Initial value: Favoriten

abstract class _$CurrentBookmarkTarget extends $AsyncNotifier<Playlist> {
  FutureOr<Playlist> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Playlist>, Playlist>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<Playlist>, Playlist>, AsyncValue<Playlist>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

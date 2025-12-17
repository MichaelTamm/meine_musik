// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playlists)
const playlistsProvider = PlaylistsProvider._();

final class PlaylistsProvider extends $FunctionalProvider<AsyncValue<List<Playlist>>, List<Playlist>, FutureOr<List<Playlist>>> with $FutureModifier<List<Playlist>>, $FutureProvider<List<Playlist>> {
  const PlaylistsProvider._() : super(from: null, argument: null, retry: null, name: r'playlistsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

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

String _$playlistsHash() => r'b9bd6b8c5455b5024cc381a6719e8975e119109d';

@ProviderFor(allSongs)
const allSongsProvider = AllSongsProvider._();

final class AllSongsProvider extends $FunctionalProvider<AsyncValue<AllSongs>, AllSongs, FutureOr<AllSongs>> with $FutureModifier<AllSongs>, $FutureProvider<AllSongs> {
  const AllSongsProvider._() : super(from: null, argument: null, retry: null, name: r'allSongsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$allSongsHash();

  @$internal
  @override
  $FutureProviderElement<AllSongs> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<AllSongs> create(Ref ref) {
    return allSongs(ref);
  }
}

String _$allSongsHash() => r'636a38b8f5fff0a91b3d48b577df75776132f87d';

@ProviderFor(favoriteSongs)
const favoriteSongsProvider = FavoriteSongsProvider._();

final class FavoriteSongsProvider extends $FunctionalProvider<AsyncValue<FavoriteSongs>, FavoriteSongs, FutureOr<FavoriteSongs>> with $FutureModifier<FavoriteSongs>, $FutureProvider<FavoriteSongs> {
  const FavoriteSongsProvider._() : super(from: null, argument: null, retry: null, name: r'favoriteSongsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$favoriteSongsHash();

  @$internal
  @override
  $FutureProviderElement<FavoriteSongs> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<FavoriteSongs> create(Ref ref) {
    return favoriteSongs(ref);
  }
}

String _$favoriteSongsHash() => r'b0475afcac8fb740b842adfff30d245aba72fe85';

@ProviderFor(manuallyCreatedPlaylists)
const manuallyCreatedPlaylistsProvider = ManuallyCreatedPlaylistsProvider._();

final class ManuallyCreatedPlaylistsProvider extends $FunctionalProvider<AsyncValue<List<ManuallyCreatedPlaylist>>, List<ManuallyCreatedPlaylist>, FutureOr<List<ManuallyCreatedPlaylist>>>
    with $FutureModifier<List<ManuallyCreatedPlaylist>>, $FutureProvider<List<ManuallyCreatedPlaylist>> {
  const ManuallyCreatedPlaylistsProvider._()
    : super(from: null, argument: null, retry: null, name: r'manuallyCreatedPlaylistsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

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
  const IsSongPredicateProvider._() : super(from: null, argument: null, retry: null, name: r'isSongPredicateProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

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

final class IsFavoriteSongPredicateProvider extends $FunctionalProvider<AsyncValue<IsFavoriteSongPredicate>, IsFavoriteSongPredicate, FutureOr<IsFavoriteSongPredicate>>
    with $FutureModifier<IsFavoriteSongPredicate>, $FutureProvider<IsFavoriteSongPredicate> {
  const IsFavoriteSongPredicateProvider._()
    : super(from: null, argument: null, retry: null, name: r'isFavoriteSongPredicateProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playlistsDatabaseRecords)
const playlistsDatabaseRecordsProvider = PlaylistsDatabaseRecordsProvider._();

final class PlaylistsDatabaseRecordsProvider extends $FunctionalProvider<AsyncValue<List<Playlist>>, List<Playlist>, Stream<List<Playlist>>>
    with $FutureModifier<List<Playlist>>, $StreamProvider<List<Playlist>> {
  const PlaylistsDatabaseRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistsDatabaseRecordsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistsDatabaseRecordsHash();

  @$internal
  @override
  $StreamProviderElement<List<Playlist>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Playlist>> create(Ref ref) {
    return playlistsDatabaseRecords(ref);
  }
}

String _$playlistsDatabaseRecordsHash() => r'0558d8fc3403e08311f59f44a086e2f6c494bc55';

@ProviderFor(playlistItemsDatabaseRecords)
const playlistItemsDatabaseRecordsProvider = PlaylistItemsDatabaseRecordsFamily._();

final class PlaylistItemsDatabaseRecordsProvider
    extends $FunctionalProvider<AsyncValue<List<PlaylistItem>>, List<PlaylistItem>, Stream<List<PlaylistItem>>>
    with $FutureModifier<List<PlaylistItem>>, $StreamProvider<List<PlaylistItem>> {
  const PlaylistItemsDatabaseRecordsProvider._({required PlaylistItemsDatabaseRecordsFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'playlistItemsDatabaseRecordsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistItemsDatabaseRecordsHash();

  @override
  String toString() {
    return r'playlistItemsDatabaseRecordsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PlaylistItem>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<PlaylistItem>> create(Ref ref) {
    final argument = this.argument as int;
    return playlistItemsDatabaseRecords(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistItemsDatabaseRecordsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistItemsDatabaseRecordsHash() => r'4d6a688566ab4ed777f1bc0319554984ffa33645';

final class PlaylistItemsDatabaseRecordsFamily extends $Family with $FunctionalFamilyOverride<Stream<List<PlaylistItem>>, int> {
  const PlaylistItemsDatabaseRecordsFamily._()
    : super(
        retry: null,
        name: r'playlistItemsDatabaseRecordsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PlaylistItemsDatabaseRecordsProvider call(int playlistId) => PlaylistItemsDatabaseRecordsProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'playlistItemsDatabaseRecordsProvider';
}

@ProviderFor(favoritesDatabaseRecords)
const favoritesDatabaseRecordsProvider = FavoritesDatabaseRecordsProvider._();

final class FavoritesDatabaseRecordsProvider extends $FunctionalProvider<AsyncValue<List<Favorite>>, List<Favorite>, Stream<List<Favorite>>>
    with $FutureModifier<List<Favorite>>, $StreamProvider<List<Favorite>> {
  const FavoritesDatabaseRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesDatabaseRecordsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesDatabaseRecordsHash();

  @$internal
  @override
  $StreamProviderElement<List<Favorite>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Favorite>> create(Ref ref) {
    return favoritesDatabaseRecords(ref);
  }
}

String _$favoritesDatabaseRecordsHash() => r'2478abd6942de49ea3634e471c485f142197add0';

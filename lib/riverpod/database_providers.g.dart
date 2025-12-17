// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playlistDatabaseRecords)
const playlistDatabaseRecordsProvider = PlaylistDatabaseRecordsProvider._();

final class PlaylistDatabaseRecordsProvider extends $FunctionalProvider<AsyncValue<List<Playlist>>, List<Playlist>, Stream<List<Playlist>>>
    with $FutureModifier<List<Playlist>>, $StreamProvider<List<Playlist>> {
  const PlaylistDatabaseRecordsProvider._()
    : super(from: null, argument: null, retry: null, name: r'playlistDatabaseRecordsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$playlistDatabaseRecordsHash();

  @$internal
  @override
  $StreamProviderElement<List<Playlist>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Playlist>> create(Ref ref) {
    return playlistDatabaseRecords(ref);
  }
}

String _$playlistDatabaseRecordsHash() => r'53181be4cae454aeef5021a91f3bec4b8c8c4b3c';

@ProviderFor(playlistItemsDatabaseRecords)
const playlistItemsDatabaseRecordsProvider = PlaylistItemsDatabaseRecordsProvider._();

final class PlaylistItemsDatabaseRecordsProvider extends $FunctionalProvider<AsyncValue<List<PlaylistItem>>, List<PlaylistItem>, Stream<List<PlaylistItem>>>
    with $FutureModifier<List<PlaylistItem>>, $StreamProvider<List<PlaylistItem>> {
  const PlaylistItemsDatabaseRecordsProvider._()
    : super(from: null, argument: null, retry: null, name: r'playlistItemsDatabaseRecordsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$playlistItemsDatabaseRecordsHash();

  @$internal
  @override
  $StreamProviderElement<List<PlaylistItem>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<PlaylistItem>> create(Ref ref) {
    return playlistItemsDatabaseRecords(ref);
  }
}

String _$playlistItemsDatabaseRecordsHash() => r'3cba95e8b51d0a8d6a2807f17130d88abee14baa';

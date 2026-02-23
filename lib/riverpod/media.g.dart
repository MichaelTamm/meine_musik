// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localAudioFiles)
const localAudioFilesProvider = LocalAudioFilesProvider._();

final class LocalAudioFilesProvider extends $FunctionalProvider<AsyncValue<List<AudioFile>>, List<AudioFile>, FutureOr<List<AudioFile>>>
    with $FutureModifier<List<AudioFile>>, $FutureProvider<List<AudioFile>> {
  const LocalAudioFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAudioFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAudioFilesHash();

  @$internal
  @override
  $FutureProviderElement<List<AudioFile>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AudioFile>> create(Ref ref) {
    return localAudioFiles(ref);
  }
}

String _$localAudioFilesHash() => r'd1838b48ebd58103db770b46e0232fb849fb6d20';

@ProviderFor(localAudioFilesById)
const localAudioFilesByIdProvider = LocalAudioFilesByIdProvider._();

final class LocalAudioFilesByIdProvider
    extends $FunctionalProvider<AsyncValue<Map<int, AudioFile>>, Map<int, AudioFile>, FutureOr<Map<int, AudioFile>>>
    with $FutureModifier<Map<int, AudioFile>>, $FutureProvider<Map<int, AudioFile>> {
  const LocalAudioFilesByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAudioFilesByIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAudioFilesByIdHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, AudioFile>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, AudioFile>> create(Ref ref) {
    return localAudioFilesById(ref);
  }
}

String _$localAudioFilesByIdHash() => r'6a70f0c9295dfdbe01bf120198665caf06d26b7b';

@ProviderFor(songThumbnail)
const songThumbnailProvider = SongThumbnailFamily._();

final class SongThumbnailProvider extends $FunctionalProvider<AsyncValue<Uint8List?>, Uint8List?, FutureOr<Uint8List?>>
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  const SongThumbnailProvider._({required SongThumbnailFamily super.from, required Song super.argument})
    : super(retry: null, name: r'songThumbnailProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$songThumbnailHash();

  @override
  String toString() {
    return r'songThumbnailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as Song;
    return songThumbnail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SongThumbnailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songThumbnailHash() => r'e5420eed74558f59f6905d4914a73c33a971c2df';

final class SongThumbnailFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, Song> {
  const SongThumbnailFamily._()
    : super(retry: null, name: r'songThumbnailProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  SongThumbnailProvider call(Song song) => SongThumbnailProvider._(argument: song, from: this);

  @override
  String toString() => r'songThumbnailProvider';
}

@ProviderFor(albumCover)
const albumCoverProvider = AlbumCoverFamily._();

final class AlbumCoverProvider extends $FunctionalProvider<AsyncValue<Uint8List?>, Uint8List?, FutureOr<Uint8List?>>
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  const AlbumCoverProvider._({required AlbumCoverFamily super.from, required Album super.argument})
    : super(retry: null, name: r'albumCoverProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$albumCoverHash();

  @override
  String toString() {
    return r'albumCoverProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as Album;
    return albumCover(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumCoverProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumCoverHash() => r'08ee1bafbd50ef09724530e42e7655735ac123e4';

final class AlbumCoverFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, Album> {
  const AlbumCoverFamily._()
    : super(retry: null, name: r'albumCoverProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  AlbumCoverProvider call(Album album) => AlbumCoverProvider._(argument: album, from: this);

  @override
  String toString() => r'albumCoverProvider';
}

@ProviderFor(artistImage)
const artistImageProvider = ArtistImageFamily._();

final class ArtistImageProvider extends $FunctionalProvider<AsyncValue<Uint8List?>, Uint8List?, FutureOr<Uint8List?>>
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  const ArtistImageProvider._({required ArtistImageFamily super.from, required String super.argument})
    : super(retry: null, name: r'artistImageProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$artistImageHash();

  @override
  String toString() {
    return r'artistImageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as String;
    return artistImage(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistImageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistImageHash() => r'25ae353d3990016356fd0e7bf6508a9bf6a1ef1b';

final class ArtistImageFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, String> {
  const ArtistImageFamily._()
    : super(retry: null, name: r'artistImageProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  ArtistImageProvider call(String artistName) => ArtistImageProvider._(argument: artistName, from: this);

  @override
  String toString() => r'artistImageProvider';
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(songById)
const songByIdProvider = SongByIdFamily._();

final class SongByIdProvider extends $FunctionalProvider<AsyncValue<Song>, Song, FutureOr<Song>>
    with $FutureModifier<Song>, $FutureProvider<Song> {
  const SongByIdProvider._({required SongByIdFamily super.from, required int super.argument})
    : super(retry: null, name: r'songByIdProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$songByIdHash();

  @override
  String toString() {
    return r'songByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Song> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Song> create(Ref ref) {
    final argument = this.argument as int;
    return songById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SongByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songByIdHash() => r'5a45d582252c03e0dd38096fa1b08d5ec3a544fb';

final class SongByIdFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Song>, int> {
  const SongByIdFamily._()
    : super(retry: null, name: r'songByIdProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  SongByIdProvider call(int songId) => SongByIdProvider._(argument: songId, from: this);

  @override
  String toString() => r'songByIdProvider';
}

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

String _$localAudioFilesHash() => r'40fdc1307d35f038f56b4710f3c63f46ce08bc2e';

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

@ProviderFor(artist)
const artistProvider = ArtistFamily._();

final class ArtistProvider extends $FunctionalProvider<AsyncValue<MusicBrainzArtist?>, MusicBrainzArtist?, FutureOr<MusicBrainzArtist?>>
    with $FutureModifier<MusicBrainzArtist?>, $FutureProvider<MusicBrainzArtist?> {
  const ArtistProvider._({required ArtistFamily super.from, required KuenstlerSongs super.argument})
    : super(retry: null, name: r'artistProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$artistHash();

  @override
  String toString() {
    return r'artistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MusicBrainzArtist?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<MusicBrainzArtist?> create(Ref ref) {
    final argument = this.argument as KuenstlerSongs;
    return artist(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistHash() => r'01a313c6f76fe501f16a305c6a4c16b595060d13';

final class ArtistFamily extends $Family with $FunctionalFamilyOverride<FutureOr<MusicBrainzArtist?>, KuenstlerSongs> {
  const ArtistFamily._()
    : super(retry: null, name: r'artistProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: false);

  ArtistProvider call(KuenstlerSongs kuenstlerSongs) => ArtistProvider._(argument: kuenstlerSongs, from: this);

  @override
  String toString() => r'artistProvider';
}

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

String _$songThumbnailHash() => r'431c4ce52b64b089510ce0feff7528a93476a953';

final class SongThumbnailFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, Song> {
  const SongThumbnailFamily._()
    : super(retry: null, name: r'songThumbnailProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  SongThumbnailProvider call(Song song) => SongThumbnailProvider._(argument: song, from: this);

  @override
  String toString() => r'songThumbnailProvider';
}

@ProviderFor(albumCoverThumbnail)
const albumCoverThumbnailProvider = AlbumCoverThumbnailFamily._();

final class AlbumCoverThumbnailProvider extends $FunctionalProvider<AsyncValue<Uint8List?>, Uint8List?, FutureOr<Uint8List?>>
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  const AlbumCoverThumbnailProvider._({required AlbumCoverThumbnailFamily super.from, required Album super.argument})
    : super(retry: null, name: r'albumCoverThumbnailProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$albumCoverThumbnailHash();

  @override
  String toString() {
    return r'albumCoverThumbnailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as Album;
    return albumCoverThumbnail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumCoverThumbnailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumCoverThumbnailHash() => r'0d7d6c7ce4b60b78f2e203bfc57bf34dae565e9e';

final class AlbumCoverThumbnailFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, Album> {
  const AlbumCoverThumbnailFamily._()
    : super(retry: null, name: r'albumCoverThumbnailProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  AlbumCoverThumbnailProvider call(Album album) => AlbumCoverThumbnailProvider._(argument: album, from: this);

  @override
  String toString() => r'albumCoverThumbnailProvider';
}

@ProviderFor(artistThumbnail)
const artistThumbnailProvider = ArtistThumbnailFamily._();

final class ArtistThumbnailProvider extends $FunctionalProvider<AsyncValue<Uint8List?>, Uint8List?, FutureOr<Uint8List?>>
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  const ArtistThumbnailProvider._({required ArtistThumbnailFamily super.from, required KuenstlerSongs super.argument})
    : super(retry: null, name: r'artistThumbnailProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$artistThumbnailHash();

  @override
  String toString() {
    return r'artistThumbnailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as KuenstlerSongs;
    return artistThumbnail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistThumbnailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistThumbnailHash() => r'0ff72c1745f409e31a1fbaf736ac1095ee1a2ba3';

final class ArtistThumbnailFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, KuenstlerSongs> {
  const ArtistThumbnailFamily._()
    : super(retry: null, name: r'artistThumbnailProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  ArtistThumbnailProvider call(KuenstlerSongs kuenstlerSongs) => ArtistThumbnailProvider._(argument: kuenstlerSongs, from: this);

  @override
  String toString() => r'artistThumbnailProvider';
}

@ProviderFor(artistIcon)
const artistIconProvider = ArtistIconFamily._();

final class ArtistIconProvider extends $FunctionalProvider<AsyncValue<IconData>, IconData, FutureOr<IconData>>
    with $FutureModifier<IconData>, $FutureProvider<IconData> {
  const ArtistIconProvider._({required ArtistIconFamily super.from, required KuenstlerSongs super.argument})
    : super(retry: null, name: r'artistIconProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$artistIconHash();

  @override
  String toString() {
    return r'artistIconProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<IconData> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<IconData> create(Ref ref) {
    final argument = this.argument as KuenstlerSongs;
    return artistIcon(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistIconProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistIconHash() => r'17a1c9035b32561e8435f230f26a74a472071f3a';

final class ArtistIconFamily extends $Family with $FunctionalFamilyOverride<FutureOr<IconData>, KuenstlerSongs> {
  const ArtistIconFamily._()
    : super(retry: null, name: r'artistIconProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: false);

  ArtistIconProvider call(KuenstlerSongs kuenstlerSongs) => ArtistIconProvider._(argument: kuenstlerSongs, from: this);

  @override
  String toString() => r'artistIconProvider';
}

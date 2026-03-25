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

String _$localAudioFilesHash() => r'7f4a918b46de5d516194374fa8bd13427efe4e23';

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

final class ArtistProvider extends $FunctionalProvider<AsyncValue<Artist?>, Artist?, FutureOr<Artist?>>
    with $FutureModifier<Artist?>, $FutureProvider<Artist?> {
  const ArtistProvider._({required ArtistFamily super.from, required String super.argument})
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
  $FutureProviderElement<Artist?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Artist?> create(Ref ref) {
    final argument = this.argument as String;
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

String _$artistHash() => r'f53fcd756abcea20e2a51878bf64010f8a779e8d';

final class ArtistFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Artist?>, String> {
  const ArtistFamily._()
    : super(retry: null, name: r'artistProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: false);

  ArtistProvider call(String artistName) => ArtistProvider._(argument: artistName, from: this);

  @override
  String toString() => r'artistProvider';
}

@ProviderFor(songThumbnail)
const songThumbnailProvider = SongThumbnailFamily._();

final class SongThumbnailProvider extends $FunctionalProvider<AsyncValue<Uint8List?>, Uint8List?, FutureOr<Uint8List?>>
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  const SongThumbnailProvider._({required SongThumbnailFamily super.from, required Song super.argument})
    : super(retry: null, name: r'songThumbnailProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

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

String _$songThumbnailHash() => r'f814227fb1208b43d87fa0693210ba6872babaa2';

final class SongThumbnailFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, Song> {
  const SongThumbnailFamily._()
    : super(retry: null, name: r'songThumbnailProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: false);

  SongThumbnailProvider call(Song song) => SongThumbnailProvider._(argument: song, from: this);

  @override
  String toString() => r'songThumbnailProvider';
}

@ProviderFor(albumCoverThumbnail)
const albumCoverThumbnailProvider = AlbumCoverThumbnailFamily._();

final class AlbumCoverThumbnailProvider extends $FunctionalProvider<AsyncValue<Uint8List?>, Uint8List?, FutureOr<Uint8List?>>
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  const AlbumCoverThumbnailProvider._({required AlbumCoverThumbnailFamily super.from, required Album super.argument})
    : super(retry: null, name: r'albumCoverThumbnailProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

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

String _$albumCoverThumbnailHash() => r'246880b8ce75e001b41ed8ef890118f1f742b0ae';

final class AlbumCoverThumbnailFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, Album> {
  const AlbumCoverThumbnailFamily._()
    : super(retry: null, name: r'albumCoverThumbnailProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: false);

  AlbumCoverThumbnailProvider call(Album album) => AlbumCoverThumbnailProvider._(argument: album, from: this);

  @override
  String toString() => r'albumCoverThumbnailProvider';
}

@ProviderFor(artistThumbnail)
const artistThumbnailProvider = ArtistThumbnailFamily._();

final class ArtistThumbnailProvider extends $FunctionalProvider<AsyncValue<Uint8List?>, Uint8List?, FutureOr<Uint8List?>>
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  const ArtistThumbnailProvider._({required ArtistThumbnailFamily super.from, required String super.argument})
    : super(retry: null, name: r'artistThumbnailProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

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
    final argument = this.argument as String;
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

String _$artistThumbnailHash() => r'c0801710857bdf2a9dca6c1ae66c416f17fca9ef';

final class ArtistThumbnailFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Uint8List?>, String> {
  const ArtistThumbnailFamily._()
    : super(retry: null, name: r'artistThumbnailProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: false);

  ArtistThumbnailProvider call(String artistName) => ArtistThumbnailProvider._(argument: artistName, from: this);

  @override
  String toString() => r'artistThumbnailProvider';
}

@ProviderFor(artistIcon)
const artistIconProvider = ArtistIconFamily._();

final class ArtistIconProvider extends $FunctionalProvider<AsyncValue<IconData>, IconData, FutureOr<IconData>>
    with $FutureModifier<IconData>, $FutureProvider<IconData> {
  const ArtistIconProvider._({required ArtistIconFamily super.from, required String super.argument})
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
    final argument = this.argument as String;
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

String _$artistIconHash() => r'e6cb2254312f25fa833fbf0dc950cb22edecf67f';

final class ArtistIconFamily extends $Family with $FunctionalFamilyOverride<FutureOr<IconData>, String> {
  const ArtistIconFamily._()
    : super(retry: null, name: r'artistIconProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: false);

  ArtistIconProvider call(String artistName) => ArtistIconProvider._(argument: artistName, from: this);

  @override
  String toString() => r'artistIconProvider';
}

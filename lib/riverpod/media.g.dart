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
        isAutoDispose: true,
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

String _$localAudioFilesHash() => r'd3ed63f88973cd8554b60ec00a3d823898d21180';

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
        isAutoDispose: true,
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

String _$localAudioFilesByIdHash() => r'41030b5376f4e8efd4a0616e24caf87ae6e7ee06';

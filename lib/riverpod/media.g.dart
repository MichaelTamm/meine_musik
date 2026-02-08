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

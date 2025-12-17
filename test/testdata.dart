import 'package:meine_musik/services/AudioApi.dart';

import 'package:flutter_test/flutter_test.dart';

final _sequences = <String, int>{};

var _isTestRunning = false;

void initTestdata() {
  setUp(() {
    _isTestRunning = true;
    _sequences.clear();
  });

  tearDown(() {
    _isTestRunning = false;
  });
}

int _nextIdFor(Type type) {
  if (!_isTestRunning) {
    throw StateError('Not inside a setUp or test function -- testdata must be created inside test functions');
  }
  final key = type.toString();
  final nextId = _sequences[key] ?? 1;
  _sequences[key] = nextId + 1;
  return nextId;
}

AudioFile anAudioFile({
  int? id,
  String? path,
}) {
  id ??= _nextIdFor(AudioFile);
  return AudioFile(
    id: id,
    path: path ?? '/storage/emulated/0/AudioFile_$id.mp3',
    sizeInBytes: 1234567,
    title: 'Test Title $id',
    artist: 'Test Artist',
    album: 'Test Album',
    trackNumber: 0,
    durationInMilliseconds: 234567,
  );
}

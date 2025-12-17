import '../services/AudioApi.dart';

export '../../services/AudioApi.dart' show AudioFile;

extension AudioFileExtension on AudioFile {
  String get fileName {
    final i = path.lastIndexOf('/');
    return i < 0 ? path : path.substring(i + 1);
  }
}


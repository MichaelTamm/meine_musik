import '../services/MeineMusikPigeonApi.dart';

export '../services/MeineMusikPigeonApi.dart' show AudioFile;

extension AudioFileExtension on AudioFile {
  String get dir {
    final i = path.lastIndexOf('/');
    return i <= 0 ? '' : path.substring(0, i);
  }

  String get fileName {
    final i = path.lastIndexOf('/');
    return i < 0 ? path : path.substring(i + 1);
  }
}

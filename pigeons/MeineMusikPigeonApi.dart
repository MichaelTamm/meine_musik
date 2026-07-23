import 'package:pigeon/pigeon.dart';

class AudioFile {
  int id;
  String path;
  int sizeInBytes;
  String title;
  String artist;
  String album;
  int trackNumber;
  int durationInMilliseconds;
}

@HostApi()
abstract class MeineMusikNativeMethods {
  @async
  String getAppVersion();

  @async
  int getApiLevel();

  @async
  List<AudioFile> findAll();

  @async
  Uint8List? getAlbumCover(String path);
}

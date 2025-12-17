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
abstract class AudioService {
  @async
  List<AudioFile> findAll();
}

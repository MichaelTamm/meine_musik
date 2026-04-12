import 'package:meine_musik/drift/database.dart';
import 'package:meine_musik/model/Playlist.dart';
import 'package:meine_musik/model/Song.dart';
import 'package:meine_musik/services/AudioApi.dart';
import 'package:meine_musik/services/MusicBrainz.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioService extends Mock implements AudioService {}

class DummyMusicBrainz implements MusicBrainz {
  @override
  Future<MusicBrainzArtist?> searchArtist(String _, Iterable<Song> _) async {
    return null;
  }

  @override
  Future<MusicBrainzRelease?> searchRelease(Album _) async {
    return null;
  }

  @override
  void clearCache() {}
}

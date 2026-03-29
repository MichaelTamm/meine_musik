import 'package:meine_musik/drift/database.dart';
import 'package:meine_musik/model/Playlist.dart';
import 'package:meine_musik/services/AudioApi.dart';
import 'package:meine_musik/services/MusicBrainz.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioService extends Mock implements AudioService {}

class DummyMusicBrainz implements MusicBrainz {
  @override
  Future<MusicBrainzArtist?> searchArtistByName(String name) async {
    return null;
  }

  @override
  Future<MusicBrainzRelease?> searchReleaseByAlbum(Album album) async {
    return null;
  }
}

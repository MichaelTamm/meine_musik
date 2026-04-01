import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/model/Playlist.dart';
import 'package:meine_musik/services/MusicBrainz.dart';

import '../RecordPlaybackHttpClient.dart';
import '../testdata.dart';

void main() {
  test('$MusicBrainz.', () async {
    musicBrainz = MusicBrainz(RecordPlaybackHttpClient());
    final song1 = anAudioFile(id: 1, artist: 'No Angels', title: 'Daylight In Your Eyes', album: 'Elle´ments', trackNumber: 1);
    final song2 = anAudioFile(id: 2, artist: 'No Angels', title: 'When The Angels Sing', album: 'Elle´ments', trackNumber: 2);
    final song3 = anAudioFile(id: 2, artist: 'No Angels', title: 'Promises Can Wait', album: 'Elle´ments', trackNumber: 2);
    final album = await Album.fromNameAndSongs('Elle´ments', [song1, song2, song3]);
    final release = await musicBrainz.searchReleaseByAlbum(album);
    expect(release?.mbid, equals('51ac4e7b-477e-4887-84fc-eee1f9fc1625'));
  });
}
import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/services/MeineMusikAudioHandler.dart';
import 'package:mocktail/mocktail.dart';

import '../testdata.dart';
import '../widget_test_utils.dart';

void main() {
  late MeineMusikAudioHandler handler;

  setUp(() {
    handler = MeineMusikAudioHandler();
    when(() => nativeMethods.findAll()).thenAnswer(
      (_) async => [
        anAudioFile(id: 1, title: 'Song A', artist: 'Artist X', album: 'Album 1', path: '/storage/emulated/0/Music/Album 1/Song A.mp3'),
        anAudioFile(id: 2, title: 'Song B', artist: 'Artist X', album: 'Album 1', path: '/storage/emulated/0/Music/Album 1/Song B.mp3'),
        anAudioFile(id: 3, title: 'Song C', artist: 'Artist Y', album: 'Album 2', path: '/storage/emulated/0/Music/Album 2/Song C.mp3'),
      ],
    );
  });

  testWidgets("$MeineMusikAudioHandler.getChildren('root')", (tester) async {
    await tester.startApp();
    final children = await handler.getChildren(AudioService.browsableRootId);
    expect(children, hasLength(3));
    expect(children[0].id, 'Playlists');
    expect(children[0].title, 'Playlists');
    expect(children[0].playable, false);
    expect(children[1].id, 'Alben');
    expect(children[1].title, 'Alben');
    expect(children[1].playable, false);
    expect(children[2].id, 'Künstler');
    expect(children[2].title, 'Künstler');
    expect(children[2].playable, false);
  });

  testWidgets("$MeineMusikAudioHandler.getChildren('Playlists')", (tester) async {
    await db.createPlaylist('foo');
    await tester.startApp();
    final children = await handler.getChildren('Playlists');
    expect(children, hasLength(3));
    expect(children[0].title, 'Alle Lieder');
    expect(children[1].title, 'Favoriten');
    expect(children[2].title, 'foo');
    for (final item in children) {
      expect(item.playable, true);
      expect(item.extras?['browsable'], true);
    }
  });
/*
  test('"Alben" returns all albums', () async {
    final children = await handler.getChildren('Alben');

    expect(children.length, greaterThanOrEqualTo(2));
    final titles = children.map((it) => it.title).toSet();
    expect(titles, contains('Album 1'));
    expect(titles, contains('Album 2'));
    for (final item in children) {
      expect(item.playable, true);
      expect(item.extras?['browsable'], true);
    }
  });

  test('"Künstler" returns all artists', () async {
    final children = await handler.getChildren('Künstler');

    expect(children.length, greaterThanOrEqualTo(2));
    final titles = children.map((it) => it.title).toSet();
    expect(titles, contains('Artist X'));
    expect(titles, contains('Artist Y'));
    for (final item in children) {
      expect(item.playable, true);
      expect(item.extras?['browsable'], true);
    }
  });

  test('"Playlist: Alle Lieder" returns songs of Alle Lieder playlist', () async {
    final children = await handler.getChildren('Playlist: Alle Lieder');

    expect(children, hasLength(3));
    expect(children[0].title, 'Song A');
    expect(children[1].title, 'Song B');
    expect(children[2].title, 'Song C');
    for (final item in children) {
      expect(item.playable, true);
      expect(item.id, startsWith('Song: '));
    }
  });

  test('"Playlist: Favoriten" returns empty list when no favorites exist', () async {
    final children = await handler.getChildren('Playlist: Favoriten');

    expect(children, isEmpty);
  });

  test('album ID returns songs of that album', () async {
    final alben = await handler.getChildren('Alben');
    final album1 = alben.firstWhere((it) => it.title == 'Album 1');

    final children = await handler.getChildren(album1.id);

    expect(children, hasLength(2));
    expect(children[0].title, 'Song A');
    expect(children[1].title, 'Song B');
    for (final item in children) {
      expect(item.playable, true);
      expect(item.id, startsWith('Song: '));
      expect(item.artist, 'Artist X');
      expect(item.album, 'Album 1');
    }
  });

  test('artist ID returns songs of that artist', () async {
    final kuenstler = await handler.getChildren('Künstler');
    final artistY = kuenstler.firstWhere((it) => it.title == 'Artist Y');

    final children = await handler.getChildren(artistY.id);

    expect(children, hasLength(1));
    expect(children[0].title, 'Song C');
    expect(children[0].artist, 'Artist Y');
  });

  test('unknown parentMediaId returns empty list', () async {
    final children = await handler.getChildren('unknown_id');

    expect(children, isEmpty);
  });

  test('non-existent playlist returns empty list', () async {
    final children = await handler.getChildren('Playlist: Does Not Exist');

    expect(children, isEmpty);
  });

  test('non-existent album returns empty list', () async {
    final children = await handler.getChildren('Album: Does Not Exist (Unknown)');

    expect(children, isEmpty);
  });

  test('non-existent artist returns empty list', () async {
    final children = await handler.getChildren('Künstler: Unknown Artist');

    expect(children, isEmpty);
  });

  test('song MediaItems have correct duration', () async {
    final children = await handler.getChildren('Playlist: Alle Lieder');

    for (final item in children) {
      expect(item.duration, const Duration(milliseconds: 234567));
    }
  });

  test('song with empty title uses filename', () async {
    when(() => nativeMethods.findAll()).thenAnswer(
      (_) async => [
        anAudioFile(id: 10, title: '', artist: 'Artist', album: 'Album', path: '/storage/emulated/0/Music/my_song.mp3'),
      ],
    );
    riverpodContainer.invalidate(alleLiederProvider);

    final children = await handler.getChildren('Playlist: Alle Lieder');

    expect(children, hasLength(1));
    expect(children[0].title, 'my_song.mp3');
  });
*/
}

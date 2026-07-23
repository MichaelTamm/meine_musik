import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/services/MeineMusikAudioHandler.dart';
import 'package:mocktail/mocktail.dart';

import '../testdata.dart';
import '../widget_test_utils.dart';

void main() {
  late MeineMusikAudioHandler sut;

  setUp(() {
    sut = MeineMusikAudioHandler();
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
    final children = await sut.getChildren(AudioService.browsableRootId);
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
    final children = await sut.getChildren('Playlists');
    expect(children, hasLength(3));
    expect(children[0].id, 'Playlist: Alle Lieder');
    expect(children[0].title, 'Alle Lieder');
    expect(children[0].playable, true);
    expect(children[0].extras!['browsable'], true);
    expect(children[1].id, 'Playlist: Favoriten');
    expect(children[1].title, 'Favoriten');
    expect(children[1].playable, false);
    expect(children[1].extras!['browsable'], true);
    expect(children[2].id, 'Playlist: foo');
    expect(children[2].title, 'foo');
    expect(children[2].playable, false);
    expect(children[2].extras!['browsable'], true);
  });

  testWidgets("$MeineMusikAudioHandler.getChildren('Alben')", (tester) async {
    await tester.startApp();
    final children = await sut.getChildren('Alben');
    expect(children, hasLength(2));
    expect(children[0].title, 'Album 1');
    expect(children[0].playable, true);
    expect(children[0].extras!['browsable'], true);
    expect(children[1].title, 'Album 2');
    expect(children[1].playable, true);
    expect(children[1].extras!['browsable'], true);
  });

  testWidgets("$MeineMusikAudioHandler.getChildren('Künstler')", (tester) async {
    await tester.startApp();
    final children = await sut.getChildren('Künstler');
    expect(children, hasLength(2));
    expect(children[0].id, 'Künstler: Artist X');
    expect(children[0].title, 'Artist X');
    expect(children[0].playable, true);
    expect(children[0].extras!['browsable'], true);
    expect(children[1].id, 'Künstler: Artist Y');
    expect(children[1].title, 'Artist Y');
    expect(children[1].playable, true);
    expect(children[1].extras!['browsable'], true);
  });

  testWidgets("$MeineMusikAudioHandler.getChildren('Playlist: Alle Lieder')", (tester) async {
    await tester.startApp();
    final children = await sut.getChildren('Playlist: Alle Lieder');
    expect(children, hasLength(3));
    expect(children[0].id, 'Song: 1');
    expect(children[0].title, 'Song A');
    expect(children[0].artist, 'Artist X');
    expect(children[0].album, 'Album 1');
    expect(children[0].playable, true);
    expect(children[1].id, 'Song: 2');
    expect(children[1].title, 'Song B');
    expect(children[1].artist, 'Artist X');
    expect(children[1].album, 'Album 1');
    expect(children[1].playable, true);
    expect(children[2].id, 'Song: 3');
    expect(children[2].title, 'Song C');
    expect(children[2].artist, 'Artist Y');
    expect(children[2].album, 'Album 2');
    expect(children[2].playable, true);
  });

  testWidgets("$MeineMusikAudioHandler.getChildren('Playlist: Favoriten') returns empty list when no favorites exist", (tester) async {
    await tester.startApp();
    final children = await sut.getChildren('Playlist: Favoriten');
    expect(children, isEmpty);
  });

  testWidgets('browse Album 1', (tester) async {
    await tester.startApp();
    final alben = await sut.getChildren('Alben');
    final album1 = alben.firstWhere((it) => it.title == 'Album 1');
    final children = await sut.getChildren(album1.id);
    expect(children, hasLength(2));
    expect(children[0].title, 'Song A');
    expect(children[1].title, 'Song B');
    for (final item in children) {
      expect(item.artist, 'Artist X');
      expect(item.album, 'Album 1');
      expect(item.playable, true);
    }
  });

  testWidgets('browse Artist Y', (tester) async {
    await tester.startApp();
    final kuenstler = await sut.getChildren('Künstler');
    final artistY = kuenstler.firstWhere((it) => it.title == 'Artist Y');
    final children = await sut.getChildren(artistY.id);
    expect(children, hasLength(1));
    expect(children[0].title, 'Song C');
    expect(children[0].artist, 'Artist Y');
    expect(children[0].album, 'Album 2');
    expect(children[0].playable, true);
  });

  testWidgets('unknown parentMediaId returns empty list', (tester) async {
    await tester.startApp();
    final children = await sut.getChildren('unknown_id');
    expect(children, isEmpty);
  });

  testWidgets('non-existent playlist returns empty list', (tester) async {
    await tester.startApp();
    final children = await sut.getChildren('Playlist: Does Not Exist');
    expect(children, isEmpty);
  });

  testWidgets('non-existent album returns empty list', (tester) async {
    await tester.startApp();
    final children = await sut.getChildren('Album: Does Not Exist (Unknown)');
    expect(children, isEmpty);
  });

  testWidgets('non-existent artist returns empty list', (tester) async {
    await tester.startApp();
    final children = await sut.getChildren('Künstler: Unknown Artist');
    expect(children, isEmpty);
  });

  testWidgets('song with empty title uses filename', (tester) async {
    when(() => nativeMethods.findAll()).thenAnswer(
          (_) async => [
        anAudioFile(id: 10, title: '', artist: 'Artist', album: 'Album', path: '/storage/emulated/0/Music/my_song.mp3'),
      ],
    );
    await tester.startApp();
    final children = await sut.getChildren('Playlist: Alle Lieder');
    expect(children, hasLength(1));
    expect(children[0].title, 'my_song.mp3');
  });
}

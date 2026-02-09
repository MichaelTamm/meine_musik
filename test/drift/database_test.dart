import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/drift/database.dart';

void main() {
  test('create playlist, add song, delete playlist', () async {
    final playlistId = await db.createPlaylist('Test Playlist');
    await db.playlistItems.insertOne(PlaylistItemsCompanion(playlistId: Value(playlistId), songId: Value(123)));

    expect(await db.playlists.select().get(), equals([Playlist(id: playlistId, name: 'Test Playlist')]));
    expect(await db.playlistItems.select().get(), equals([PlaylistItem(playlistId: playlistId, songId: 123)]));

    await db.deletePlaylist(playlistId);

    expect(await db.playlists.select().get(), equals([]));
    expect(await db.playlistItems.select().get(), equals([]));
  });
}

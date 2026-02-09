import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../drift/database.dart';

part 'database_providers.g.dart';

@Riverpod(keepAlive: true)
Stream<List<Playlist>> playlistsDatabaseRecords(Ref _) {
  return db.playlists.select().watch();
}

@Riverpod(keepAlive: true)
Stream<List<PlaylistItem>> playlistItemsDatabaseRecords(Ref _, int playlistId) {
  return (db.playlistItems.select()..where((t) => t.playlistId.equals(playlistId))).watch();
}

@Riverpod(keepAlive: true)
Stream<List<Favorite>> favoritesDatabaseRecords(Ref _) {
  return db.favorites.select().watch();
}

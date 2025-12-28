import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../drift/database.dart';

part 'database_providers.g.dart';

@riverpod
Stream<List<Playlist>> playlistDatabaseRecords(Ref _) {
  return db.playlists.select().watch();
}

@riverpod
Stream<List<PlaylistItem>> playlistItemsDatabaseRecords(Ref _) {
  return db.playlistItems.select().watch();
}

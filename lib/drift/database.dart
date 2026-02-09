import 'package:drift/drift.dart';

export '../env.dart' show db;

part 'database.drift.dart';

class Favorites extends Table {
  late final songId = integer().customConstraint('UNIQUE NOT NULL')();

  @override
  Set<Column<Object>> get primaryKey => {songId};
}

class Playlists extends Table {
  late final id = integer().autoIncrement()();
  late final name = text()();
}

class PlaylistItems extends Table {
  late final playlistId = integer().references(Playlists, #id, onDelete: KeyAction.restrict)();
  late final songId = integer()();

  @override
  Set<Column<Object>> get primaryKey => {playlistId, songId};
}

@DriftDatabase(tables: [Favorites, Playlists, PlaylistItems])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 1;

  Future<int> createPlaylist(String name) {
    return into(playlists).insert(PlaylistsCompanion.insert(name: name));
  }
}

import 'package:drift/drift.dart';

export '../env.dart' show db;

part 'database.drift.dart';

class Playlists extends Table {
  late final id = integer().autoIncrement()();
  late final name = text()();
}

class PlaylistItems extends Table {
  late final playlistId = integer().references(Playlists, #id)();
  late final audioFileId = integer()();

  @override
  Set<Column<Object>> get primaryKey => {playlistId, audioFileId};
}

@DriftDatabase(tables: [Playlists, PlaylistItems])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 1;

  Future<int> createPlaylist(String name) {
    return into(playlists).insert(PlaylistsCompanion.insert(name: name));
  }
}
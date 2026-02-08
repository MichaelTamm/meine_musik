import 'package:drift/drift.dart';

import 'database.steps.dart';

export '../env.dart' show db;

part 'database.drift.dart';

class Playlists extends Table {
  late final id = integer().autoIncrement()();
  late final name = text()();
}

class PlaylistItems extends Table {
  late final playlistId = integer().references(Playlists, #id)();
  late final songId = integer()();

  @override
  Set<Column<Object>> get primaryKey => {playlistId, songId};
}

class Favorites extends Table {
  late final songId = integer()();

  @override
  Set<Column<Object>> get primaryKey => {songId};
}

@DriftDatabase(tables: [Playlists, PlaylistItems, Favorites])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.renameColumn(schema.playlistItems, 'audio_file_id', schema.playlistItems.songId);
          await m.createTable(schema.favorites);
        },
      ),
    );
  }

  Future<int> createPlaylist(String name) {
    return into(playlists).insert(PlaylistsCompanion.insert(name: name));
  }
}

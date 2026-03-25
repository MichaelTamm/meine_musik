import 'package:drift/drift.dart';

export '../env.dart' show db;

part 'database.drift.dart';

class Favorites extends Table {
  late final songId = integer()();

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

class Artists extends Table {
  /// MusicBrainz Identifier, see https://musicbrainz.org/doc/MusicBrainz_Identifier
  late final mbid = text()();
  late final name = text()();
  late final type = text()();

  @override
  Set<Column> get primaryKey => {mbid};
}

class Releases extends Table {
  /// MusicBrainz Identifier, see https://musicbrainz.org/doc/MusicBrainz_Identifier
  late final mbid = text()();

  /// A string like '|13|14|15|' -- can be queried using Like '%|13|%'.
  late final songIds = text()();

  @override
  Set<Column> get primaryKey => {mbid};
}

@DriftDatabase(tables: [Favorites, Playlists, PlaylistItems, Artists, Releases])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 1;

  Future<int> createPlaylist(String name) {
    return into(playlists).insert(PlaylistsCompanion.insert(name: name));
  }

  Future<void> deletePlaylist(int playlistId) async {
    await transaction(() async {
      await playlistItems.deleteWhere((t) => t.playlistId.equals(playlistId));
      await playlists.deleteWhere((t) => t.id.equals(playlistId));
    });
  }

  Future<Artist?> findArtistByName(String name) async {
    return (await (select(artists)..where((t) => t.name.equals(name))).get()).firstOrNull;
  }

  Future<Release?> findReleaseBySongId(int songId) async {
    return (await (select(releases)..where((t) => t.songIds.like('%|$songId|%'))).get()).firstOrNull;
  }
}

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
  late final playlistId = integer().references(Playlists, #id, onDelete: KeyAction.cascade)();
  late final songId = integer()();

  @override
  Set<Column<Object>> get primaryKey => {playlistId, songId};
}

class ArtistSearchResults extends Table {
  late final name = text()();
  late final mbid = text().nullable()();
  // TODO: save timestamp (and retry search if mbid == null and timestamp is older than 7 days)

  @override
  Set<Column> get primaryKey => {name};
}

class MusicBrainzArtists extends Table {
  /// MusicBrainz Identifier, see https://musicbrainz.org/doc/MusicBrainz_Identifier
  late final mbid = text()();
  late final name = text()();
  late final type = text()();

  @override
  Set<Column> get primaryKey => {mbid};
}

class MusicBrainzReleases extends Table {
  /// MusicBrainz Identifier, see https://musicbrainz.org/doc/MusicBrainz_Identifier
  late final mbid = text()();

  /// MusicBrainz Identifier, see https://musicbrainz.org/doc/MusicBrainz_Identifier
  late final releaseGroupMbid = text()();

  /// A string like '|13|14|15|' -- can be queried via: LIKE '%|13|%'.
  late final songIds = text()();

  @override
  Set<Column> get primaryKey => {mbid};
}

@DriftDatabase(tables: [Favorites, Playlists, PlaylistItems, ArtistSearchResults, MusicBrainzArtists, MusicBrainzReleases])
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

  Future<MusicBrainzArtist?> findArtistByName(String name) async {
    MusicBrainzArtist? result;
    final searchResult = (await (select(artistSearchResults)..where((t) => t.name.equals(name))).get()).firstOrNull;
    if (searchResult != null) {
      final mbid = searchResult.mbid;
      if (mbid != null) {
        result = (await (select(musicBrainzArtists)..where((t) => t.mbid.equals(mbid))).get()).firstOrNull;
      }
    }
    return result;
  }

  Future<MusicBrainzRelease?> findReleaseBySongId(int songId) async {
    return (await (select(musicBrainzReleases)..where((t) => t.songIds.like('%|$songId|%'))).get()).firstOrNull;
  }
}

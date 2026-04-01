// dart format width=80
// ignore_for_file: type=lint
part of 'database.dart';

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [songId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {songId};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}song_id'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int songId;
  const Favorite({required this.songId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['song_id'] = Variable<int>(songId);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(songId: Value(songId));
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(songId: serializer.fromJson<int>(json['songId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'songId': serializer.toJson<int>(songId)};
  }

  Favorite copyWith({int? songId}) => Favorite(songId: songId ?? this.songId);
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      songId: data.songId.present ? data.songId.value : this.songId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('songId: $songId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => songId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite && other.songId == this.songId);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> songId;
  const FavoritesCompanion({this.songId = const Value.absent()});
  FavoritesCompanion.insert({this.songId = const Value.absent()});
  static Insertable<Favorite> custom({Expression<int>? songId}) {
    return RawValuesInsertable({if (songId != null) 'song_id': songId});
  }

  FavoritesCompanion copyWith({Value<int>? songId}) {
    return FavoritesCompanion(songId: songId ?? this.songId);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('songId: $songId')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Playlist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final int id;
  final String name;
  const Playlist({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(id: Value(id), name: Value(name));
  }

  factory Playlist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Playlist copyWith({int? id, String? name}) =>
      Playlist(id: id ?? this.id, name: name ?? this.name);
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist && other.id == this.id && other.name == this.name);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<int> id;
  final Value<String> name;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Playlist> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PlaylistsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return PlaylistsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $PlaylistItemsTable extends PlaylistItems
    with TableInfo<$PlaylistItemsTable, PlaylistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES playlists (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [playlistId, songId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playlistId, songId};
  @override
  PlaylistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistItem(
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playlist_id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}song_id'],
      )!,
    );
  }

  @override
  $PlaylistItemsTable createAlias(String alias) {
    return $PlaylistItemsTable(attachedDatabase, alias);
  }
}

class PlaylistItem extends DataClass implements Insertable<PlaylistItem> {
  final int playlistId;
  final int songId;
  const PlaylistItem({required this.playlistId, required this.songId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['playlist_id'] = Variable<int>(playlistId);
    map['song_id'] = Variable<int>(songId);
    return map;
  }

  PlaylistItemsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistItemsCompanion(
      playlistId: Value(playlistId),
      songId: Value(songId),
    );
  }

  factory PlaylistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistItem(
      playlistId: serializer.fromJson<int>(json['playlistId']),
      songId: serializer.fromJson<int>(json['songId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playlistId': serializer.toJson<int>(playlistId),
      'songId': serializer.toJson<int>(songId),
    };
  }

  PlaylistItem copyWith({int? playlistId, int? songId}) => PlaylistItem(
    playlistId: playlistId ?? this.playlistId,
    songId: songId ?? this.songId,
  );
  PlaylistItem copyWithCompanion(PlaylistItemsCompanion data) {
    return PlaylistItem(
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      songId: data.songId.present ? data.songId.value : this.songId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistItem(')
          ..write('playlistId: $playlistId, ')
          ..write('songId: $songId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(playlistId, songId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistItem &&
          other.playlistId == this.playlistId &&
          other.songId == this.songId);
}

class PlaylistItemsCompanion extends UpdateCompanion<PlaylistItem> {
  final Value<int> playlistId;
  final Value<int> songId;
  final Value<int> rowid;
  const PlaylistItemsCompanion({
    this.playlistId = const Value.absent(),
    this.songId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistItemsCompanion.insert({
    required int playlistId,
    required int songId,
    this.rowid = const Value.absent(),
  }) : playlistId = Value(playlistId),
       songId = Value(songId);
  static Insertable<PlaylistItem> custom({
    Expression<int>? playlistId,
    Expression<int>? songId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (playlistId != null) 'playlist_id': playlistId,
      if (songId != null) 'song_id': songId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistItemsCompanion copyWith({
    Value<int>? playlistId,
    Value<int>? songId,
    Value<int>? rowid,
  }) {
    return PlaylistItemsCompanion(
      playlistId: playlistId ?? this.playlistId,
      songId: songId ?? this.songId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistItemsCompanion(')
          ..write('playlistId: $playlistId, ')
          ..write('songId: $songId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtistSearchResultsTable extends ArtistSearchResults
    with TableInfo<$ArtistSearchResultsTable, ArtistSearchResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistSearchResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mbidMeta = const VerificationMeta('mbid');
  @override
  late final GeneratedColumn<String> mbid = GeneratedColumn<String>(
    'mbid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [name, mbid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artist_search_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArtistSearchResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mbid')) {
      context.handle(
        _mbidMeta,
        mbid.isAcceptableOrUnknown(data['mbid']!, _mbidMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  ArtistSearchResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArtistSearchResult(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mbid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mbid'],
      ),
    );
  }

  @override
  $ArtistSearchResultsTable createAlias(String alias) {
    return $ArtistSearchResultsTable(attachedDatabase, alias);
  }
}

class ArtistSearchResult extends DataClass
    implements Insertable<ArtistSearchResult> {
  final String name;
  final String? mbid;
  const ArtistSearchResult({required this.name, this.mbid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || mbid != null) {
      map['mbid'] = Variable<String>(mbid);
    }
    return map;
  }

  ArtistSearchResultsCompanion toCompanion(bool nullToAbsent) {
    return ArtistSearchResultsCompanion(
      name: Value(name),
      mbid: mbid == null && nullToAbsent ? const Value.absent() : Value(mbid),
    );
  }

  factory ArtistSearchResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArtistSearchResult(
      name: serializer.fromJson<String>(json['name']),
      mbid: serializer.fromJson<String?>(json['mbid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'mbid': serializer.toJson<String?>(mbid),
    };
  }

  ArtistSearchResult copyWith({
    String? name,
    Value<String?> mbid = const Value.absent(),
  }) => ArtistSearchResult(
    name: name ?? this.name,
    mbid: mbid.present ? mbid.value : this.mbid,
  );
  ArtistSearchResult copyWithCompanion(ArtistSearchResultsCompanion data) {
    return ArtistSearchResult(
      name: data.name.present ? data.name.value : this.name,
      mbid: data.mbid.present ? data.mbid.value : this.mbid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArtistSearchResult(')
          ..write('name: $name, ')
          ..write('mbid: $mbid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, mbid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArtistSearchResult &&
          other.name == this.name &&
          other.mbid == this.mbid);
}

class ArtistSearchResultsCompanion extends UpdateCompanion<ArtistSearchResult> {
  final Value<String> name;
  final Value<String?> mbid;
  final Value<int> rowid;
  const ArtistSearchResultsCompanion({
    this.name = const Value.absent(),
    this.mbid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistSearchResultsCompanion.insert({
    required String name,
    this.mbid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ArtistSearchResult> custom({
    Expression<String>? name,
    Expression<String>? mbid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (mbid != null) 'mbid': mbid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistSearchResultsCompanion copyWith({
    Value<String>? name,
    Value<String?>? mbid,
    Value<int>? rowid,
  }) {
    return ArtistSearchResultsCompanion(
      name: name ?? this.name,
      mbid: mbid ?? this.mbid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mbid.present) {
      map['mbid'] = Variable<String>(mbid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistSearchResultsCompanion(')
          ..write('name: $name, ')
          ..write('mbid: $mbid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MusicBrainzArtistsTable extends MusicBrainzArtists
    with TableInfo<$MusicBrainzArtistsTable, MusicBrainzArtist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MusicBrainzArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mbidMeta = const VerificationMeta('mbid');
  @override
  late final GeneratedColumn<String> mbid = GeneratedColumn<String>(
    'mbid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [mbid, name, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'music_brainz_artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<MusicBrainzArtist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mbid')) {
      context.handle(
        _mbidMeta,
        mbid.isAcceptableOrUnknown(data['mbid']!, _mbidMeta),
      );
    } else if (isInserting) {
      context.missing(_mbidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mbid};
  @override
  MusicBrainzArtist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MusicBrainzArtist(
      mbid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mbid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $MusicBrainzArtistsTable createAlias(String alias) {
    return $MusicBrainzArtistsTable(attachedDatabase, alias);
  }
}

class MusicBrainzArtist extends DataClass
    implements Insertable<MusicBrainzArtist> {
  /// MusicBrainz Identifier, see https://musicbrainz.org/doc/MusicBrainz_Identifier
  final String mbid;
  final String name;
  final String type;
  const MusicBrainzArtist({
    required this.mbid,
    required this.name,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mbid'] = Variable<String>(mbid);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    return map;
  }

  MusicBrainzArtistsCompanion toCompanion(bool nullToAbsent) {
    return MusicBrainzArtistsCompanion(
      mbid: Value(mbid),
      name: Value(name),
      type: Value(type),
    );
  }

  factory MusicBrainzArtist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MusicBrainzArtist(
      mbid: serializer.fromJson<String>(json['mbid']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mbid': serializer.toJson<String>(mbid),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
    };
  }

  MusicBrainzArtist copyWith({String? mbid, String? name, String? type}) =>
      MusicBrainzArtist(
        mbid: mbid ?? this.mbid,
        name: name ?? this.name,
        type: type ?? this.type,
      );
  MusicBrainzArtist copyWithCompanion(MusicBrainzArtistsCompanion data) {
    return MusicBrainzArtist(
      mbid: data.mbid.present ? data.mbid.value : this.mbid,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MusicBrainzArtist(')
          ..write('mbid: $mbid, ')
          ..write('name: $name, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mbid, name, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MusicBrainzArtist &&
          other.mbid == this.mbid &&
          other.name == this.name &&
          other.type == this.type);
}

class MusicBrainzArtistsCompanion extends UpdateCompanion<MusicBrainzArtist> {
  final Value<String> mbid;
  final Value<String> name;
  final Value<String> type;
  final Value<int> rowid;
  const MusicBrainzArtistsCompanion({
    this.mbid = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MusicBrainzArtistsCompanion.insert({
    required String mbid,
    required String name,
    required String type,
    this.rowid = const Value.absent(),
  }) : mbid = Value(mbid),
       name = Value(name),
       type = Value(type);
  static Insertable<MusicBrainzArtist> custom({
    Expression<String>? mbid,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mbid != null) 'mbid': mbid,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MusicBrainzArtistsCompanion copyWith({
    Value<String>? mbid,
    Value<String>? name,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return MusicBrainzArtistsCompanion(
      mbid: mbid ?? this.mbid,
      name: name ?? this.name,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mbid.present) {
      map['mbid'] = Variable<String>(mbid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MusicBrainzArtistsCompanion(')
          ..write('mbid: $mbid, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MusicBrainzReleasesTable extends MusicBrainzReleases
    with TableInfo<$MusicBrainzReleasesTable, MusicBrainzRelease> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MusicBrainzReleasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mbidMeta = const VerificationMeta('mbid');
  @override
  late final GeneratedColumn<String> mbid = GeneratedColumn<String>(
    'mbid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songIdsMeta = const VerificationMeta(
    'songIds',
  );
  @override
  late final GeneratedColumn<String> songIds = GeneratedColumn<String>(
    'song_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [mbid, songIds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'music_brainz_releases';
  @override
  VerificationContext validateIntegrity(
    Insertable<MusicBrainzRelease> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mbid')) {
      context.handle(
        _mbidMeta,
        mbid.isAcceptableOrUnknown(data['mbid']!, _mbidMeta),
      );
    } else if (isInserting) {
      context.missing(_mbidMeta);
    }
    if (data.containsKey('song_ids')) {
      context.handle(
        _songIdsMeta,
        songIds.isAcceptableOrUnknown(data['song_ids']!, _songIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mbid};
  @override
  MusicBrainzRelease map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MusicBrainzRelease(
      mbid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mbid'],
      )!,
      songIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_ids'],
      )!,
    );
  }

  @override
  $MusicBrainzReleasesTable createAlias(String alias) {
    return $MusicBrainzReleasesTable(attachedDatabase, alias);
  }
}

class MusicBrainzRelease extends DataClass
    implements Insertable<MusicBrainzRelease> {
  /// MusicBrainz Identifier, see https://musicbrainz.org/doc/MusicBrainz_Identifier
  final String mbid;

  /// A string like '|13|14|15|' -- can be queried via: LIKE '%|13|%'.
  final String songIds;
  const MusicBrainzRelease({required this.mbid, required this.songIds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mbid'] = Variable<String>(mbid);
    map['song_ids'] = Variable<String>(songIds);
    return map;
  }

  MusicBrainzReleasesCompanion toCompanion(bool nullToAbsent) {
    return MusicBrainzReleasesCompanion(
      mbid: Value(mbid),
      songIds: Value(songIds),
    );
  }

  factory MusicBrainzRelease.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MusicBrainzRelease(
      mbid: serializer.fromJson<String>(json['mbid']),
      songIds: serializer.fromJson<String>(json['songIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mbid': serializer.toJson<String>(mbid),
      'songIds': serializer.toJson<String>(songIds),
    };
  }

  MusicBrainzRelease copyWith({String? mbid, String? songIds}) =>
      MusicBrainzRelease(
        mbid: mbid ?? this.mbid,
        songIds: songIds ?? this.songIds,
      );
  MusicBrainzRelease copyWithCompanion(MusicBrainzReleasesCompanion data) {
    return MusicBrainzRelease(
      mbid: data.mbid.present ? data.mbid.value : this.mbid,
      songIds: data.songIds.present ? data.songIds.value : this.songIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MusicBrainzRelease(')
          ..write('mbid: $mbid, ')
          ..write('songIds: $songIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mbid, songIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MusicBrainzRelease &&
          other.mbid == this.mbid &&
          other.songIds == this.songIds);
}

class MusicBrainzReleasesCompanion extends UpdateCompanion<MusicBrainzRelease> {
  final Value<String> mbid;
  final Value<String> songIds;
  final Value<int> rowid;
  const MusicBrainzReleasesCompanion({
    this.mbid = const Value.absent(),
    this.songIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MusicBrainzReleasesCompanion.insert({
    required String mbid,
    required String songIds,
    this.rowid = const Value.absent(),
  }) : mbid = Value(mbid),
       songIds = Value(songIds);
  static Insertable<MusicBrainzRelease> custom({
    Expression<String>? mbid,
    Expression<String>? songIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mbid != null) 'mbid': mbid,
      if (songIds != null) 'song_ids': songIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MusicBrainzReleasesCompanion copyWith({
    Value<String>? mbid,
    Value<String>? songIds,
    Value<int>? rowid,
  }) {
    return MusicBrainzReleasesCompanion(
      mbid: mbid ?? this.mbid,
      songIds: songIds ?? this.songIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mbid.present) {
      map['mbid'] = Variable<String>(mbid.value);
    }
    if (songIds.present) {
      map['song_ids'] = Variable<String>(songIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MusicBrainzReleasesCompanion(')
          ..write('mbid: $mbid, ')
          ..write('songIds: $songIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistItemsTable playlistItems = $PlaylistItemsTable(this);
  late final $ArtistSearchResultsTable artistSearchResults =
      $ArtistSearchResultsTable(this);
  late final $MusicBrainzArtistsTable musicBrainzArtists =
      $MusicBrainzArtistsTable(this);
  late final $MusicBrainzReleasesTable musicBrainzReleases =
      $MusicBrainzReleasesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    favorites,
    playlists,
    playlistItems,
    artistSearchResults,
    musicBrainzArtists,
    musicBrainzReleases,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({Value<int> songId});
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({Value<int> songId});

class $$FavoritesTableFilterComposer
    extends Composer<_$Database, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$Database, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$Database, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$Database,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, BaseReferences<_$Database, $FavoritesTable, Favorite>),
          Favorite,
          PrefetchHooks Function()
        > {
  $$FavoritesTableTableManager(_$Database db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({Value<int> songId = const Value.absent()}) =>
                  FavoritesCompanion(songId: songId),
          createCompanionCallback:
              ({Value<int> songId = const Value.absent()}) =>
                  FavoritesCompanion.insert(songId: songId),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, BaseReferences<_$Database, $FavoritesTable, Favorite>),
      Favorite,
      PrefetchHooks Function()
    >;
typedef $$PlaylistsTableCreateCompanionBuilder =
    PlaylistsCompanion Function({Value<int> id, required String name});
typedef $$PlaylistsTableUpdateCompanionBuilder =
    PlaylistsCompanion Function({Value<int> id, Value<String> name});

final class $$PlaylistsTableReferences
    extends BaseReferences<_$Database, $PlaylistsTable, Playlist> {
  $$PlaylistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistItemsTable, List<PlaylistItem>>
  _playlistItemsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.playlistItems,
    aliasName: $_aliasNameGenerator(
      db.playlists.id,
      db.playlistItems.playlistId,
    ),
  );

  $$PlaylistItemsTableProcessedTableManager get playlistItemsRefs {
    final manager = $$PlaylistItemsTableTableManager(
      $_db,
      $_db.playlistItems,
    ).filter((f) => f.playlistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlaylistsTableFilterComposer
    extends Composer<_$Database, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playlistItemsRefs(
    Expression<bool> Function($$PlaylistItemsTableFilterComposer f) f,
  ) {
    final $$PlaylistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistItems,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistItemsTableFilterComposer(
            $db: $db,
            $table: $db.playlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$Database, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$Database, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> playlistItemsRefs<T extends Object>(
    Expression<T> Function($$PlaylistItemsTableAnnotationComposer a) f,
  ) {
    final $$PlaylistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistItems,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableTableManager
    extends
        RootTableManager<
          _$Database,
          $PlaylistsTable,
          Playlist,
          $$PlaylistsTableFilterComposer,
          $$PlaylistsTableOrderingComposer,
          $$PlaylistsTableAnnotationComposer,
          $$PlaylistsTableCreateCompanionBuilder,
          $$PlaylistsTableUpdateCompanionBuilder,
          (Playlist, $$PlaylistsTableReferences),
          Playlist,
          PrefetchHooks Function({bool playlistItemsRefs})
        > {
  $$PlaylistsTableTableManager(_$Database db, $PlaylistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => PlaylistsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  PlaylistsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistItemsRefs) db.playlistItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistItemsRefs)
                    await $_getPrefetchedData<
                      Playlist,
                      $PlaylistsTable,
                      PlaylistItem
                    >(
                      currentTable: table,
                      referencedTable: $$PlaylistsTableReferences
                          ._playlistItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlaylistsTableReferences(
                            db,
                            table,
                            p0,
                          ).playlistItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playlistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $PlaylistsTable,
      Playlist,
      $$PlaylistsTableFilterComposer,
      $$PlaylistsTableOrderingComposer,
      $$PlaylistsTableAnnotationComposer,
      $$PlaylistsTableCreateCompanionBuilder,
      $$PlaylistsTableUpdateCompanionBuilder,
      (Playlist, $$PlaylistsTableReferences),
      Playlist,
      PrefetchHooks Function({bool playlistItemsRefs})
    >;
typedef $$PlaylistItemsTableCreateCompanionBuilder =
    PlaylistItemsCompanion Function({
      required int playlistId,
      required int songId,
      Value<int> rowid,
    });
typedef $$PlaylistItemsTableUpdateCompanionBuilder =
    PlaylistItemsCompanion Function({
      Value<int> playlistId,
      Value<int> songId,
      Value<int> rowid,
    });

final class $$PlaylistItemsTableReferences
    extends BaseReferences<_$Database, $PlaylistItemsTable, PlaylistItem> {
  $$PlaylistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlaylistsTable _playlistIdTable(_$Database db) =>
      db.playlists.createAlias(
        $_aliasNameGenerator(db.playlistItems.playlistId, db.playlists.id),
      );

  $$PlaylistsTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<int>('playlist_id')!;

    final manager = $$PlaylistsTableTableManager(
      $_db,
      $_db.playlists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaylistItemsTableFilterComposer
    extends Composer<_$Database, $PlaylistItemsTable> {
  $$PlaylistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );

  $$PlaylistsTableFilterComposer get playlistId {
    final $$PlaylistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableFilterComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistItemsTableOrderingComposer
    extends Composer<_$Database, $PlaylistItemsTable> {
  $$PlaylistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlaylistsTableOrderingComposer get playlistId {
    final $$PlaylistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableOrderingComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistItemsTableAnnotationComposer
    extends Composer<_$Database, $PlaylistItemsTable> {
  $$PlaylistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  $$PlaylistsTableAnnotationComposer get playlistId {
    final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableAnnotationComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistItemsTableTableManager
    extends
        RootTableManager<
          _$Database,
          $PlaylistItemsTable,
          PlaylistItem,
          $$PlaylistItemsTableFilterComposer,
          $$PlaylistItemsTableOrderingComposer,
          $$PlaylistItemsTableAnnotationComposer,
          $$PlaylistItemsTableCreateCompanionBuilder,
          $$PlaylistItemsTableUpdateCompanionBuilder,
          (PlaylistItem, $$PlaylistItemsTableReferences),
          PlaylistItem,
          PrefetchHooks Function({bool playlistId})
        > {
  $$PlaylistItemsTableTableManager(_$Database db, $PlaylistItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> playlistId = const Value.absent(),
                Value<int> songId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistItemsCompanion(
                playlistId: playlistId,
                songId: songId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int playlistId,
                required int songId,
                Value<int> rowid = const Value.absent(),
              }) => PlaylistItemsCompanion.insert(
                playlistId: playlistId,
                songId: songId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (playlistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playlistId,
                                referencedTable: $$PlaylistItemsTableReferences
                                    ._playlistIdTable(db),
                                referencedColumn: $$PlaylistItemsTableReferences
                                    ._playlistIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $PlaylistItemsTable,
      PlaylistItem,
      $$PlaylistItemsTableFilterComposer,
      $$PlaylistItemsTableOrderingComposer,
      $$PlaylistItemsTableAnnotationComposer,
      $$PlaylistItemsTableCreateCompanionBuilder,
      $$PlaylistItemsTableUpdateCompanionBuilder,
      (PlaylistItem, $$PlaylistItemsTableReferences),
      PlaylistItem,
      PrefetchHooks Function({bool playlistId})
    >;
typedef $$ArtistSearchResultsTableCreateCompanionBuilder =
    ArtistSearchResultsCompanion Function({
      required String name,
      Value<String?> mbid,
      Value<int> rowid,
    });
typedef $$ArtistSearchResultsTableUpdateCompanionBuilder =
    ArtistSearchResultsCompanion Function({
      Value<String> name,
      Value<String?> mbid,
      Value<int> rowid,
    });

class $$ArtistSearchResultsTableFilterComposer
    extends Composer<_$Database, $ArtistSearchResultsTable> {
  $$ArtistSearchResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mbid => $composableBuilder(
    column: $table.mbid,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArtistSearchResultsTableOrderingComposer
    extends Composer<_$Database, $ArtistSearchResultsTable> {
  $$ArtistSearchResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mbid => $composableBuilder(
    column: $table.mbid,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArtistSearchResultsTableAnnotationComposer
    extends Composer<_$Database, $ArtistSearchResultsTable> {
  $$ArtistSearchResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mbid =>
      $composableBuilder(column: $table.mbid, builder: (column) => column);
}

class $$ArtistSearchResultsTableTableManager
    extends
        RootTableManager<
          _$Database,
          $ArtistSearchResultsTable,
          ArtistSearchResult,
          $$ArtistSearchResultsTableFilterComposer,
          $$ArtistSearchResultsTableOrderingComposer,
          $$ArtistSearchResultsTableAnnotationComposer,
          $$ArtistSearchResultsTableCreateCompanionBuilder,
          $$ArtistSearchResultsTableUpdateCompanionBuilder,
          (
            ArtistSearchResult,
            BaseReferences<
              _$Database,
              $ArtistSearchResultsTable,
              ArtistSearchResult
            >,
          ),
          ArtistSearchResult,
          PrefetchHooks Function()
        > {
  $$ArtistSearchResultsTableTableManager(
    _$Database db,
    $ArtistSearchResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtistSearchResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistSearchResultsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ArtistSearchResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> name = const Value.absent(),
                Value<String?> mbid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistSearchResultsCompanion(
                name: name,
                mbid: mbid,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String name,
                Value<String?> mbid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistSearchResultsCompanion.insert(
                name: name,
                mbid: mbid,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArtistSearchResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $ArtistSearchResultsTable,
      ArtistSearchResult,
      $$ArtistSearchResultsTableFilterComposer,
      $$ArtistSearchResultsTableOrderingComposer,
      $$ArtistSearchResultsTableAnnotationComposer,
      $$ArtistSearchResultsTableCreateCompanionBuilder,
      $$ArtistSearchResultsTableUpdateCompanionBuilder,
      (
        ArtistSearchResult,
        BaseReferences<
          _$Database,
          $ArtistSearchResultsTable,
          ArtistSearchResult
        >,
      ),
      ArtistSearchResult,
      PrefetchHooks Function()
    >;
typedef $$MusicBrainzArtistsTableCreateCompanionBuilder =
    MusicBrainzArtistsCompanion Function({
      required String mbid,
      required String name,
      required String type,
      Value<int> rowid,
    });
typedef $$MusicBrainzArtistsTableUpdateCompanionBuilder =
    MusicBrainzArtistsCompanion Function({
      Value<String> mbid,
      Value<String> name,
      Value<String> type,
      Value<int> rowid,
    });

class $$MusicBrainzArtistsTableFilterComposer
    extends Composer<_$Database, $MusicBrainzArtistsTable> {
  $$MusicBrainzArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mbid => $composableBuilder(
    column: $table.mbid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MusicBrainzArtistsTableOrderingComposer
    extends Composer<_$Database, $MusicBrainzArtistsTable> {
  $$MusicBrainzArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mbid => $composableBuilder(
    column: $table.mbid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MusicBrainzArtistsTableAnnotationComposer
    extends Composer<_$Database, $MusicBrainzArtistsTable> {
  $$MusicBrainzArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mbid =>
      $composableBuilder(column: $table.mbid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$MusicBrainzArtistsTableTableManager
    extends
        RootTableManager<
          _$Database,
          $MusicBrainzArtistsTable,
          MusicBrainzArtist,
          $$MusicBrainzArtistsTableFilterComposer,
          $$MusicBrainzArtistsTableOrderingComposer,
          $$MusicBrainzArtistsTableAnnotationComposer,
          $$MusicBrainzArtistsTableCreateCompanionBuilder,
          $$MusicBrainzArtistsTableUpdateCompanionBuilder,
          (
            MusicBrainzArtist,
            BaseReferences<
              _$Database,
              $MusicBrainzArtistsTable,
              MusicBrainzArtist
            >,
          ),
          MusicBrainzArtist,
          PrefetchHooks Function()
        > {
  $$MusicBrainzArtistsTableTableManager(
    _$Database db,
    $MusicBrainzArtistsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MusicBrainzArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MusicBrainzArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MusicBrainzArtistsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> mbid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MusicBrainzArtistsCompanion(
                mbid: mbid,
                name: name,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mbid,
                required String name,
                required String type,
                Value<int> rowid = const Value.absent(),
              }) => MusicBrainzArtistsCompanion.insert(
                mbid: mbid,
                name: name,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MusicBrainzArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $MusicBrainzArtistsTable,
      MusicBrainzArtist,
      $$MusicBrainzArtistsTableFilterComposer,
      $$MusicBrainzArtistsTableOrderingComposer,
      $$MusicBrainzArtistsTableAnnotationComposer,
      $$MusicBrainzArtistsTableCreateCompanionBuilder,
      $$MusicBrainzArtistsTableUpdateCompanionBuilder,
      (
        MusicBrainzArtist,
        BaseReferences<_$Database, $MusicBrainzArtistsTable, MusicBrainzArtist>,
      ),
      MusicBrainzArtist,
      PrefetchHooks Function()
    >;
typedef $$MusicBrainzReleasesTableCreateCompanionBuilder =
    MusicBrainzReleasesCompanion Function({
      required String mbid,
      required String songIds,
      Value<int> rowid,
    });
typedef $$MusicBrainzReleasesTableUpdateCompanionBuilder =
    MusicBrainzReleasesCompanion Function({
      Value<String> mbid,
      Value<String> songIds,
      Value<int> rowid,
    });

class $$MusicBrainzReleasesTableFilterComposer
    extends Composer<_$Database, $MusicBrainzReleasesTable> {
  $$MusicBrainzReleasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mbid => $composableBuilder(
    column: $table.mbid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songIds => $composableBuilder(
    column: $table.songIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MusicBrainzReleasesTableOrderingComposer
    extends Composer<_$Database, $MusicBrainzReleasesTable> {
  $$MusicBrainzReleasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mbid => $composableBuilder(
    column: $table.mbid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songIds => $composableBuilder(
    column: $table.songIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MusicBrainzReleasesTableAnnotationComposer
    extends Composer<_$Database, $MusicBrainzReleasesTable> {
  $$MusicBrainzReleasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mbid =>
      $composableBuilder(column: $table.mbid, builder: (column) => column);

  GeneratedColumn<String> get songIds =>
      $composableBuilder(column: $table.songIds, builder: (column) => column);
}

class $$MusicBrainzReleasesTableTableManager
    extends
        RootTableManager<
          _$Database,
          $MusicBrainzReleasesTable,
          MusicBrainzRelease,
          $$MusicBrainzReleasesTableFilterComposer,
          $$MusicBrainzReleasesTableOrderingComposer,
          $$MusicBrainzReleasesTableAnnotationComposer,
          $$MusicBrainzReleasesTableCreateCompanionBuilder,
          $$MusicBrainzReleasesTableUpdateCompanionBuilder,
          (
            MusicBrainzRelease,
            BaseReferences<
              _$Database,
              $MusicBrainzReleasesTable,
              MusicBrainzRelease
            >,
          ),
          MusicBrainzRelease,
          PrefetchHooks Function()
        > {
  $$MusicBrainzReleasesTableTableManager(
    _$Database db,
    $MusicBrainzReleasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MusicBrainzReleasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MusicBrainzReleasesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MusicBrainzReleasesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> mbid = const Value.absent(),
                Value<String> songIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MusicBrainzReleasesCompanion(
                mbid: mbid,
                songIds: songIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mbid,
                required String songIds,
                Value<int> rowid = const Value.absent(),
              }) => MusicBrainzReleasesCompanion.insert(
                mbid: mbid,
                songIds: songIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MusicBrainzReleasesTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $MusicBrainzReleasesTable,
      MusicBrainzRelease,
      $$MusicBrainzReleasesTableFilterComposer,
      $$MusicBrainzReleasesTableOrderingComposer,
      $$MusicBrainzReleasesTableAnnotationComposer,
      $$MusicBrainzReleasesTableCreateCompanionBuilder,
      $$MusicBrainzReleasesTableUpdateCompanionBuilder,
      (
        MusicBrainzRelease,
        BaseReferences<
          _$Database,
          $MusicBrainzReleasesTable,
          MusicBrainzRelease
        >,
      ),
      MusicBrainzRelease,
      PrefetchHooks Function()
    >;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistItemsTableTableManager get playlistItems =>
      $$PlaylistItemsTableTableManager(_db, _db.playlistItems);
  $$ArtistSearchResultsTableTableManager get artistSearchResults =>
      $$ArtistSearchResultsTableTableManager(_db, _db.artistSearchResults);
  $$MusicBrainzArtistsTableTableManager get musicBrainzArtists =>
      $$MusicBrainzArtistsTableTableManager(_db, _db.musicBrainzArtists);
  $$MusicBrainzReleasesTableTableManager get musicBrainzReleases =>
      $$MusicBrainzReleasesTableTableManager(_db, _db.musicBrainzReleases);
}

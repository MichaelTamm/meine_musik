// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Playlists extends Table with TableInfo<Playlists, PlaylistsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Playlists(this.attachedDatabase, [this._alias]);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistsData(
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
  Playlists createAlias(String alias) {
    return Playlists(attachedDatabase, alias);
  }
}

class PlaylistsData extends DataClass implements Insertable<PlaylistsData> {
  final int id;
  final String name;
  const PlaylistsData({required this.id, required this.name});
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

  factory PlaylistsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistsData(
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

  PlaylistsData copyWith({int? id, String? name}) =>
      PlaylistsData(id: id ?? this.id, name: name ?? this.name);
  PlaylistsData copyWithCompanion(PlaylistsCompanion data) {
    return PlaylistsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsData(')
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
      (other is PlaylistsData &&
          other.id == this.id &&
          other.name == this.name);
}

class PlaylistsCompanion extends UpdateCompanion<PlaylistsData> {
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
  static Insertable<PlaylistsData> custom({
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

class PlaylistItems extends Table
    with TableInfo<PlaylistItems, PlaylistItemsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PlaylistItems(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES playlists (id)',
    ),
  );
  late final GeneratedColumn<int> audioFileId = GeneratedColumn<int>(
    'audio_file_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [playlistId, audioFileId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_items';
  @override
  Set<GeneratedColumn> get $primaryKey => {playlistId, audioFileId};
  @override
  PlaylistItemsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistItemsData(
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playlist_id'],
      )!,
      audioFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_file_id'],
      )!,
    );
  }

  @override
  PlaylistItems createAlias(String alias) {
    return PlaylistItems(attachedDatabase, alias);
  }
}

class PlaylistItemsData extends DataClass
    implements Insertable<PlaylistItemsData> {
  final int playlistId;
  final int audioFileId;
  const PlaylistItemsData({
    required this.playlistId,
    required this.audioFileId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['playlist_id'] = Variable<int>(playlistId);
    map['audio_file_id'] = Variable<int>(audioFileId);
    return map;
  }

  PlaylistItemsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistItemsCompanion(
      playlistId: Value(playlistId),
      audioFileId: Value(audioFileId),
    );
  }

  factory PlaylistItemsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistItemsData(
      playlistId: serializer.fromJson<int>(json['playlistId']),
      audioFileId: serializer.fromJson<int>(json['audioFileId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playlistId': serializer.toJson<int>(playlistId),
      'audioFileId': serializer.toJson<int>(audioFileId),
    };
  }

  PlaylistItemsData copyWith({int? playlistId, int? audioFileId}) =>
      PlaylistItemsData(
        playlistId: playlistId ?? this.playlistId,
        audioFileId: audioFileId ?? this.audioFileId,
      );
  PlaylistItemsData copyWithCompanion(PlaylistItemsCompanion data) {
    return PlaylistItemsData(
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      audioFileId: data.audioFileId.present
          ? data.audioFileId.value
          : this.audioFileId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistItemsData(')
          ..write('playlistId: $playlistId, ')
          ..write('audioFileId: $audioFileId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(playlistId, audioFileId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistItemsData &&
          other.playlistId == this.playlistId &&
          other.audioFileId == this.audioFileId);
}

class PlaylistItemsCompanion extends UpdateCompanion<PlaylistItemsData> {
  final Value<int> playlistId;
  final Value<int> audioFileId;
  final Value<int> rowid;
  const PlaylistItemsCompanion({
    this.playlistId = const Value.absent(),
    this.audioFileId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistItemsCompanion.insert({
    required int playlistId,
    required int audioFileId,
    this.rowid = const Value.absent(),
  }) : playlistId = Value(playlistId),
       audioFileId = Value(audioFileId);
  static Insertable<PlaylistItemsData> custom({
    Expression<int>? playlistId,
    Expression<int>? audioFileId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (playlistId != null) 'playlist_id': playlistId,
      if (audioFileId != null) 'audio_file_id': audioFileId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistItemsCompanion copyWith({
    Value<int>? playlistId,
    Value<int>? audioFileId,
    Value<int>? rowid,
  }) {
    return PlaylistItemsCompanion(
      playlistId: playlistId ?? this.playlistId,
      audioFileId: audioFileId ?? this.audioFileId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (audioFileId.present) {
      map['audio_file_id'] = Variable<int>(audioFileId.value);
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
          ..write('audioFileId: $audioFileId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final Playlists playlists = Playlists(this);
  late final PlaylistItems playlistItems = PlaylistItems(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    playlists,
    playlistItems,
  ];
  @override
  int get schemaVersion => 1;
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

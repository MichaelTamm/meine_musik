import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/model/IsFavoriteSongPredicate.dart';
import 'package:meine_musik/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../drift/database.dart' hide Playlist;
import '../env.dart';
import '../model/AudioFile.dart';
import '../model/AudioFolder.dart';
import '../model/IsSongPredicate.dart';
import '../model/Playlist.dart';
import '../model/Song.dart';
import 'database_providers.dart';
import 'media.dart';

part 'playlists.g.dart';

@riverpod
Future<List<Playlist>> playlists(Ref ref) async {
  final (allSongs, favoriteSongs, manuallyCreatedPlaylists) = await Futures.tuple3(
    ref.watch(allSongsProvider.future),
    ref.watch(favoriteSongsProvider.future),
    ref.watch(manuallyCreatedPlaylistsProvider.future),
  );
  final playlists = [allSongs, favoriteSongs, ...manuallyCreatedPlaylists];
  ref.keepAlive();
  return playlists;
}

@riverpod
Future<AllSongs> allSongs(Ref ref) async {
  final (audioFiles, isSongPredicate) = await Futures.tuple2(
    ref.watch(localAudioFilesProvider.future),
    ref.watch(isSongPredicateProvider.future),
  );
  final allSongs = [...audioFiles.where(isSongPredicate.call)];
  ref.keepAlive();
  return AllSongs(allSongs);
}

@riverpod
Future<FavoriteSongs> favoriteSongs(Ref ref) async {
  final (audioFiles, isFavoriteSongPredicate) = await Futures.tuple2(
    ref.watch(localAudioFilesProvider.future),
    ref.watch(isFavoriteSongPredicateProvider.future),
  );
  final favoriteSongs = [...audioFiles.where(isFavoriteSongPredicate.call)];
  ref.keepAlive();
  return FavoriteSongs(
    favoriteSongs,
    addSong: (Song song) async {
      final dirFuture = getApplicationDocumentsDirectory();
      final oldIsFavoriteSongPredicate = await riverpodContainer.read(isFavoriteSongPredicateProvider.future);
      final newIsFavoriteSongPredicate = oldIsFavoriteSongPredicate.addFile(song);
      final dir = await dirFuture;
      final configFile = File('${dir.path}/IsFavoriteSongPredicate.config');
      await newIsFavoriteSongPredicate.writeToFile(configFile);
      riverpodContainer.invalidate(isFavoriteSongPredicateProvider);
    },
    removeSong: (Song song) async {
      final dirFuture = getApplicationDocumentsDirectory();
      final oldIsFavoriteSongPredicate = await riverpodContainer.read(isFavoriteSongPredicateProvider.future);
      final newIsFavoriteSongPredicate = oldIsFavoriteSongPredicate.removeFile(song);
      final dir = await dirFuture;
      final configFile = File('${dir.path}/IsFavoriteSongPredicate.config');
      await newIsFavoriteSongPredicate.writeToFile(configFile);
      riverpodContainer.invalidate(isFavoriteSongPredicateProvider);
    },
  );
}

@riverpod
Future<List<ManuallyCreatedPlaylist>> manuallyCreatedPlaylists(Ref ref) async {
  final (localAudioFilesById, playlistDatabaseRecords, playlistItems) = await Futures.tuple3(
    ref.watch(localAudioFilesByIdProvider.future),
    ref.watch(playlistDatabaseRecordsProvider.future),
    ref.watch(playlistItemsDatabaseRecordsProvider.future),
  );
  final songsByPlaylistId = <int, List<Song>>{};
  for (final playlistItem in playlistItems) {
    final playlistId = playlistItem.playlistId;
    final audioFileId = playlistItem.audioFileId;
    final audioFile = localAudioFilesById[audioFileId];
    if (audioFile != null) {
      var songs = songsByPlaylistId[playlistId];
      if (songs == null) {
        songs = [];
        songsByPlaylistId[playlistId] = songs;
      }
      songs.add(audioFile);
    }
  }
  final manuallyCreatedPlaylists = playlistDatabaseRecords.map(
    (record) => ManuallyCreatedPlaylist(
      record.name,
      songsByPlaylistId[record.id] ?? [],
      setName: (String name) async {
        await (db.playlists.update()..where((t) => t.id.equals(record.id))).write(PlaylistsCompanion(name: Value(name)));
      },
      addSong: (Song song) async {
        await db.playlistItems.insert().insert(PlaylistItemsCompanion(playlistId: Value(record.id), audioFileId: Value(song.id)));
      },
      removeSong: (Song song) async {
        await db.playlistItems.delete().delete(PlaylistItemsCompanion(playlistId: Value(record.id), audioFileId: Value(song.id)));
      },
      delete: () async {
        await (db.playlists.delete()..where((t) => t.id.equals(record.id))).go();
      },
    ),
  );
  ref.keepAlive();
  return UnmodifiableListView(manuallyCreatedPlaylists);
}

@riverpod
Future<IsSongPredicate> isSongPredicate(Ref ref) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final configFile = File('${dir.path}/IsSongPredicate.config');
    final isSongPredicate = await IsSongPredicate.fromFile(configFile);
    ref.keepAlive();
    return isSongPredicate;
  } catch (error, stack) {
    debugPrintStack(label: 'Failed to read IsSongPredicate.config: $error', stackTrace: stack);
    final fallback = IsSongPredicate();
    ref.keepAlive();
    return fallback;
  }
}

Future<void> whitelistFolder(AudioFolder folder, WidgetRef ref) async {
  final dirFuture = getApplicationDocumentsDirectory();
  final oldIsSongPredicate = await ref.read(isSongPredicateProvider.future);
  final newIsSongPredicate = oldIsSongPredicate.whitelistFolder(folder);
  final dir = await dirFuture;
  final configFile = File('${dir.path}/IsSongPredicate.config');
  await newIsSongPredicate.writeToFile(configFile);
  ref.invalidate(isSongPredicateProvider);
}

Future<void> blacklistFolder(AudioFolder folder, WidgetRef ref) async {
  final dirFuture = getApplicationDocumentsDirectory();
  final oldIsSongPredicate = await ref.read(isSongPredicateProvider.future);
  final newIsSongPredicate = oldIsSongPredicate.blacklistFolder(folder);
  final dir = await dirFuture;
  final configFile = File('${dir.path}/IsSongPredicate.config');
  await newIsSongPredicate.writeToFile(configFile);
  ref.invalidate(isSongPredicateProvider);
}

Future<void> whitelistFile(AudioFile file, WidgetRef ref) async {
  final dirFuture = getApplicationDocumentsDirectory();
  final oldIsSongPredicate = await ref.read(isSongPredicateProvider.future);
  final newIsSongPredicate = oldIsSongPredicate.whitelistFile(file);
  final dir = await dirFuture;
  final configFile = File('${dir.path}/IsSongPredicate.config');
  await newIsSongPredicate.writeToFile(configFile);
  ref.invalidate(isSongPredicateProvider);
}

Future<void> blacklistFile(AudioFile file, WidgetRef ref) async {
  final dirFuture = getApplicationDocumentsDirectory();
  final oldIsSongPredicate = await ref.read(isSongPredicateProvider.future);
  final newIsSongPredicate = oldIsSongPredicate.blacklistFile(file);
  final dir = await dirFuture;
  final configFile = File('${dir.path}/IsSongPredicate.config');
  await newIsSongPredicate.writeToFile(configFile);
  ref.invalidate(isSongPredicateProvider);
}

@riverpod
Future<IsFavoriteSongPredicate> isFavoriteSongPredicate(Ref ref) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final configFile = File('${dir.path}/IsFavoriteSongPredicate.config');
    final isFavoriteSongPredicate = await IsFavoriteSongPredicate.fromFile(configFile);
    ref.keepAlive();
    return isFavoriteSongPredicate;
  } catch (error, stack) {
    debugPrintStack(label: 'Failed to read IsFavoriteSongPredicate.config: $error', stackTrace: stack);
    final fallback = IsFavoriteSongPredicate();
    ref.keepAlive();
    return fallback;
  }
}

/// The playlist, to which a song is added, when the bookmark button is pressed.
/// Initial value: Favoriten
@Riverpod(keepAlive: true)
class CurrentBookmarkTarget extends _$CurrentBookmarkTarget {
  @override
  Future<Playlist> build() {
    final favoriten = ref.watch(favoriteSongsProvider.future);
    return favoriten;
  }

  void set(Playlist playlist) {
    if (!(playlist is FavoriteSongs || playlist is ManuallyCreatedPlaylist)) {
      throw ArgumentError('Unexpected playlist: $playlist -- expected: $FavoriteSongs or $ManuallyCreatedPlaylist');
    }
    state = AsyncValue.data(playlist);
  }
}
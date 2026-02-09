import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../drift/database.dart' hide Playlist;
import '../model/AudioFile.dart';
import '../model/AudioFolder.dart';
import '../model/IsSongPredicate.dart';
import '../model/Playlist.dart';
import '../model/Song.dart';
import 'database_providers.dart';
import 'media.dart';

part 'playlists.g.dart';

@Riverpod(keepAlive: true)
Future<List<Playlist>> playlists(Ref ref) async {
  final (allSongs, favoriteSongs, manuallyCreatedPlaylists) = await Futures.tuple3(
    ref.watch(alleLiederProvider.future),
    ref.watch(favoritenProvider.future),
    ref.watch(manuallyCreatedPlaylistsProvider.future),
  );
  return [allSongs, favoriteSongs, ...manuallyCreatedPlaylists];
}

@Riverpod(keepAlive: true)
Future<AlleLieder> alleLieder(Ref ref) async {
  final (audioFiles, isSongPredicate) = await Futures.tuple2(
    ref.watch(localAudioFilesProvider.future),
    ref.watch(isSongPredicateProvider.future),
  );
  final allSongs = [...audioFiles.where(isSongPredicate.call)];
  return AlleLieder(allSongs);
}

@Riverpod(keepAlive: true)
Future<Favoriten> favoriten(Ref ref) async {
  final (localAudioFilesById, favorites) = await Futures.tuple2(
    ref.watch(localAudioFilesByIdProvider.future),
    ref.watch(favoritesDatabaseRecordsProvider.future),
  );
  final favoriteSongs = <Song>[];
  for (final favorite in favorites) {
    final song = localAudioFilesById[favorite.songId];
    if (song != null) {
      favoriteSongs.add(song);
    }
  }
  return Favoriten(
    favoriteSongs,
    addSong: (Song song) async {
      await db.favorites.insertOne(FavoritesCompanion(songId: Value(song.id)));
    },
    removeSong: (Song song) async {
      await db.favorites.deleteWhere((t) => t.songId.equals(song.id));
    },
  );
}

@Riverpod(keepAlive: true)
Future<List<int>> manuallyCreatedPlaylistIds(Ref ref) async {
  final playlistsRecords = await ref.watch(playlistsDatabaseRecordsProvider.future);
  final ids = playlistsRecords.map((it) => it.id).toList();
  return ids;
}

@Riverpod(keepAlive: true)
Future<ManuallyCreatedPlaylist> manuallyCreatedPlaylist(Ref ref, int playlistId) async {
  final (localAudioFilesById, playlistRecord, playlistItemsRecords) = await Futures.tuple3(
    ref.watch(localAudioFilesByIdProvider.future),
    ref.watch(playlistsDatabaseRecordsProvider.selectAsync((it) => it.firstWhere((it) => it.id == playlistId))),
    ref.watch(playlistItemsDatabaseRecordsProvider(playlistId).future),
  );
  final songs = <Song>[];
  for (final playlistItem in playlistItemsRecords) {
    final song = localAudioFilesById[playlistItem.songId];
    if (song != null) {
      songs.add(song);
    }
  }
  final playlist = ManuallyCreatedPlaylist(
    playlistId,
    playlistRecord.name,
    songs,
    setName: (String name) async {
      await (db.playlists.update()..where((t) => t.id.equals(playlistId))).write(PlaylistsCompanion(name: Value(name)));
    },
    addSong: (Song song) async {
      await db.playlistItems.insertOne(PlaylistItemsCompanion(playlistId: Value(playlistId), songId: Value(song.id)));
    },
    removeSong: (Song song) async {
      await db.playlistItems.deleteOne(PlaylistItemsCompanion(playlistId: Value(playlistId), songId: Value(song.id)));
    },
    delete: () async {
      await db.deletePlaylist(playlistId);
    },
  );
  return playlist;
}

@Riverpod(keepAlive: true)
Future<List<ManuallyCreatedPlaylist>> manuallyCreatedPlaylists(Ref ref) async {
  final playlistIds = ref.watch(manuallyCreatedPlaylistIdsProvider).value ?? [];
  final futures = playlistIds.map((playlistId) => ref.watch(manuallyCreatedPlaylistProvider(playlistId).future));
  final playlists = await Future.wait(futures);
  return playlists;
}

@Riverpod(keepAlive: true)
Future<IsSongPredicate> isSongPredicate(Ref ref) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final configFile = File('${dir.path}/IsSongPredicate.config');
    final isSongPredicate = await IsSongPredicate.fromFile(configFile);
    return isSongPredicate;
  } catch (error, stack) {
    debugPrintStack(label: 'Failed to read IsSongPredicate.config: $error', stackTrace: stack);
    final fallback = IsSongPredicate();
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

/// The id of the manually created playlist, to which a song is added, when the bookmark button is pressed.
/// If id == null the bookmark target is the Favoriten playlist.
/// Initial value: null
@Riverpod(keepAlive: true)
class CurrentBookmarkTargetId extends _$CurrentBookmarkTargetId {
  @override
  int? build() => null;

  void set(Playlist playlist) {
    if (playlist is Favoriten) {
      state = null;
    } else if (playlist is ManuallyCreatedPlaylist) {
      state = playlist.id;
    } else {
      throw ArgumentError('$playlist is not a valid bookmark target');
    }
  }
}

@Riverpod()
Future<Playlist> currentBookmarkTarget(Ref ref) {
  final currentBookmarkTargetId = ref.watch(currentBookmarkTargetIdProvider);
  if (currentBookmarkTargetId == null) {
    return ref.watch(favoritenProvider.future);
  } else {
    return ref.watch(manuallyCreatedPlaylistProvider(currentBookmarkTargetId).future);
  }
}

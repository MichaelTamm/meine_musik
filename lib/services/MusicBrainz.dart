import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meine_musik/env.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart' show MusicBrainzApiClient;

import '../drift/database.dart';
import '../model/Playlist.dart';
import '../riverpod/media.dart';
import '../utils.dart';

class MusicBrainz {
  MusicBrainz(http.Client httpClient) : _apiClient = MusicBrainzApiClient(httpClient: httpClient, isSilent: false);

  final MusicBrainzApiClient _apiClient;
  final Map<String, Future<MusicBrainzArtist?>> _searchArtistByNameCache = {};
  final Map<int, Future<MusicBrainzRelease?>> _searchReleaseByAlbumCache = {};

  Future<MusicBrainzArtist?> searchArtistByName(String name) async {
    var cached = true;
    try {
      final future = _searchArtistByNameCache.putIfAbsent(name, () async {
        cached = false;
        var artist = await db.findArtistByName(name);
        if (artist == null) {
          artist = await _searchArtistByName(name);
          if (artist != null) {
            try {
              await db.musicBrainzArtists.insertOne(artist.toCompanion(true));
            } catch (error) {
              if ('$error'.startsWith('SqliteException(1555):') /* <-- SQLITE_CONSTRAINT_PRIMARYKEY, see https://sqlite.org/rescode.html#constraint_primarykey */) {
                // Ignored.
              } else {
                rethrow;
              }
            }
            if (artist.name != name) {
              try {
                await db.artistSearchResults.insertOne(ArtistSearchResult(name: name, mbid: artist.mbid).toCompanion(true));
              } catch (error) {
                if ('$error'.startsWith('SqliteException(1555):') /* <-- SQLITE_CONSTRAINT_PRIMARYKEY, see https://sqlite.org/rescode.html#constraint_primarykey */) {
                  // Ignored.
                } else {
                  rethrow;
                }
              }
            }
          }
          try {
            await db.artistSearchResults.insertOne(ArtistSearchResult(name: name, mbid: artist?.mbid).toCompanion(true));
          } catch (error) {
            if ('$error'.startsWith('SqliteException(1555):') /* <-- SQLITE_CONSTRAINT_PRIMARYKEY, see https://sqlite.org/rescode.html#constraint_primarykey */) {
              // Ignored.
            } else {
              rethrow;
            }
          }
        }
        return artist;
      });
      final result = await future;
      return result;
    } catch (error, stack) {
      if (!cached) {
        debugPrintStack(label: 'Failed to search artist ${toDartString(name)} -- $error', stackTrace: stack);
      }
      return null;
    }
  }

  Future<MusicBrainzArtist?> _searchArtistByName(String name) async {
    final data = await _apiClient.artists.search('artist:$name', limit: 5);
    final searchResult = data['artists'] as List<dynamic>;
    final normalizedName = name.normalize();
    final matches = searchResult
        .where((it) => (it['score'] as num) == 100 || (it['name'] as String).normalize() == normalizedName)
        .toList();
    if (matches.isEmpty) {
      if (searchResult.isEmpty) {
        debugPrint('Did no find artist ${toDartString(name)} in MusicBrainz database');
      } else {
        debugPrint(
          'Did no find artist ${toDartString(name)} in MusicBrainz database -- best candidate: ${jsonEncode({'id': '${searchResult.first['id']}', 'score': searchResult.first['score'], 'name': searchResult.first['name']})}',
        );
      }
    } else if (matches.length == 1) {
      final match = matches[0];
      final id = match['id'] as String;
      debugPrint('Found artist ${toDartString(name)} in MusicBrainz database: https://musicbrainz.org/artist/$id');
      final artist = MusicBrainzArtist(mbid: id, name: match['name'] as String? ?? name, type: matches[0]['type'] as String? ?? '');
      return artist;
    } else {
      debugPrint('Found ${matches.length} matches for artist ${toDartString(name)} -- TODO: disambiguate');
      // TODO: Disambiguate by querying and comparing known songs.
    }
    return null;
  }

  Future<MusicBrainzRelease?> searchReleaseByAlbum(Album album) async {
    var cached = true;
    try {
      final future = _searchReleaseByAlbumCache.putIfAbsent(album.firstSong.id, () async {
        cached = false;
        var release = await db.findReleaseBySongId(album.firstSong.id);
        if (release == null) {
          release = await _searchReleaseByAlbum(album);
          if (release != null) {
            await db.musicBrainzReleases.insertOne(release.toCompanion(true));
          }
        }
        return release;
      });
      final result = await future;
      return result;
    } catch (error, stack) {
      if (!cached) {
        debugPrintStack(label: 'Failed to search release for $album -- $error', stackTrace: stack);
      }
      return null;
    }
  }

  Future<MusicBrainzRelease?> _searchReleaseByAlbum(Album album) async {
    final kuenstler = album.kuenstler;

    MusicBrainzRelease toMusicBrainzRelease(Map<String, dynamic> releaseData) {
      final id = releaseData['id'] as String;
      final title = releaseData['title'] as String;
      debugPrint('Found release ${toDartString(title)} for $album in MusicBrainz database: https://musicbrainz.org/release/$id');
      return MusicBrainzRelease(mbid: id, songIds: '|${album.map((song) => song.id).join('|')}|');
    }

    if (kuenstler.isNotEmpty && kuenstler != 'verschiedene Künstler') {
      final artist = await riverpodContainer.read(artistProvider(kuenstler).future);
      if (artist != null) {
        final data = await _apiClient.artists.get(artist.mbid, inc: ['release-groups']);
        final releaseGroups = (data['release-groups'] as List<dynamic>).cast<Map<String, dynamic>>();
        final normalizedAlbumName = album.name.normalize().toLowerCase();
        for (final releaseGroup in releaseGroups) {
          final primaryType = releaseGroup['primary-type'] as String?;
          if (primaryType != 'Album') {
            continue;
          }
          final title = releaseGroup['title'] as String? ?? '';
          if (title.normalize().toLowerCase() == normalizedAlbumName) {
            final id = releaseGroup['id'] as String;
            debugPrint('Found release-group ${toDartString(title)} for $album in MusicBrainz database: https://musicbrainz.org/release-group/$id');
            final data = await _apiClient.releaseGroups.get(id, inc: ['releases']);
            final releases = (data['releases'] as List<dynamic>).cast<Map<String, dynamic>>();
            final officialReleases = releases.where((it) => it['status'] == 'Official');
            // 1st round: search for release with disambiguation == "" and country != "XW" ...
            for (final release in officialReleases) {
              final disambiguation = release['disambiguation'] as String?;
              final country = release['country'] as String?;
              if ((disambiguation == null || disambiguation.isEmpty) && country != 'XW') {
                return toMusicBrainzRelease(release);
              }
            }
            // 2nd round: search for release with disambiguation == ""
            for (final release in officialReleases) {
              final disambiguation = release['disambiguation'] as String?;
              if (disambiguation == null || disambiguation.isEmpty) {
                return toMusicBrainzRelease(release);
              }
            }
            // Fallback ...
            return toMusicBrainzRelease(officialReleases.firstOrNull ?? releases.first);
          }
        }
      }
      final query = artist == null ? 'artistname:"$kuenstler" release:"${album.name}"' : 'arid:${artist.mbid} release:"${album.name}"';
      final data = await _apiClient.releaseGroups.search(query, limit: 10);
      final searchResult = data['release-groups'] as List<dynamic>;
      final normalizedAlbumName = album.name.normalize();
      final matches = searchResult
          .where((it) => (it['score'] as num) == 100 || (it['name'] as String).normalize() == normalizedAlbumName)
          .toList();
      if (matches.isEmpty) {
        if (searchResult.isEmpty) {
          debugPrint('Did no find release-group using query ${toDartString(query)} in MusicBrainz database');
        } else {
          debugPrint(
            'Did no find release-group ${toDartString(album.name)} by $kuenstler in MusicBrainz database -- best candidate: ${jsonEncode({'id': searchResult.first['id'], 'score': searchResult.first['score'], 'title': searchResult.first['title']})}',
          );
        }
      } else if (matches.length == 1) {
        final id = matches[0]['id'] as String;
        debugPrint(
          'Found release-group ${toDartString(album.name)} by $kuenstler in MusicBrainz database: https://musicbrainz.org/release-group/$id',
        );
        // TODO: ...
      } else {
        debugPrint('Found ${matches.length} matches for album ${toDartString(album.name)} by $kuenstler -- TODO: disambiguate');
        // TODO: ...
      }
    } else {
      // Search by album title ...
      final data = await _apiClient.releases.search('release:${album.name}');
      final searchResult = data['releases'] as List<dynamic>;
      final normalizedAlbumName = album.name.normalize();
      final matches = searchResult
          .where((it) => (it['score'] as num) == 100 || (it['title'] as String).normalize() == normalizedAlbumName)
          .toList();
      if (matches.isEmpty) {
        if (searchResult.isEmpty) {
          debugPrint('Did no find release ${toDartString(album.name)} in MusicBrainz database');
        } else {
          debugPrint(
            'Did no find release ${toDartString(album.name)} in MusicBrainz database -- best candidate: ${jsonEncode({'id': searchResult.first['id'], 'score': searchResult.first['score'], 'title': searchResult.first['title']})}',
          );
        }
      } else if (matches.length == 1) {
        final id = matches[0]['id'] as String;
        debugPrint('Found release ${toDartString(album.name)} in MusicBrainz database: https://musicbrainz.org/release/$id');
        final release = MusicBrainzRelease(mbid: id, songIds: '|${album.map((song) => song.id).join('|')}|');
        return release;
      } else {
        debugPrint('Found ${matches.length} matches for album ${toDartString(album.name)} -- TODO: disambiguate');
        // TODO: Disambiguate by songs ...
        // for (final match in matches) {
        //   final id = match['id'] as String;
        //   final releaseData = await musicBrainz.releases.get(id, inc: ['recordings']);
        //   ...
        // }
      }
    }
    return null;
  }
}

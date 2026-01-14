import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../utils.dart';
import 'AudioFile.dart';
import 'Song.dart';

abstract class Playlist with IterableMixin<Song> {
  static final empty = _EmptyPlaylist();

  Playlist(this.name, Iterable<Song> songs, {this.upperTitle = '', this.setName, this.addSong, this.removeSong, this.delete})
    : _songs = songs.toList(growable: false),
      playOrder = List.generate(songs.length, (index) => index),
      duration = Duration(milliseconds: songs.fold(0, (total, file) => total + file.durationInMilliseconds));

  final String upperTitle;
  final String name;
  final List<Song> _songs;
  final Duration duration;

  final FutureOr<void> Function(String name)? setName;
  final FutureOr<void> Function(Song song)? addSong;
  final FutureOr<void> Function(Song song)? removeSong;
  final FutureOr<void> Function()? delete;

  bool shuffled = false;
  List<int> playOrder;

  void shuffle([Random? random]) {
    shuffled = true;
    playOrder = List.of(playOrder, growable: false)..shuffle(random);
  }

  @override
  Iterator<Song> get iterator => _songs.iterator;

  Song get firstSong {
    if (isEmpty) {
      throw StateError('$this is empty');
    } else {
      return this[playOrder[0]];
    }
  }

  Song get lastSong {
    if (isEmpty) {
      throw StateError('$this is empty');
    } else {
      return this[playOrder[length - 1]];
    }
  }

  @override
  int get length => _songs.length;

  bool get editable => setName != null || (addSong != null && removeSong != null) || delete != null;

  Song operator [](int index) => _songs[index];

  @override
  toString() =>
      '$runtimeType(${toDartString(name)}, ${switch (length) {
        0 => '0 songs',
        1 => '1 song: ${_songs.first}',
        _ => '$length songs',
      }})';
}

@immutable
class AudioFileList extends UnmodifiableListView<AudioFile> {
  AudioFileList(super._source);
}

class _EmptyPlaylist extends Playlist {
  _EmptyPlaylist() : super('', []);

  @override
  toString() => 'Playlist.empty';
}

class AllSongs extends Playlist {
  AllSongs(List<AudioFile> allSongs) : super('Alle Lieder', allSongs);

  @override
  toString() => '$AllSongs()';
}

class FavoriteSongs extends Playlist {
  FavoriteSongs(List<AudioFile> favoriteSongs, {super.addSong, super.removeSong}) : super('Favoriten', favoriteSongs);

  @override
  toString() => '$FavoriteSongs()';
}

class Album extends Playlist {
  // TODO: it.artist might contain multiple artists comma separated -- handle this properly!
  Album(super.name, super.songs) : super(upperTitle: songs.map((it) => it.artist).removeDuplicates().join(', '));

  String get kuenstler => upperTitle;
}

class KuenstlerSongs extends Playlist {
  KuenstlerSongs(super.name, super.songs) : super(upperTitle: 'Alle Lieder von');

  String get kuenstler => name;
}

class ManuallyCreatedPlaylist extends Playlist {
  ManuallyCreatedPlaylist(super.name, super.songs, {super.setName, super.addSong, super.removeSong, super.delete});
}

class PlayASongPlaylist extends Playlist {
  PlayASongPlaylist(Song song) : super('', [song]);

  @override
  toString() {
    return '$PlayASongPlaylist($first)';
  }
}

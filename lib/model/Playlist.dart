import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../env.dart';
import '../utils.dart';
import 'AudioFile.dart';
import 'Song.dart';

abstract class Playlist with IterableMixin<Song> {
  static final empty = _EmptyPlaylist();

  Playlist(this.name, Iterable<Song> songs, {this.upperTitle = '', this.setName, this.addSong, this.removeSong, this.delete})
    : _songs = UnmodifiableListView(songs.toList(growable: false)),
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

  ({int playlistIndex, int playOrderIndex})? indexesOf(AudioFile song) {
    final playlistIndex = _songs.indexOf(song);
    if (playlistIndex < 0) {
      return null;
    } else {
      return (playlistIndex: playlistIndex, playOrderIndex: playOrder.indexOf(playlistIndex));
    }
  }

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

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

@immutable
class AudioFileList extends UnmodifiableListView<AudioFile> {
  AudioFileList(super._source);
}

class _EmptyPlaylist extends Playlist {
  static final _instance = _EmptyPlaylist._();

  factory _EmptyPlaylist() => _instance;

  _EmptyPlaylist._() : super('', []);

  @override
  toString() => 'Playlist.empty';

  @override
  bool operator ==(Object other) => other is _EmptyPlaylist;

  @override
  int get hashCode => 0;
}

class AlleLieder extends Playlist {
  AlleLieder(List<AudioFile> allSongs) : super('Alle Lieder', allSongs);

  @override
  toString() => '$AlleLieder()';

  @override
  bool operator ==(Object other) => other is AlleLieder;

  @override
  int get hashCode => -1;
}

class Favoriten extends Playlist {
  Favoriten(List<AudioFile> favoriteSongs, {super.addSong, super.removeSong}) : super('Favoriten', favoriteSongs);

  @override
  toString() => '$Favoriten()';

  @override
  bool operator ==(Object other) => other is Favoriten;

  @override
  int get hashCode => -2;
}

class Album extends Playlist {
  factory Album.fromNameAndSongs(String name, List<Song> songs) {
    final kuenstler = logic.determineAlbumKuenstlerHeuristic(songs);
    return Album._(name, songs, upperTitle: kuenstler);
  }

  Album._(super.name, super.songs, {required super.upperTitle});

  String get kuenstler => upperTitle;

  @override
  bool operator ==(Object other) => other is Album && name == other.name && kuenstler == other.kuenstler;

  @override
  int get hashCode => Object.hash(name, kuenstler);
}

class KuenstlerSongs extends Playlist {
  KuenstlerSongs(super.name, super.songs) : super(upperTitle: 'Alle Lieder von');

  String get kuenstler => name;

  @override
  bool operator ==(Object other) => other is KuenstlerSongs && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class ManuallyCreatedPlaylist extends Playlist {
  ManuallyCreatedPlaylist(this.id, super.name, super.songs, {super.setName, super.addSong, super.removeSong, super.delete});

  final int id;

  @override
  bool operator ==(Object other) => other is ManuallyCreatedPlaylist && id == other.id;

  @override
  int get hashCode => id;
}

class PlayASongPlaylist extends Playlist {
  PlayASongPlaylist(Song song) : super('', [song]);

  @override
  toString() {
    return '$PlayASongPlaylist($first)';
  }

  @override
  bool operator ==(Object other) => other is PlayASongPlaylist && first == other.first;

  @override
  int get hashCode => first.hashCode;
}

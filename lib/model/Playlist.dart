import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../env.dart';
import '../utils.dart';
import 'AudioFile.dart';
import 'Song.dart';

abstract class Playlist with IterableMixin<Song> {
  Playlist(this.name, Iterable<Song> songs, {this.upperTitle = '', this.addSong, this.removeSong})
    : _songs = UnmodifiableListView(songs.toList(growable: false)),
      duration = Duration(milliseconds: songs.fold(0, (total, file) => total + file.durationInMilliseconds));

  final String upperTitle;
  final String name;
  final List<Song> _songs;
  final Duration duration;

  final FutureOr<void> Function(Song song)? addSong;
  final FutureOr<void> Function(Song song)? removeSong;

  @override
  Iterator<Song> get iterator => _songs.iterator;

  Song get firstSong {
    if (isEmpty) {
      throw StateError('$this is empty');
    } else {
      return this[0];
    }
  }

  Song get lastSong {
    if (isEmpty) {
      throw StateError('$this is empty');
    } else {
      return this[length - 1];
    }
  }

  @override
  int get length => _songs.length;

  Song operator [](int index) => _songs[index];

  int indexOf(Song song) => _songs.indexOf(song);

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
  ManuallyCreatedPlaylist(this.id, super.name, super.songs, {super.addSong, super.removeSong, required this.setName, required this.delete});

  final int id;
  final FutureOr<void> Function(String name) setName;
  final FutureOr<void> Function() delete;

  @override
  bool operator ==(Object other) => other is ManuallyCreatedPlaylist && id == other.id;

  @override
  int get hashCode => id;
}

class Wiedergabeliste extends Playlist {
  Wiedergabeliste(Iterable<Song> songs) : super('', songs);

  @override
  bool operator ==(Object other) => other is Wiedergabeliste && const IterableEquality().equals(this, other);

  @override
  int get hashCode => const IterableEquality().hash(this);
}

import '../model/Playlist.dart';
import '../utils.dart';

extension PlaylistUIExtension on Playlist {
  String get displaySubtitle =>
      switch (length) {
        0 =>
        switch (this) {
          AlleLieder() => 'keine Lieder gefunden',
          Favoriten() => 'noch keine Favoriten ausgewählt',
          _ => 'keine Lieder ausgewählt',
        },
        1 => '1 Lied (${formatPlaylistDuration(duration)})',
        _ => '$length Lieder (${formatPlaylistDuration(duration)})'
      };
}
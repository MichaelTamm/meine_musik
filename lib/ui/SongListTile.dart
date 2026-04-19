import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/theme.dart';
import 'package:meine_musik/ui/Thumbnail.dart';

import '../model/Playlist.dart';
import '../model/Song.dart';
import '../riverpod/player_state.dart';
import '../utils.dart';

class SongListTile extends ConsumerWidget {
  const SongListTile(this.song, this.playlist);

  final Playlist playlist;
  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentSong = ref.watch(currentSongProvider.select((it) => it.id == song.id));
    final textTheme = TextTheme.of(context);
    return ListTile(
      selectedTileColor: selectedSongBackground,
      selected: isCurrentSong,
      contentPadding: EdgeInsets.only(left: 8, right: 8),
      leading: Thumbnail.forSong(song),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(song.artist, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(
            playlist is Album ? '${song.trackNumber}. ${song.title}' : song.title,
            style: textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      subtitle: Text(formatSongDuration(Duration(milliseconds: song.durationInMilliseconds))),
      // TODO: display animated playing icon when this is the current song and it is currently being played
      trailing: const Icon(Icons.play_arrow),
      onTap: () {
        debugPrint('Tap on song ${song.fileName} -- playing file ...');
        ref.read(playerProvider).playSong(song);
      },
    );
  }
}

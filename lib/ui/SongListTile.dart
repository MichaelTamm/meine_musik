import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meine_musik/env.dart';
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
    return Material(
      color: isCurrentSong ? selectedSongBackground : Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 8),
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
        trailing: _SongActions(song),
        onTap: () {
          debugPrint('tap on song ${song.fileName} -- playing file ...');
          ref.read(playerProvider).playSong(song);
        },
      ),
    );
  }
}

class _SongActions extends StatelessWidget {
  const _SongActions(this.song);

  final Song song;

  @override
  Widget build(BuildContext context) {
    final popupMenuButton = PopupMenuButton<void Function()>(
      icon: const Icon(Icons.more_vert_rounded),
      tooltip: 'Popup-Menü mit weiteren Aktionen öffnen',
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.zero,
      itemBuilder: (_) => [
        PopupMenuItem(
          padding: popupMenuItemPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.add), SizedBox(width: 8), Text('zur Wiedergabeliste hinzufügen')],
          ),
          value: () {
            debugPrint("Popup menu item 'zur Wiedergabeliste hinzufügen' selected for $song");
            riverpodContainer.read(playerProvider).enqueueSong(song);
          },
        ),
      ],
      onSelected: (value) => value(),
    );

    return SizedBox(
      width: 72,
      height: 48,
      child: Stack(
        children: [
          Positioned(right: 4, top: 0, child: popupMenuButton),
          Positioned(left: 0, top: 12, child: Icon(Icons.play_arrow_rounded)),
        ],
      ),
    );
  }
}

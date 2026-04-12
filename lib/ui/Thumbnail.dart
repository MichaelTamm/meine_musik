import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/Playlist.dart';
import '../model/Song.dart';
import '../riverpod/media.dart';

class Thumbnail extends ConsumerWidget {
  Thumbnail.forPlaylist(Playlist playlist)
    : load = ((_) => const AsyncData(null)),
      fallback = ((_) => switch (playlist) {
        AlleLieder() => const Icon(Icons.my_library_music, size: 32),
        Favoriten() => const Icon(Icons.favorite, size: 32),
        _ => const Icon(Icons.list, size: 32),
      }),
      super(key: ValueKey(playlist));

  Thumbnail.forAlbum(Album album)
    : load = ((ref) => ref.watch(albumCoverThumbnailProvider(album))),
      fallback = ((_) => const Icon(Icons.album, size: 48)),
      super(key: ValueKey(album));

  Thumbnail.forKuenstler(KuenstlerSongs kuenstlerSongs)
    : load = ((ref) => ref.watch(artistThumbnailProvider(kuenstlerSongs))),
      fallback = ((ref) => Icon(
        ref
            .watch(artistIconProvider(kuenstlerSongs))
            .when(loading: () => Icons.question_mark, data: (icon) => icon, error: (_, _) => Icons.question_mark),
        size: 32,
      )),
      super(key: ValueKey(kuenstlerSongs));

  Thumbnail.forSong(Song song)
    : load = ((ref) => ref.watch(songThumbnailProvider(song))),
      fallback = ((_) => const Icon(Icons.music_note, size: 32)),
      super(key: ValueKey(song));

  final AsyncValue<Uint8List?> Function(WidgetRef ref) load;
  final Widget Function(WidgetRef ref) fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnailAsync = load(ref);
    final colorScheme = ColorScheme.of(context);
    return Container(
      constraints: BoxConstraints.tight(Size.square(56)),
      decoration: BoxDecoration(color: colorScheme.primaryContainer),
      child: thumbnailAsync.when(
        loading: () => fallback(ref),
        data: (thumbnail) => thumbnail == null ? fallback(ref) : Image.memory(thumbnail, fit: BoxFit.cover),
        error: (_, _) => const Icon(Icons.broken_image, size: 48),
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/Playlist.dart';
import '../model/Song.dart';
import '../riverpod/media.dart';

class Thumbnail extends ConsumerWidget {
  Thumbnail.forPlaylist(Playlist playlist)
    : load = ((_) => const AsyncData(null)),
      fallback = (() => switch (playlist) {
        AlleLieder() => const Icon(Icons.my_library_music, size: 32),
        Favoriten() => const Icon(Icons.favorite, size: 32),
        _ => const Icon(Icons.list, size: 32),
      }),
      super(key: ValueKey(playlist));

  Thumbnail.forAlbum(Album album)
    : load = ((ref) => ref.watch(albumCoverProvider(album))),
      fallback = (() => const Icon(Icons.album, size: 48)),
      super(key: ValueKey(album));

  Thumbnail.forArtist(String kuenstler)
    : load = ((ref) => ref.watch(artistImageProvider(kuenstler))),
      fallback = (() => const Icon(Icons.question_mark, size: 32)),
      super(key: ValueKey(kuenstler));

  Thumbnail.forSong(Song song)
    : load = ((ref) => ref.watch(songThumbnailProvider(song))),
      fallback = (() => const Icon(Icons.music_note, size: 32)),
      super(key: ValueKey(song));

  final AsyncValue<Uint8List?> Function(WidgetRef ref) load;
  final Widget Function() fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnailAsync = load(ref);
    final colorScheme = ColorScheme.of(context);
    return Container(
      constraints: BoxConstraints.tight(Size.square(56)),
      decoration: BoxDecoration(color: colorScheme.primaryContainer),
      child: thumbnailAsync.when(
        loading: () => fallback(),
        data: (albumCover) => albumCover == null ? fallback() : Image.memory(albumCover, fit: BoxFit.cover),
        error: (_, _) => const Icon(Icons.broken_image, size: 48),
      ),
    );
  }
}

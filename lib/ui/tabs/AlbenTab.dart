import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../env.dart';
import '../../model/Playlist.dart';
import '../../riverpod/player_state.dart';
import '../../riverpod/playlists.dart';
import '../../theme.dart';
import '../../utils.dart';
import '../LoadingIndicator.dart';
import '../PlaylistActions.dart';
import '../PlaylistView.dart';
import '../Thumbnail.dart';

class AlbenTab extends ConsumerStatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: '$AlbenTab.navigatorKey');

  static final viewDataProvider = FutureProvider<List<Album>>((ref) async {
    final allSongs = await ref.watch(alleLiederProvider.future);
    final songsByAlbumName = allSongs.groupBy((it) => it.album);
    final viewData = <Album>[];
    for (final mapEntry in songsByAlbumName.entries) {
      final name = mapEntry.key;
      // There might be multiple alben with the same name (e.g. "Greatest Hits") -- disambiguate by folder ...
      final songsByDir = mapEntry.value.groupBy((it) => it.dir);
      for (final songs in songsByDir.values) {
        final songs_ = songs.sortBy((it) => it.trackNumber);
        for (int i = 0; i < songs_.length; ++i) {
          final song = songs_[i];
          if (song.trackNumber == 0) {
            song.trackNumber = i + 1;
          }
        }
        viewData.add(Album.fromNameAndSongs(name, songs_));
      }
    }
    ref.keepAlive();
    return viewData;
  }, name: '$AlbenTab.viewDataProvider');

  static final selectedAlbumProvider = StateProvider<Album?>((_) => null, name: '$AlbenTab.selectedAlbumProvider');

  @override
  ConsumerState<AlbenTab> createState() => _AlbenTabState();
}

class _AlbenTabState extends ConsumerState<AlbenTab> with AutomaticKeepAliveClientMixin<AlbenTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // ... needed by AutomaticKeepAliveClientMixin
    final viewDataAsync = ref.watch(AlbenTab.viewDataProvider);
    final selectedAlbum = ref.watch(AlbenTab.selectedAlbumProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, route) {
        if (didPop) {
          return;
        }
        if (selectedAlbum != null) {
          AlbenTab.navigatorKey.currentState?.pop();
        } else {
          // TODO: display Toast: "Drücke die Zurück-Taste noch einmal, um die App zu beenden."
        }
      },
      child: viewDataAsync.when(
        skipLoadingOnRefresh: false,
        loading: LoadingIndicator.new,
        data: (viewData) => Navigator(
          key: AlbenTab.navigatorKey,
          observers: [_UpdateSelectedAlbumObserver(context)],
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(builder: (_) => _AlleAlbenOverview(viewData), settings: settings);
            }
            throw ArgumentError('Unexpected settings: $settings');
          },
        ),
        // TODO: proper error handling
        error: (error, stack) => Container(),
      ),
    );
  }
}

class _UpdateSelectedAlbumObserver extends NavigatorObserver {
  _UpdateSelectedAlbumObserver(this.context);

  final BuildContext context;

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    debugPrint('[$runtimeType] didChangeTop: ${previousTopRoute?.settings} => ${topRoute.settings}');
    Future.microtask(() {
      if (topRoute.settings.name == '/') {
        riverpodContainer.read(AlbenTab.selectedAlbumProvider.notifier).state = null;
      } else {
        final args = topRoute.settings.arguments;
        if (args is Album) {
          riverpodContainer.read(AlbenTab.selectedAlbumProvider.notifier).state = args;
        }
      }
    });
  }
}

class _AlleAlbenOverview extends StatelessWidget {
  const _AlleAlbenOverview(this.data);

  final List<Album> data;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // [UX] Show refresh indicator for 300 ms ...
        await Future.delayed(Duration(milliseconds: 300));
        clearCaches();
      },
      child: ListView.builder(
        // With the default ListView physics, RefreshIndicator won't trigger
        // when the content is shorter than the viewport, therefore ...
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (_, index) {
          final album = data[index];
          return _AlbumListTile(album, onTap: () => openAlbum(album));
        },
      ),
    );
  }

  void openAlbum(Album album) {
    final navigator = AlbenTab.navigatorKey.currentState;
    if (navigator == null) {
      throw StateError('AlbenTab.navigatorKey.currentState == null');
    }
    navigator.push(
      MaterialPageRoute(
        settings: RouteSettings(name: '/${album.kuenstler} - ${album.name}', arguments: album),
        builder: (_) => PlaylistView(album, close: () => AlbenTab.navigatorKey.currentState?.pop()),
      ),
    );
  }
}

class _AlbumListTile extends ConsumerWidget {
  _AlbumListTile(this.album, {required this.onTap}) : super(key: Key('${album.kuenstler} - ${album.name}'));

  final Album album;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (isFullySelected, isPartiallySelected) = ref.watch(
      currentPlaylistProvider.select((it) => (it.containsAllOf(album), it.containsOneOf(album))),
    );
    final textTheme = TextTheme.of(context);
    return ListTile(
      selected: isFullySelected || isPartiallySelected,
      selectedTileColor: isFullySelected ? fullySelectedPlaylistBackground : partiallySelectedPlaylistBackground,
      contentPadding: EdgeInsets.only(left: 8),
      leading: Thumbnail.forAlbum(album),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(album.kuenstler, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(album.name, style: textTheme.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      subtitle: Text(
        switch (album.length) {
          1 => '1 Lied (${formatPlaylistDuration(album.duration)})',
          _ => '${album.length} Lieder (${formatPlaylistDuration(album.duration)})',
        },
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PlaylistActions(album),
      onTap: () {
        debugPrint('Tap on $_AlbumListTile for ${album.name}');
        onTap();
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../env.dart';
import '../../model/Playlist.dart';
import '../../model/Song.dart';
import '../../riverpod/player_state.dart';
import '../../riverpod/playlists.dart';
import '../../theme.dart';
import '../../utils.dart';
import '../LoadingIndicator.dart';
import '../PlaylistActions.dart';
import '../PlaylistView.dart';
import '../Thumbnail.dart';

class KuenstlerTab extends ConsumerStatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: '$KuenstlerTab.navigatorKey');

  static final viewDataProvider = FutureProvider<List<KuenstlerSongs>>((ref) async {
    final allSongs = await ref.watch(alleLiederProvider.future);
    final songsByArtist = <String, List<Song>>{};
    for (final song in allSongs) {
      // A song can be performed by multiple artists, therefore we need to split the `song.artist` songs ...
      for (final artists in logic.splitArtistStringHeuristic(song.artist)) {
        songsByArtist.putIfAbsent(artists, () => []).add(song);
      }
    }
    final viewData = songsByArtist.entries.map((it) => KuenstlerSongs(it.key, it.value)).toList(growable: false);
    viewData.sort((a, b) => a.kuenstler.compareTo(b.kuenstler));
    ref.keepAlive();
    return viewData;
  }, name: '$KuenstlerTab.viewDataProvider');

  static final selectedKuenstlerProvider = StateProvider<KuenstlerSongs?>((_) => null, name: '$KuenstlerTab.selectedKuenstlerProvider');

  @override
  ConsumerState<KuenstlerTab> createState() => _KuenstlerTabState();
}

class _KuenstlerTabState extends ConsumerState<KuenstlerTab> with AutomaticKeepAliveClientMixin<KuenstlerTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // ... needed by AutomaticKeepAliveClientMixin
    final viewDataAsync = ref.watch(KuenstlerTab.viewDataProvider);
    final selectedKuenstler = ref.watch(KuenstlerTab.selectedKuenstlerProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, route) {
        if (didPop) {
          return;
        }
        if (selectedKuenstler != null) {
          KuenstlerTab.navigatorKey.currentState?.pop();
        } else {
          // TODO: display Toast: "Drücke die Zurück-Taste noch einmal, um die App zu beenden."
        }
      },
      child: viewDataAsync.when(
        skipLoadingOnRefresh: false,
        loading: LoadingIndicator.new,
        data: (viewData) => Navigator(
          key: KuenstlerTab.navigatorKey,
          observers: [_UpdateSelectedKuenstlerObserver(context)],
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(builder: (_) => _AlleKuenstlerOverview(viewData), settings: settings);
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

class _UpdateSelectedKuenstlerObserver extends NavigatorObserver {
  _UpdateSelectedKuenstlerObserver(this.context);

  final BuildContext context;

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    debugPrint('[$runtimeType] didChangeTop: ${previousTopRoute?.settings} => ${topRoute.settings}');
    final selectedKuenstlerNotifier = ProviderScope.containerOf(context).read(KuenstlerTab.selectedKuenstlerProvider.notifier);
    Future.microtask(() {
      selectedKuenstlerNotifier.state = topRoute.settings.arguments as KuenstlerSongs?;
    });
  }
}

class _AlleKuenstlerOverview extends StatelessWidget {
  const _AlleKuenstlerOverview(this.data);

  final List<KuenstlerSongs> data;

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
        itemBuilder: (context, index) {
          final kuenstlerSongs = data[index];
          return _KuenstlerListTile(kuenstlerSongs, onTap: () => openKuenstler(kuenstlerSongs));
        },
      ),
    );
  }

  void openKuenstler(KuenstlerSongs kuenstlerSongs) {
    final navigator = KuenstlerTab.navigatorKey.currentState;
    if (navigator == null) {
      throw StateError('KuenstlerTab.navigatorKey.currentState == null');
    }
    navigator.push(
      MaterialPageRoute(
        settings: RouteSettings(name: '/${kuenstlerSongs.kuenstler}', arguments: kuenstlerSongs),
        builder: (_) => PlaylistView(kuenstlerSongs, close: () => KuenstlerTab.navigatorKey.currentState?.pop()),
      ),
    );
  }
}

class _KuenstlerListTile extends ConsumerWidget {
  _KuenstlerListTile(this.kuenstlerSongs, {required this.onTap})
    : kuenstler = kuenstlerSongs.kuenstler,
      super(key: Key(kuenstlerSongs.kuenstler));

  final String kuenstler;
  final KuenstlerSongs kuenstlerSongs;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentPlaylist = ref.watch(currentPlaylistProvider.select((it) => it == kuenstlerSongs));
    return ListTile(
      selectedTileColor: selectedPlaylistBackground,
      selected: isCurrentPlaylist,
      contentPadding: EdgeInsets.only(left: 8),
      leading: Thumbnail.forKuenstler(kuenstlerSongs),
      title: Text(kuenstler, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        switch (kuenstlerSongs.length) {
          1 => '1 Lied (${formatPlaylistDuration(kuenstlerSongs.duration)})',
          _ => '${kuenstlerSongs.length} Lieder (${formatPlaylistDuration(kuenstlerSongs.duration)})',
        },
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PlaylistActions(kuenstlerSongs),
      onTap: () {
        debugPrint('Tap on $_KuenstlerListTile for $kuenstler');
        onTap();
      },
    );
  }
}

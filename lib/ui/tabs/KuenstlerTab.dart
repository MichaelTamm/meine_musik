import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/Playlist.dart';
import '../../model/Song.dart';
import '../../riverpod/playlists.dart';
import '../../theme.dart';
import '../../utils.dart';
import '../LoadingIndicator.dart';

class KuenstlerTab extends ConsumerStatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: '$KuenstlerTab.navigatorKey');

  static final viewDataProvider = FutureProvider<List<KuenstlerSongs>>((ref) async {
    final allSongs = await ref.watch(allSongsProvider.future);
    final songsByArtistName = <String, List<Song>>{};
    for (final song in allSongs) {
      // A song can be performed by multiple artists ...
      for (final artist in song.artist.split(',').map((it) => it.trim())) {
        (songsByArtistName[artist] ??= []).add(song);
      }
    }
    final viewData = <KuenstlerSongs>[];
    for (final mapEntry in songsByArtistName.entries) {
      final kuenstler = mapEntry.key;
      final songs = mapEntry.value.sortBy((it) => it.title);
      viewData.add(KuenstlerSongs(kuenstler, songs));
    }
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
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final kuenstlerSongs = data[index];
        return _KuenstlerListTile(kuenstlerSongs, onTap: () => openKuenstler(kuenstlerSongs));
      },
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
        builder: (_) => _KuenstlerSongsView(kuenstlerSongs),
      ),
    );
  }
}

class _KuenstlerListTile extends ConsumerWidget {
  _KuenstlerListTile(this.songs, {required this.onTap}) : kuenstler = songs.kuenstler, super(key: Key(songs.kuenstler));

  final String kuenstler;
  final KuenstlerSongs songs;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
    final isCurrentPlaylist = ref.watch(currentPlaylistProvider.select((it) => it is Album && it.name == album.name));
    */
    return ListTile(
      selected: false /* TODO: isCurrentPlaylist */,
      contentPadding: EdgeInsets.only(left: 16),
      title: Text(kuenstler, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(switch (songs.length) {
        1 => '1 Lied (${formatPlaylistDuration(songs.duration)})',
        _ => '${songs.length} Lieder (${formatPlaylistDuration(songs.duration)})',
      }),
      trailing: null /* TODO: PlaylistActions(album) */,
      onTap: () {
        debugPrint('Tap on $_KuenstlerListTile for $kuenstler');
        onTap();
      },
    );
  }
}

class _KuenstlerSongsView extends StatelessWidget {
  _KuenstlerSongsView(this.songs) : kuenstler = songs.kuenstler;

  final String kuenstler;
  final KuenstlerSongs songs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          primary: false,
          child: Row(
            children: [
              IconButton(onPressed: () => KuenstlerTab.navigatorKey.currentState?.pop(), icon: Icon(Icons.chevron_left_rounded)),
              Text(
                kuenstler,
                style: TextStyle(color: colorScheme.onSurface.withAlpha(97), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Expanded(child: Placeholder()),
      ],
    );
  }
}

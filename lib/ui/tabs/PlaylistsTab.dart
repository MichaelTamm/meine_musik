import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/Playlist.dart';
import '../../riverpod/player_state.dart';
import '../../riverpod/playlists.dart';
import '../../theme.dart';
import '../../utils.dart';
import '../LoadingIndicator.dart';
import '../PlaylistActions.dart';
import '../PlaylistView.dart';

class PlaylistsTab extends ConsumerStatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: '$PlaylistsTab.navigatorKey');

  static final selectedPlaylistProvider = StateProvider<Playlist?>((_) => null, name: '$PlaylistsTab.selectedPlaylistProvider');

  const PlaylistsTab();

  @override
  ConsumerState<PlaylistsTab> createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends ConsumerState<PlaylistsTab> with AutomaticKeepAliveClientMixin<PlaylistsTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // ... needed by AutomaticKeepAliveClientMixin
    final selectedPlaylist = ref.watch(PlaylistsTab.selectedPlaylistProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, route) {
        if (didPop) {
          return;
        }
        if (selectedPlaylist != null) {
          PlaylistsTab.navigatorKey.currentState?.pop();
        } else {
          // TODO: display Toast: "Drücke die Zurück-Taste noch einmal, um die App zu beenden."
        }
      },
      child: Navigator(
        key: PlaylistsTab.navigatorKey,
        observers: [_UpdateSelectedPlaylistObserver(context)],
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (_) => _AllePlaylistsOverview(), settings: settings);
          }
          throw ArgumentError('Unexpected settings: $settings');
        },
      ),
    );
  }
}

class _UpdateSelectedPlaylistObserver extends NavigatorObserver {
  _UpdateSelectedPlaylistObserver(this.context);

  final BuildContext context;

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    debugPrint('[$runtimeType] didChangeTop: ${previousTopRoute?.settings} => ${topRoute.settings}');
    final selectedPlaylistNotifier = ProviderScope.containerOf(context).read(PlaylistsTab.selectedPlaylistProvider.notifier);
    Future.microtask(() {
      selectedPlaylistNotifier.state = topRoute.settings.arguments as Playlist?;
    });
  }
}

class _AllePlaylistsOverview extends ConsumerWidget {
  const _AllePlaylistsOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsProvider);
    return playlistsAsync.when(
      loading: LoadingIndicator.new,
      data: (playlists) => ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (_, index) {
          final playlist = playlists[index];
          return _PlaylistListTile(playlist, onTap: () => openPlaylist(playlist));
        },
      ),
      // TODO: proper error handling
      // TODO: if permission is not granted, show a meaningful text and a button to request permission
      error: (error, stack) => Container(),
    );
  }

  void openPlaylist(Playlist playlist) {
    final navigator = PlaylistsTab.navigatorKey.currentState;
    if (navigator == null) {
      throw StateError('PlaylistsTab.navigatorKey.currentState == null');
    }
    navigator.push(
      MaterialPageRoute(
        settings: RouteSettings(name: '/${playlist.name}', arguments: playlist),
        builder: (_) => PlaylistView(playlist, close: () => PlaylistsTab.navigatorKey.currentState?.pop()),
      ),
    );
  }
}

class _PlaylistListTile extends ConsumerWidget {
  _PlaylistListTile(this.playlist, {required this.onTap}) : super(key: Key(playlist.name));

  final Playlist playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentPlaylist = ref.watch(currentPlaylistProvider.select((it) => it == playlist));
    return ListTile(
      selectedTileColor: selectedPlaylistBackground,
      selected: isCurrentPlaylist,
      contentPadding: EdgeInsets.only(left: 16),
      title: Text(playlist.name),
      subtitle: Text(switch (playlist.length) {
        0 => switch (playlist) {
          AlleLieder() => 'keine Lieder gefunden',
          Favoriten() => 'noch keine Favoriten ausgewählt',
          _ => 'keine Lieder ausgewählt',
        },
        1 => '1 Lied (${formatPlaylistDuration(playlist.duration)})',
        _ => '${playlist.length} Lieder (${formatPlaylistDuration(playlist.duration)})',
      }),
      trailing: PlaylistActions(playlist),
      onTap: () {
        debugPrint('Tap on $_PlaylistListTile for ${playlist.name}');
        onTap();
      },
    );
  }
}

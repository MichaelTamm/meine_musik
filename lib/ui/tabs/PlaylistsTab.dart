import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meine_musik/ui/Thumbnail.dart';

import '../../env.dart';
import '../../model/Playlist.dart';
import '../../riverpod/player_state.dart';
import '../../riverpod/playlists.dart';
import '../../theme.dart';
import '../../utils.dart';
import '../LoadingIndicator.dart';
import '../PlaylistActions.dart';
import '../PlaylistView.dart';
import '../dialogs/CreatePlaylistDialog.dart';

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
    if (topRoute.settings.name == '/') {
      Future.microtask(() {
        riverpodContainer.read(PlaylistsTab.selectedPlaylistProvider.notifier).state = null;
      });
    } else {
      final args = topRoute.settings.arguments;
      if (args is Playlist) {
        final selectedPlaylistNotifier = ProviderScope.containerOf(context).read(PlaylistsTab.selectedPlaylistProvider.notifier);
        Future.microtask(() {
          selectedPlaylistNotifier.state = args;
        });
      }
    }
  }
}

class _AllePlaylistsOverview extends HookConsumerWidget {
  const _AllePlaylistsOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsProvider);
    final isFABVisibleState = useState<bool>(true);
    final isFABVisible = isFABVisibleState.value;

    if (playlistsAsync.isLoading) {
      return LoadingIndicator();
    }

    if (!playlistsAsync.hasValue) {
      // TODO: proper error handling
      // TODO: if permission is not granted, show a meaningful text and a button to request permission
      return Container();
    }

    final playlists = playlistsAsync.requireValue;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            // [UX] Show refresh indicator for 300 ms ...
            await Future.delayed(Duration(milliseconds: 300));
            clearCaches();
          },
          child: ListView.builder(
            // With the default ListView physics, RefreshIndicator won't trigger
            // when the content is shorter than the viewport, therefore ...
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: playlists.length,
            itemBuilder: (_, index) {
              final playlist = playlists[index];
              return _PlaylistListTile(playlist, onTap: () => openPlaylist(playlist));
            },
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Visibility(
            visible: isFABVisible,
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                try {
                  isFABVisibleState.value = false;
                  await showDialog(context: context, builder: ((_) => CreatePlaylistDialog()));
                } finally {
                  isFABVisibleState.value = true;
                }
              },
            ),
          ),
        ),
      ],
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
  _PlaylistListTile(this.playlist, {required this.onTap})
    : super(key: Key(playlist is ManuallyCreatedPlaylist ? playlist.id.toString() : playlist.name));

  final Playlist playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (isFullySelected, isPartiallySelected) = ref.watch(
      currentPlaylistProvider.select((it) => (playlist.isNotEmpty && it.containsAllOf(playlist), it.containsOneOf(playlist))),
    );
    return ListTile(
      selected: isFullySelected || isPartiallySelected,
      selectedTileColor: isFullySelected ? fullySelectedPlaylistBackground : partiallySelectedPlaylistBackground,
      contentPadding: EdgeInsets.only(left: 8),
      leading: Thumbnail.forPlaylist(playlist),
      title: Text(playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        switch (playlist.length) {
          0 => switch (playlist) {
            AlleLieder() => 'keine Lieder gefunden',
            Favoriten() => 'noch keine Favoriten ausgewählt',
            _ => 'keine Lieder ausgewählt',
          },
          1 => '1 Lied (${formatPlaylistDuration(playlist.duration)})',
          _ => '${playlist.length} Lieder (${formatPlaylistDuration(playlist.duration)})',
        },
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PlaylistActions(playlist),
      onTap: () {
        debugPrint('Tap on $_PlaylistListTile for ${playlist.name}');
        onTap();
      },
    );
  }
}

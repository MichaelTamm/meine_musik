import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meine_musik/ui/player_widget/PlayerWidget.dart';

import '../env.dart';
import '../hooks.dart';
import '../navigation.dart';
import '../riverpod/player_state.dart';
import '../theme.dart';
import 'FileManager.dart';
import 'tabs/AlbenTab.dart';
import 'tabs/KuenstlerTab.dart';
import 'tabs/OrdnerTab.dart';
import 'tabs/PlaylistsTab.dart';

class MeineMusikApp extends StatelessWidget {
  const MeineMusikApp({this.riverpodOverrides = const []});

  final List<Override> riverpodOverrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: riverpodOverrides,
      observers: [riverpodObserver],
      child: MaterialApp(
        title: 'Meine Musik',
        theme: themeData,
        debugShowCheckedModeBanner: false,
        navigatorKey: appNavigatorKey,
        home: _MeineMusikScaffoldWrapper(),
      ),
    );
  }
}

class _MeineMusikScaffoldWrapper extends HookConsumerWidget {
  const _MeineMusikScaffoldWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnMount(() {
      riverpodContainer = ProviderScope.containerOf(context);
      audioHandler.init(); // ... must be called *after* riverpodContainer was initialized
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          // Set the status bar color to match the AppBar background color
          statusBarColor: Theme.of(context).colorScheme.inversePrimary,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
      // Preload view data of hidden tabs for a smooth tab switch animation ...
      ref.read(AlbenTab.viewDataProvider);
      ref.read(KuenstlerTab.viewDataProvider);
      ref.read(OrdnerTab.thisDeviceProvider);
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('[$runtimeType] onPopInvokedWithResult($didPop, $result)');
        // TODO: display Toast: "Drücke die Zurück-Taste noch einmal, um die App zu beenden."
      },
      child: DefaultTabController(length: 4, child: _MeineMusikScaffold()),
    );
  }
}

const _tabNames = ['Playlists', 'Alben', 'Künstler', 'Ordner'];

class _MeineMusikScaffold extends HookConsumerWidget {
  const _MeineMusikScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlaylist = ref.watch(currentPlaylistProvider);
    final tabController = DefaultTabController.of(context);
    final currentTabRef = useRef(tabController.index);

    useEffect(() {
      void listener() {
        if (currentTabRef.value != tabController.index) {
          debugPrint("[$runtimeType] switching to tab '${_tabNames[tabController.index]}'");
          currentTabRef.value = tabController.index;
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    Widget ordnerTab = Tab(icon: Icon(Icons.folder_rounded), text: 'Ordner');
    if (kDebugMode) {
      ordnerTab = GestureDetector(
        onLongPress: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FileManager())),
        child: ordnerTab,
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: null,
          titleSpacing: 0,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.library_music_rounded), text: 'Playlists'),
              Tab(icon: Icon(Icons.album_rounded), text: 'Alben'),
              Tab(icon: Icon(Icons.group_rounded), text: 'Künstler'),
              ordnerTab,
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(child: TabBarView(children: [PlaylistsTab(), AlbenTab(), KuenstlerTab(), OrdnerTab()])),
            if (currentPlaylist.isNotEmpty) const PlayerWidget(),
          ],
        ),
      ),
    );
  }
}

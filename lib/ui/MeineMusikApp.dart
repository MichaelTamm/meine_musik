import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../env.dart';
import '../hooks.dart';
import '../navigation.dart';
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
      observers: [_riverpodObserver],
      child: MaterialApp(
        title: 'Meine Musik',
        theme: themeData,
        debugShowCheckedModeBanner: false,
        navigatorKey: appNavigatorKey,
        home: SafeArea(child: _MeineMusikScaffoldWrapper()),
      ),
    );
  }
}

class _MeineMusikScaffoldWrapper extends HookWidget {
  const _MeineMusikScaffoldWrapper();

  @override
  Widget build(BuildContext context) {
    useOnMount(() {
      riverpodContainer.context = context;
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          // Set the status bar color to match the AppBar background color
          statusBarColor: Theme.of(context).colorScheme.inversePrimary,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('[_MeineMusikScaffoldWrapper] onPopInvokedWithResult($didPop, $result)');
        // TODO: display Toast: "Drücke die Zurück-Taste noch einmal, um die App zu beenden."
      },
      child: DefaultTabController(length: 4, child: _MeineMusikScaffold()),
    );
  }
}

class _MeineMusikScaffold extends HookConsumerWidget {
  const _MeineMusikScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = DefaultTabController.of(context);
    final currentTabState = useState(tabController.index);
    final currentTab = currentTabState.value;

    useEffect(() {
      void listener() {
        if (currentTabState.value != tabController.index) {
          debugPrint('[_MeineMusikScaffold] currentTabState.value = ${tabController.index}');
          currentTabState.value = tabController.index;
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

    return Scaffold(
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
          Expanded(
            child: Stack(
              children: [
                TabBarView(children: [PlaylistsTab(), AlbenTab(), KuenstlerTab(), OrdnerTab()]),
                if (currentTab == 0)
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: FloatingActionButton.small(
                      tooltip: 'Playlist hinzufügen',
                      elevation: 0,
                      onPressed: () {
                        /* TODO: showDialog(context: context, builder: ((_) => CreatePlaylistDialog())) */
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
              ],
            ),
          ),
          // TODO: if (currentPlaylist.isNotEmpty) const PlayerWidget(),
        ],
      ),
    );
  }
}

final class _RiverpodObserver extends ProviderObserver {
  static const _blacklist = {'currentSongPositionProvider'};

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (!kDebugRiverpod) {
      return;
    }
    final p = _providerToString(context.provider);
    if (_blacklist.contains(p)) {
      return;
    }
    final v = _valueToString(value);
    debugPrint('[riverpod] $p added, initial value: $v');
  }

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    if (!kDebugRiverpod) {
      return;
    }
    final p = _providerToString(context.provider);
    debugPrintStack(label: '[riverpod] $p failed: $error', stackTrace: stackTrace);
  }

  @override
  void didUpdateProvider(ProviderObserverContext context, Object? oldValue, Object? newValue) {
    if (!kDebugRiverpod) {
      return;
    }
    final p = _providerToString(context.provider);
    if (_blacklist.contains(p)) {
      return;
    }
    final v1 = _valueToString(oldValue);
    final v2 = _valueToString(newValue);
    debugPrint('[riverpod] $p updated: $v1 => $v2');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    if (!kDebugRiverpod) {
      return;
    }
    final p = _providerToString(context.provider);
    if (_blacklist.contains(p)) {
      return;
    }
    debugPrint('[riverpod] $p disposed');
  }

  String _providerToString(ProviderBase provider) {
    final name = provider.name ?? provider.runtimeType.toString();
    return provider.argument == null ? name : '$name(${provider.argument})';
  }

  String _valueToString(Object? value) {
    if (value == null) {
      return 'null';
    }
    if (value is bool || value is num || value is DateTime) {
      return value.toString();
    }
    if (value is String) {
      final i = value.indexOf('\n');
      return jsonEncode(i >= 0 ? value.substring(0, i) : value);
    }
    final s = value.toString();
    final i = s.indexOf('\n');
    return i > 0 ? '${s.substring(0, i)}...' : s;
  }
}

final _riverpodObserver = _RiverpodObserver();

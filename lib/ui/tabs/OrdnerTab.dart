import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meine_musik/model/IsSongPredicate.dart';
import 'package:meine_musik/utils.dart';

import '../../env.dart';
import '../../model/AudioFile.dart';
import '../../model/AudioFolder.dart';
import '../../riverpod/media.dart';
import '../../riverpod/player_state.dart';
import '../../riverpod/playlists.dart';
import '../LoadingIndicator.dart';

class OrdnerTab extends ConsumerStatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: '$OrdnerTab.navigatorKey');

  /// All audio files on the device.
  static final thisDeviceProvider = FutureProvider<AudioFolder>((ref) async {
    final audioFiles = await ref.watch(localAudioFilesProvider.future);
    final root = logic.groupAudioFiles(audioFiles);
    ref.keepAlive();
    return root;
  }, name: '$OrdnerTab.thisDeviceProvider');

  static final currentPathProvider = StateProvider<List<AudioFolder>>((_) => [], name: '$OrdnerTab.currentPathProvider');

  const OrdnerTab({super.key});

  @override
  ConsumerState<OrdnerTab> createState() => _OrdnerTabState();
}

class _OrdnerTabState extends ConsumerState<OrdnerTab> with AutomaticKeepAliveClientMixin<OrdnerTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // ... needed by AutomaticKeepAliveClientMixin
    final currentPath = ref.watch(OrdnerTab.currentPathProvider);

    void openFolder(AudioFolder folder, AudioFolder? parent) {
      final navigator = OrdnerTab.navigatorKey.currentState;
      if (navigator == null) {
        throw StateError('OrdnerTab.navigatorKey.currentState == null');
      }
      List<AudioFolder> newCurrentPath;
      if (parent == null) {
        newCurrentPath = [folder];
      } else {
        final currentPath = ref.read(OrdnerTab.currentPathProvider);
        final i = currentPath.indexOf(parent);
        if (i < 0) {
          throw Exception('Parent folder ${parent.name} not found in currentPath: [${currentPath.map((it) => it.name).join(', ')}]');
        }
        newCurrentPath = [...currentPath.sublist(0, i + 1), folder];
      }
      navigator.push(
        MaterialPageRoute(
          settings: RouteSettings(name: '/${newCurrentPath.map((it) => it.name).join('/')}', arguments: newCurrentPath),
          builder: (_) => _AudioFolderView(folder, openFolder),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, route) {
        if (didPop) {
          return;
        }
        if (currentPath.isNotEmpty) {
          OrdnerTab.navigatorKey.currentState?.pop();
        } else {
          // TODO: display Toast: "Drücke die Zurück-Taste noch einmal, um die App zu beenden."
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OrdnerTabNavigationBar(
            currentPath,
            goBackToFolder: (folder) {
              if (folder == null) {
                OrdnerTab.navigatorKey.currentState?.popUntil((it) => it.settings.name == '/');
              } else {
                OrdnerTab.navigatorKey.currentState?.popUntil((it) => (it.settings.arguments as List<AudioFolder>).last == folder);
              }
            },
          ),
          Expanded(
            child: Navigator(
              key: OrdnerTab.navigatorKey,
              observers: [_UpdateCurrentPathObserver(context)],
              initialRoute: '/',
              onGenerateRoute: (settings) {
                if (settings.name == '/') {
                  return MaterialPageRoute(builder: (_) => _AudioFolderView(null, openFolder), settings: settings);
                }
                throw ArgumentError('Unexpected settings: $settings');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateCurrentPathObserver extends NavigatorObserver {
  _UpdateCurrentPathObserver(this.context);

  final BuildContext context;

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    debugPrint('[$runtimeType] didChangeTop: ${previousTopRoute?.settings} => ${topRoute.settings}');
    final currentPathNotifier = ProviderScope.containerOf(context).read(OrdnerTab.currentPathProvider.notifier);
    Future.microtask(() {
      final settings = topRoute.settings;
      if (settings.name == '/') {
        currentPathNotifier.state = const [];
      } else {
        final args = settings.arguments;
        if (args is List<AudioFolder>) {
          currentPathNotifier.state = args;
        }
      }
    });
  }
}

@visibleForTesting
class OrdnerTabNavigationBar extends StatelessWidget {
  const OrdnerTabNavigationBar(this.currentPath, {required this.goBackToFolder});

  final List<AudioFolder> currentPath;
  final Function(AudioFolder? folder) goBackToFolder;

  @override
  Widget build(BuildContext context) {
    final lastIndex = currentPath.length - 1;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      primary: false,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: TextButton(
              onPressed: currentPath.isEmpty
                  ? null
                  : () {
                      debugPrint("[$runtimeType] tap on 'Dieses Gerät'");
                      goBackToFolder(null);
                    },
              child: Text('Dieses Gerät'),
            ),
          ),
          ...currentPath.expandIndexed(
            (folder, index) => [
              const Icon(Icons.chevron_right_rounded),
              TextButton(
                onPressed: index == lastIndex
                    ? null
                    : () {
                        debugPrint("[$runtimeType] tap on folder ${toDartString(folder.name)}");
                        goBackToFolder(folder);
                      },
                child: Text(folder.name),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _thisDeviceKey = ValueKey('Dieses Gerät');

class _AudioFolderView extends ConsumerWidget {
  _AudioFolderView(this.folder, this.openFolder) : super(key: folder == null ? _thisDeviceKey : GlobalObjectKey(folder));

  final AudioFolder? folder;
  final Function(AudioFolder folder, AudioFolder? parent) openFolder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folder_ = folder;
    final folderAsync = folder_ == null ? ref.watch(OrdnerTab.thisDeviceProvider) : AsyncData(folder_);
    return folderAsync.when(
      skipLoadingOnRefresh: false,
      loading: LoadingIndicator.new,
      data: (folder) {
        final numFolders = folder.subfolders.length;
        final numFiles = folder.files.length;
        return RefreshIndicator(
          onRefresh: () async {
            // [UX] Show refresh indicator for 300 ms ...
            await Future.delayed(Duration(milliseconds: 300));
            clearCaches();
            OrdnerTab.navigatorKey.currentState!.popUntil((it) => it.settings.name == '/');
          },
          child: ListView.builder(
            // With the default ListView physics, RefreshIndicator won't trigger
            // when the content is shorter than the viewport, therefore ...
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: numFolders + numFiles,
            itemBuilder: (context, index) {
              if (index < numFolders) {
                final subfolder = folder.subfolders[index];
                return _AudioFolderListTile(subfolder, onTap: () => openFolder(subfolder, this.folder));
              }
              index -= numFolders;
              final file = folder.files[index];
              return _AudioFileListTile(file);
            },
          ),
        );
      },
      // TODO: if permission is not granted, show a meaningful text and a button to request permission
      error: (error, stack) => Container(),
    );
  }
}

enum _FolderState {
  loading,

  /// All audio files in the folder and its subfolders are songs.
  allSongs,

  /// Some audio files in the folder and its subfolders are songs, some are not.
  someSongs,

  /// No audio file in the folder and its subfolders is a song.
  noSongs,
}

class _AudioFolderListTile extends HookConsumerWidget {
  _AudioFolderListTile(this.folder, {required this.onTap}) : super(key: Key(folder.name));

  final AudioFolder folder;
  final VoidCallback onTap;

  /// Resolves to `true` if all audio files in the given folder and its subfolders are songs,
  /// resolves to `false` if no audio file in the given folder and its subfolders is a song,
  /// resolves to `null` if there at least one song and one non-song audio file was found.
  _FolderState _getFolderState(AudioFolder folder, IsSongPredicate isSongPredicate) {
    var foundSongFile = false;
    var foundNonSongFile = false;
    for (final subfolder in folder.subfolders) {
      final subfolderState = _getFolderState(subfolder, isSongPredicate);
      if (subfolderState == _FolderState.someSongs) {
        return _FolderState.someSongs;
      } else if (subfolderState == _FolderState.noSongs) {
        if (foundSongFile) {
          return _FolderState.someSongs;
        } else {
          foundNonSongFile = true;
        }
      } else if (subfolderState == _FolderState.allSongs) {
        if (foundNonSongFile) {
          return _FolderState.someSongs;
        } else {
          foundSongFile = true;
        }
      } else {
        // Should never happen.
        throw Exception('Unexpected value for subfolderState: $subfolderState');
      }
    }
    for (final file in folder.files) {
      if (isSongPredicate(file)) {
        if (foundNonSongFile) {
          return _FolderState.someSongs;
        } else {
          foundSongFile = true;
        }
      } else {
        if (foundSongFile) {
          return _FolderState.someSongs;
        } else {
          foundNonSongFile = true;
        }
      }
    }
    if (foundSongFile && foundNonSongFile) {
      return _FolderState.someSongs;
    } else if (foundSongFile) {
      return _FolderState.allSongs;
    } else if (foundNonSongFile) {
      return _FolderState.noSongs;
    } else {
      // Should never happen, because there should be no empty folder ...
      throw Exception(
        'subfolders: ${folder.subfolders.length}, files: ${folder.files.length}, foundSongFile: $foundSongFile, foundNonSongFile: $foundNonSongFile',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSongPredicate = ref.watch(isSongPredicateProvider).unwrapPrevious().value;
    final folderState = useMemoized(() {
      if (isSongPredicate == null) {
        return _FolderState.loading;
      }
      return _getFolderState(folder, isSongPredicate);
    }, [folder, isSongPredicate]);
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 2, right: 10),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: folderState != _FolderState.loading,
            child: Checkbox(
              value: switch (folderState) {
                _FolderState.allSongs => true,
                _FolderState.noSongs => false,
                _ => null,
              },
              onChanged: (_) {
                if (folderState == _FolderState.allSongs) {
                  debugPrint('[$runtimeType] Tap on checkbox for folder ${folder.name} -- blacklisting folder ...');
                  blacklistFolder(folder, ref);
                } else {
                  debugPrint('Tap on checkbox for folder ${folder.name} -- whitelisting folder ...');
                  whitelistFolder(folder, ref);
                }
              },
              tristate: true,
            ),
          ),
          const Icon(Icons.folder_rounded),
        ],
      ),
      title: Text(folder.name),
      trailing: Icon(Icons.chevron_right_rounded),
      onTap: () {
        debugPrint('Tap on $_AudioFolderListTile of folder: ${folder.name}');
        onTap();
      },
    );
  }
}

enum _FileState { loading, song, notSong }

class _AudioFileListTile extends HookConsumerWidget {
  _AudioFileListTile(this.file) : super(key: Key(file.fileName));

  final AudioFile file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSongPredicate = ref.watch(isSongPredicateProvider).unwrapPrevious().value;
    final fileState = useMemoized(() {
      if (isSongPredicate == null) {
        return _FileState.loading;
      }
      return isSongPredicate(file) ? _FileState.song : _FileState.notSong;
    }, [file, isSongPredicate]);
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 2, right: 10),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: fileState != _FileState.loading,
            child: Checkbox(
              value: switch (fileState) {
                _FileState.song => true,
                _FileState.notSong => false,
                _ => null,
              },
              onChanged: (_) {
                if (fileState == _FileState.song) {
                  debugPrint('Tap on checkbox for file ${file.fileName} -- blacklisting file ...');
                  blacklistFile(file, ref);
                } else if (fileState == _FileState.notSong) {
                  debugPrint('Tap on checkbox for file ${file.fileName} -- whitelisting file ...');
                  whitelistFile(file, ref);
                } else {
                  // Should never happen, because the checkbox is only visible if fileState is not loading.
                  debugPrint('Tap on checkbox for file ${file.fileName} -- ignoring tap');
                }
              },
              tristate: true,
            ),
          ),
          const Icon(Icons.audio_file_rounded),
        ],
      ),
      title: Text(file.fileName),
      subtitle: Text('${file.artist} • ${file.title}'),
      trailing: const Icon(Icons.play_arrow_rounded),
      onTap: () {
        debugPrint('Tap on $_AudioFileListTile for file ${file.fileName}');
        ref.read(playerProvider).playSong(file);
      },
    );
  }
}

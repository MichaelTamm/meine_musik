import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartx/dartx.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meine_musik/ui/FileViewer.dart';
import 'package:path_provider/path_provider.dart';

import '../env.dart';
import '../model/Date.dart';
import 'DeletableListTile.dart';

class FileManager extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dataDirNotifier = useState<Directory?>(null);
    final supportDirNotifier = useState<Directory?>(null);
    final tempDirNotifier = useState<Directory?>(null);
    final currentDirNotifier = useState<Directory?>(null);
    final dirsNotifier = useState<List<Directory>>([]);
    final filesNotifier = useState<List<File>>([]);

    void changeDir(Directory? dir) {
      debugPrint('[$FileManager]: changeDir($dir)');
      currentDirNotifier.value = dir;
      if (dir == null) {
        final dataDir = dataDirNotifier.value;
        final supportDir = supportDirNotifier.value;
        final tempDir = tempDirNotifier.value;
        currentDirNotifier.value = null;
        dirsNotifier.value = [if (dataDir != null) dataDir, if (supportDir != null) supportDir, if (tempDir != null) tempDir];
        filesNotifier.value = [];
      } else {
        try {
          final a = dir.listSync();
          dirsNotifier.value = a.whereType<Directory>().sortedBy((it) => it.name);
          filesNotifier.value = a.whereType<File>().sortedBy((it) => it.name);
        } catch (error, stack) {
          debugPrintStack(label: '$error', stackTrace: stack);
          dirsNotifier.value = [];
          filesNotifier.value = [];
        }
      }
    }

    useEffect(() {
      (() async {
        try {
          dataDirNotifier.value = await getApplicationDocumentsDirectory();
          supportDirNotifier.value = await getApplicationSupportDirectory();
          tempDirNotifier.value = await getTemporaryDirectory();
          if (currentDirNotifier.value == null) {
            changeDir(null);
          }
        } catch (error, stack) {
          debugPrintStack(label: '$error', stackTrace: stack);
        }
      })();
      return null;
    }, []);

    final dataDir = dataDirNotifier.value;
    final supportDir = supportDirNotifier.value;
    final tempDir = tempDirNotifier.value;
    final currentDir = currentDirNotifier.value;
    final dirs = dirsNotifier.value;
    final files = filesNotifier.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Dateien')),
      body: ListTileTheme(
        dense: true,
        child: RefreshIndicator(
          onRefresh: () async {
            // [UX] Show refresh indicator for 300 ms ...
            await Future.delayed(Duration(milliseconds: 300));
            changeDir(currentDir);
          },
          child: ListView.builder(
            itemCount: 1 + dirs.length + files.length,
            itemBuilder: (_, index) {
              if (index == 0) {
                if (currentDir == null) {
                  return ListTile(
                    leading: Icon(Icons.table_chart_outlined),
                    title: const Text('Database'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DriftDbViewer(db))),
                  );
                }
                return ListTile(
                  leading: Icon(Icons.folder_open_rounded),
                  title: const Text('..'),
                  onTap: () {
                    final dataDir = dataDirNotifier.value;
                    final supportDir = supportDirNotifier.value;
                    final tempDir = tempDirNotifier.value;
                    if (currentDir.path == dataDir?.path || currentDir.path == supportDir?.path || currentDir.path == tempDir?.path) {
                      changeDir(null);
                    } else {
                      changeDir(currentDir.parent);
                    }
                  },
                );
              }
              index -= 1;
              if (currentDir == null) {
                final dir = dirs[index];
                return ListTile(
                  leading: Icon(Icons.folder_open_rounded),
                  title: AutoSizeText(
                    dir.path == dataDir?.path
                        ? 'Application Documents Directory'
                        : dir.path == supportDir?.path
                        ? 'Application Support Directory'
                        : dir.path == tempDir?.path
                        ? 'Temporary Directory'
                        : '???',
                    maxLines: 1,
                    minFontSize: 3,
                  ),
                  onTap: () => changeDir(dir),
                );
              }
              if (index < dirs.length) {
                final dir = dirs[index];
                return DeletableListTile(
                  key: Key(dir.name),
                  leading: Icon(Icons.folder_open_rounded),
                  title: AutoSizeText(dir.name, maxLines: 1, minFontSize: 3),
                  onTap: () => changeDir(dir),
                  onDelete: () {
                    dir.deleteSync(recursive: true);
                    dirsNotifier.value = currentDir.listSync().whereType<Directory>().sortedBy((it) => it.name);
                  },
                );
              }
              index -= dirs.length;
              final file = files[index];
              return DeletableListTile(
                key: Key(file.name),
                title: AutoSizeText(file.name, maxLines: 1, minFontSize: 3),
                trailing: Text('${_formatFileSize(file.lengthSync())}, ${_formatLastModified(file.lastModifiedSync())}'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FileViewer(file))),
                onDelete: () {
                  file.deleteSync();
                  filesNotifier.value = currentDir.listSync().whereType<File>().sortedBy((it) => it.name);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

extension on FileSystemEntity {
  String get name => path.substring(path.lastIndexOf('/') + 1);
}

String _formatFileSize(int size) {
  if (size <= 0) {
    return '0 Bytes';
  } else if (size == 1) {
    return '1 Byte';
  } else if (size < 10000) {
    return '$size Bytes';
  } else if (size < 10000000) {
    return '${(size / 1000).round()} KB';
  } else {
    return '${(size / 1000000).round()} MB';
  }
}

String _formatLastModified(DateTime lastModified) {
  if (lastModified.isUtc) {
    lastModified = lastModified.toLocal();
  }
  final time = '${lastModified.hour.toString().padLeft(2, '0')}:${lastModified.minute.toString().padLeft(2, '0')}';
  final today = Date.today();
  final date = Date.fromDateTime(lastModified);
  if (date == today) {
    return 'Heute, $time';
  } else if (date == today.previousDay) {
    return 'Gestern, $time';
  } else {
    return '${date.day}.${date.month}.${date.year}, $time';
  }
}

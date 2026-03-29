import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/model/AudioFile.dart';
import 'package:meine_musik/model/AudioFolder.dart';
import 'package:meine_musik/services/MusicBrainz.dart';

import '../RecordPlaybackHttpClient.dart';
import '../testdata.dart';

void main() {

  test('groupAudioFiles', () {
    final audioFiles = [
      '/storage/emulated/0/Samsung/Music/Over the Horizon.mp3',
      '/storage/emulated/0/myrecording.mp3',
      '/storage/emulated/0/WhatsApp/Media/WhatsApp Audio/AUD-20191203-WA0000.mp3',
      '/storage/0000-0000/Voice Recorder/Sprache 001_sd.m4a',
      '/storage/emulated/0/WhatsApp/Media/WhatsApp Audio/AUD-20200302-WA0000.mp3',
      '/storage/0000-0000/Voice Recorder/Sprache 002_sd.m4a',
      '/storage/emulated/0/WhatsApp/Media/WhatsApp Audio/AUD-20210219-WA0001.mp3',
      '/storage/emulated/0/WhatsApp/Media/WhatsApp Documents/Spreeradio 105.5 . 2021-05-07 - Interview mit Bernd Hahn',
      '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/01 - Alicia Keys - Piano & I.mp3',
      '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/02 - Alicia Keys - Girlfriend.mp3',
      '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/03 - Alicia Keys - How Come You Don\'t Call Me.mp3',
      '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/04 - Alicia Keys - Fallin\'.mp3',
      '/storage/0000-0000/Musik/Alicia Keys - Songs In A Minor/05 - Alicia Keys - Troubles.mp3',
    ].map((path) => anAudioFile(path: path)).toList();
    expect(logic.groupAudioFiles(audioFiles).prettyPrint(), '''
Dieses Gerät
├── Musik
│   └── Alicia Keys - Songs In A Minor
│       ├── 01 - Alicia Keys - Piano & I.mp3
│       ├── 02 - Alicia Keys - Girlfriend.mp3
│       ├── 03 - Alicia Keys - How Come You Don't Call Me.mp3
│       ├── 04 - Alicia Keys - Fallin'.mp3
│       └── 05 - Alicia Keys - Troubles.mp3
├── Samsung
│   └── Music
│       └── Over the Horizon.mp3
├── Voice Recorder
│   ├── Sprache 001_sd.m4a
│   └── Sprache 002_sd.m4a
├── WhatsApp
│   └── Media
│       ├── WhatsApp Audio
│       │   ├── AUD-20191203-WA0000.mp3
│       │   ├── AUD-20200302-WA0000.mp3
│       │   └── AUD-20210219-WA0001.mp3
│       └── WhatsApp Documents
│           └── Spreeradio 105.5 . 2021-05-07 - Interview mit Bernd Hahn
└── myrecording.mp3
''');
  });

  test('splitArtistString', () async {
    riverpodContainer = ProviderContainer.test();
    musicBrainz = MusicBrainz(RecordPlaybackHttpClient());
    expect(await logic.splitArtistString(''), equals([]));
    expect(await logic.splitArtistString('Simon & Garfunkel'), equals(['Simon & Garfunkel']));
    expect(await logic.splitArtistString('Simon and Garfunkel'), equals(['Simon & Garfunkel']));
    expect(await logic.splitArtistString('Hans Zimmer & Lisa Gerrard'), equals(['Lisa Gerrard', 'Hans Zimmer']));
  });
}

extension on AudioFolder {
  String prettyPrint() {
    final sb = StringBuffer(name)..writeln();
    _prettyPrint(sb, '', null);
    return sb.toString();
  }

  void _prettyPrint(StringBuffer sb, String prefix, bool? isLastFolder) {
    String childPrefix;
    if (isLastFolder == null) {
      childPrefix = '';
    } else {
      sb
        ..write(prefix)
        ..write(isLastFolder ? '└── ' : '├── ')
        ..writeln(name);
      childPrefix = prefix + (isLastFolder ? '    ' : '│   ');
    }
    final children = [...subfolders, ...files];
    for (var i = 0; i < children.length; i++) {
      final isLast = i == children.length - 1;
      if (children[i] is AudioFile) {
        sb.writeln('$childPrefix${isLast ? '└── ' : '├── '}${(children[i] as AudioFile).fileName}');
      } else if (children[i] is AudioFolder) {
        (children[i] as AudioFolder)._prettyPrint(sb, childPrefix, isLast);
      }
    }
  }
}

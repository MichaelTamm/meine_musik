import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/env.dart';
import 'package:meine_musik/model/PlayingPausedOrCompleted.dart';
import 'package:meine_musik/riverpod/player_state.dart';
import 'package:meine_musik/ui/SongListTile.dart';
import 'package:meine_musik/ui/player_widget/PlayerWidget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spot/spot.dart';

import 'testdata.dart';
import 'widget_test_utils.dart';

void main() {
  group('Enqueue song', () {
    testWidgets('when PlayerWidget is not shown', (tester) async {
      final song1 = anAudioFile(title: 'song1');
      final song2 = anAudioFile(title: 'song2');
      when(() => nativeMethods.findAll()).thenAnswer((_) async => [song1, song2]);
      await tester.startApp();
      await act.tapAndSettle(spotText('Alle Lieder'));
      spotText('song1').existsOnce();
      await act.tapAndSettle(spot<SongListTile>().withChild(spotText('song1')).spotIcon(Icons.more_vert_rounded));
      await act.tapAndSettle(spotText('zur Wiedergabeliste hinzufügen'));
      expect(riverpodContainer.read(currentPlaylistProvider), [song1]);
      expect(riverpodContainer.read(currentSongProvider), song1);
      expect(riverpodContainer.read(isPlayingPausedOrCompletedProvider), PlayingPausedOrCompleted.playing);
      spot<PlayerWidget>().spotText('song1').existsOnce();
    });

    testWidgets('when a song is playing', (tester) async {
      final song1 = anAudioFile(title: 'song1');
      final song2 = anAudioFile(title: 'song2');
      when(() => nativeMethods.findAll()).thenAnswer((_) async => [song1, song2]);
      await tester.startApp();
      await act.tapAndSettle(spotText('Alle Lieder'));
      spotText('song1').existsOnce();
      await act.tapAndSettle(spot<SongListTile>().withChild(spotText('song1')).spotIcon(Icons.play_arrow_rounded));
      expect(riverpodContainer.read(currentPlaylistProvider), [song1]);
      expect(riverpodContainer.read(currentSongProvider), song1);
      spot<PlayerWidget>().spotText('song1').existsOnce();
      await act.tapAndSettle(spot<SongListTile>().withChild(spotText('song2')).spotIcon(Icons.more_vert_rounded));
      await act.tapAndSettle(spotText('zur Wiedergabeliste hinzufügen'));
      expect(riverpodContainer.read(currentPlaylistProvider), [song1, song2]);
      expect(riverpodContainer.read(currentSongProvider), song1);
      expect(riverpodContainer.read(isPlayingPausedOrCompletedProvider), PlayingPausedOrCompleted.playing);
      spot<PlayerWidget>().spotText('1/2').existsOnce();
    });

    testWidgets('when the current playlist is completed', (tester) async {
      // TODO: ...
    });
  });
}

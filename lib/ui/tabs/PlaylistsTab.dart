import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../LoadingIndicator.dart';

class PlaylistsTab extends HookConsumerWidget {
  const PlaylistsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingIndicator();
  }
}

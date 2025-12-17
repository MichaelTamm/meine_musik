import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../LoadingIndicator.dart';

class AlbenTab extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingIndicator();
  }
}

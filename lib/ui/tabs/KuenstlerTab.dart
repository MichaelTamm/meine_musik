import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../LoadingIndicator.dart';

class KuenstlerTab  extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingIndicator();
  }
}
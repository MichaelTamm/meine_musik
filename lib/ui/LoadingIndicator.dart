import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../env.dart';
import '../hooks.dart';

class LoadingIndicator extends HookWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoadingTakingALongTimeState = useState(false);
    useOnMount(() async {
      if (!kIsTest) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (context.mounted) {
            isLoadingTakingALongTimeState.value = true;
          }
        });
      }
    });
    final isLoadingTakingALongTime = isLoadingTakingALongTimeState.value;
    return kIsTest || isLoadingTakingALongTime
        ? Center(
            // When testing, we can't just use CircularProgressIndicator() because with an animated
            // CircularProgressIndicator a test might fail with an "pumpAndSettle timed out" error.
            // Therefore we use the static CircularProgressIndicator(value: 0.333) for testing ...
            child: CircularProgressIndicator(value: kIsTest ? 0.333 : null),
          )
        : Container();
  }
}

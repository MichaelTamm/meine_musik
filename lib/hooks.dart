import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Executes the given `effect` when the widget is mounted.
void useOnMount(FutureOr<void> Function() effect) {
  useEffect(() {
    Future.microtask(
      effect,
    ).catchError((error, StackTrace stack) => debugPrintStack(label: 'useWhenMounted effect failed: $error', stackTrace: stack));
    return null;
  }, []);
}

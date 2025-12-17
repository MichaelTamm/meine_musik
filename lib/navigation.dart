import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey(debugLabel: 'appNavigatorKey');

Future<T?> openBottomSheet<T>(Widget Function() bottomSheetBuilder) {
  final outerNavigator = appNavigatorKey.currentState;
  if (outerNavigator == null) {
    throw StateError('appNavigatorKey.currentState == null');
  }
  return outerNavigator.push(ModalBottomSheetRoute<T>(
    builder: (_) => bottomSheetBuilder(),
    isScrollControlled: false,
    scrollControlDisabledMaxHeightRatio: 0.75,
    enableDrag: true,
    showDragHandle: true,
  ));
}

void closeBottomSheet<T>({T? result}) {
  final outerNavigator = appNavigatorKey.currentState;
  if (outerNavigator == null) {
    throw StateError('appNavigatorKey.currentState == null');
  }
  outerNavigator.pop(result);
}

import 'package:flutter/material.dart';

final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

final themeData = ThemeData(
  useMaterial3: true,
  appBarTheme: AppBarTheme(toolbarHeight: 0),
  colorScheme: colorScheme,
  dividerTheme: DividerThemeData(space: 0),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorScheme.primaryContainer,
    elevation: 6.0,
    focusColor: colorScheme.onPrimaryContainer.withAlpha(26),
    foregroundColor: colorScheme.onPrimaryContainer,
    hoverColor: colorScheme.onPrimaryContainer.withAlpha(20),
    splashColor: colorScheme.onPrimaryContainer.withAlpha(26),
    shape: const CircleBorder(),
  ),
  listTileTheme: ListTileThemeData(selectedTileColor: Color.lerp(Colors.purpleAccent, Colors.white, 0.75)),
  // The pageTransitionsTheme is used by the `OrdnerTab` when switching folders ...
  pageTransitionsTheme: PageTransitionsTheme(
    builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
      TargetPlatform.values,
      value: (_) => const FadeForwardsPageTransitionsBuilder(),
    ),
  ),
);

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void showSnackBar(BuildContext context, String text, {(String, VoidCallback)? action}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(text),
          if (action != null) Align(alignment: Alignment.centerRight, child: _SnackBarActionButton(action)),
        ],
      ),
      showCloseIcon: true,
    ),
  );
}

class _SnackBarActionButton extends HookWidget {
  _SnackBarActionButton((String, VoidCallback) action) : label = Text(action.$1), action = action.$2;

  final Text label;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final enabledState = useState(true);
    final enabled = enabledState.value;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return TextButtonTheme(
      data: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: colorScheme.inversePrimary)),
      child: TextButton(
        onPressed: enabled
            ? () {
                enabledState.value = false;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                action();
              }
            : null,
        child: label,
      ),
    );
  }
}

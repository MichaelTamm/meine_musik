import 'package:flutter/material.dart';

class DeletableListTile extends StatelessWidget {
  const DeletableListTile({required Key key, this.leading, this.title, this.trailing, this.onTap, required this.onDelete})
    : super(key: key);

  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(''),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(Icons.delete_outline, color: Colors.white),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.delete_outline, color: Colors.white),
          ),
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(leading: leading, title: title, trailing: trailing, onTap: onTap),
    );
  }
}

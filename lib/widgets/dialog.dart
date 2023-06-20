import 'package:flutter/material.dart';

void showConfirmationDialog(
  BuildContext context,
  String title,
  String content,
  Function action,
) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content.isEmpty ? null : Text(content),
        actions: <Widget>[
          OutlinedButton(
            child: const Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              action();
            },
          ),
          OutlinedButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

void showMessageDialog(
  BuildContext context,
  String title,
  String content,
) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content.isEmpty ? null : Text(content),
        actions: <Widget>[
          OutlinedButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

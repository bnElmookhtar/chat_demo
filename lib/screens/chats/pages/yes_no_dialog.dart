import 'package:flutter/material.dart';

void showConfirmationDialog(BuildContext context, String msg, Function action) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Are you sure?"),
        content: Text(msg),
        actions: <Widget>[
          OutlinedButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          OutlinedButton(
            child: Text("Yes"),
            onPressed: () {
              action();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


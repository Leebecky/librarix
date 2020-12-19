import 'package:flutter/material.dart';

Widget generalAlertDialog(BuildContext context,
    {String title, String content, returnHome = false}) {
  NavigatorState nav = Navigator.of(context);
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      FlatButton(
          onPressed: () {
            if (returnHome) {
              nav.pop();
              nav.pop();
            } else
              Navigator.pop(context);
          },
          child: Text("Close"))
    ],
  );
}
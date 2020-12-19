import 'package:flutter/material.dart';

Widget generalAlertDialog(BuildContext context, String title, String content) {
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      FlatButton(onPressed: () => Navigator.pop(context), child: Text("Close"))
    ],
  );
}

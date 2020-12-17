import 'package:flutter/material.dart';
import 'package:librarix/librarix_widget.dart';
import 'package:librarix/menu_widget.dart';
//import 'menu_widget.dart';
//import 'librarix_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LibrariX",
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}


import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "LibrariX",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("LibrariX"),
          ),
          body: Container(
            child: Text("Placeholder, SDP assignment here we go!"),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import './Screens/test.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

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
        body: Image.network(
            'https://user-images.githubusercontent.com/55550611/100253364-f9997a00-2f7b-11eb-9c4a-7f8607d4d248.jpg'),
      ),
    );
  }
}

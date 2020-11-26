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
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey[700],
        accentColor: Colors.lightBlue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("LibrariX"),
        ),
        body: GetBook(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blueGrey[700],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.50),
          unselectedFontSize: 14,
          selectedFontSize: 14,
          onTap: (value) => {
            //TODO implement navigation functionality
          },
          items: [
            BottomNavigationBarItem(label: "Menu", icon: Icon(Icons.menu)),
            BottomNavigationBarItem(
                label: "Notifications", icon: Icon(Icons.notifications)),
            BottomNavigationBarItem(
                label: "Catalogue", icon: Icon(Icons.library_books)),
            BottomNavigationBarItem(
                label: "Booking", icon: Icon(Icons.event_available)),
            BottomNavigationBarItem(
                label: "History", icon: Icon(Icons.history)),
          ],
        ),
      ),
    );
  }
}

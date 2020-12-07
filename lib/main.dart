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
      //^ named Navigator routes
      /* initialRoute: "home",
      routes: {
        "home": (context) => LibrarixHome(),
        "testPage": (context) => GetBook(),
      }, */
      home: LibrarixHome(),
    );
  }
}

class LibrarixHome extends StatefulWidget {
  @override
  _LibrarixHomeState createState() => _LibrarixHomeState();
}

class _LibrarixHomeState extends State<LibrarixHome> {
  int tabIndex = 2;
  List<Widget> pages = [
    Menu(),
    Notifications(),
    GetBook(),
    Booking(),
    DisplayImage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LibrariX"),
      ),
      body: pages[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueGrey[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.50),
        unselectedFontSize: 14,
        selectedFontSize: 14,
        currentIndex: tabIndex,
        onTap: changePage,
        items: [
          BottomNavigationBarItem(label: "Menu", icon: Icon(Icons.menu)),
          BottomNavigationBarItem(
              label: "Notifications", icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(
              label: "Catalogue", icon: Icon(Icons.library_books)),
          BottomNavigationBarItem(
              label: "Booking", icon: Icon(Icons.event_available)),
          BottomNavigationBarItem(label: "History", icon: Icon(Icons.history)),
        ],
      ),
    );
  }

  void changePage(int i) {
    setState(() {
      tabIndex = i;
    });
  }
}

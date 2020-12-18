import 'package:flutter/material.dart';
import 'package:librarix/librarix_navigations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Screens/login.dart';
import './Screens/borrow_book_scanner.dart';

main() async {
  //? initialises firebase instances for authentication and Cloud FireStore
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance;
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
          accentColor: Colors.white,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        //^ named Navigator routes
        initialRoute: keepLoggedIn(),
        routes: {
          "/": (context) => Login(),
          "/home": (context) => Home(),
          "/scanner": (context) => BarcodeScanner(),
        });
  }

//? Checks if the user is logged in. If yes, skip the login page, else redirect to login
  String keepLoggedIn() {
    String myRoute;
    try {
      User currentUser = FirebaseAuth.instance.currentUser;
      {
        (currentUser == null) ? myRoute = "/" : myRoute = "/home";
        return myRoute;
      }
    } catch (e) {
      print("$e: User is not logged in");
      return myRoute;
    }
  }
}

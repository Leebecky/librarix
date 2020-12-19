import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarix/first_view.dart';
import 'package:librarix/loader.dart';
import 'Screens/Navigation Bar/librarix_navigations.dart';
import 'Screens/Navigation Bar/librarix_navigations_librarian.dart';
import 'Screens/Navigation Bar/librarix_navigation_admin.dart';
import './Screens/login.dart';
import './Screens/borrow_book_scanner.dart';
import './Models/user.dart';

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
    return FutureBuilder<String>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                initialRoute: snapshot.data,
                routes: {
                  "/": (context) => FirstView(),
                  "/loader": (context) => Loader(),
                  "/login": (context) => Login(),
                  "/home": (context) => Home(),
                  "/librarianHome": (context) => LibrarianHome(),
                  "/adminHome": (context) => AdminHome(),
                  "/scanner": (context) => BarcodeScanner(),
                });
          }
          return Loader();
        });
  }

//? Checks if the user is logged in. If yes, go to home, else redirect to login
  Future<String> checkLoggedIn() async {
    String myRoute = "/home";
    try {
      User currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        myRoute = "/";
      } else {
        bool isAdmin = await checkRole(currentUser.uid, "Admin");
        bool isLibrarian = await checkRole(currentUser.uid, "Librarian");

        (isAdmin)
            ? myRoute = "/adminHome" //~ (if admin)
            : (isLibrarian)
                ? myRoute = "/librarianHome" //~ (if librarian)
                : myRoute = "/home"; //~ (if user)
      }
    } catch (e) {
      print("$e: User is not logged in");
    }
    return myRoute;
  }
}

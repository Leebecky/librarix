import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarix/config.dart';
import 'package:librarix/first_view.dart';
import 'package:librarix/loader.dart';
import 'librarix_navigations.dart';
import 'librarix_navigations_librarian.dart';
import 'librarix_navigation_admin.dart';
import 'loader.dart';
import 'config.dart';
import './Screens/login.dart';
import './Screens/borrow_book_scanner.dart';
import './Models/user.dart';

//TODO add splash screens to hide loading sequence of the application
main() async {
  //? initialises firebase instances for authentication and Cloud FireStore
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//Get the state of dark mode or light mode and update it
class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    currentTheme.addListener(() {
      print('Changes');
      setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          print("myroute is ${snapshot.data}");
          if (snapshot.hasData) {
            return MaterialApp(
                title: "LibrariX",
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: currentTheme.currentTheme(),
                //^ named Navigator routes
                initialRoute: "${snapshot.data}",
                routes: {
                  //"/": (context) => Loader(),
                  "/": (context) => FirstView(),
                  "/login": (context) => Login(),
                  "/home": (context) => Home(),
                  "/staffHome": (context) => LibrarianHome(),
                  "/scanner": (context) => ScannerPage(),
                });
          }
          return LinearProgressIndicator();
        });
  }

  Future<String> checkLoggedIn() async {
    String myRoute = "/home";
    try {
      User currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        myRoute = "/";
      } else {
        bool isAdmin = await checkRole(currentUser.uid, "Admin");
        bool isLibrarian = await checkRole(currentUser.uid, "Librarian");

        (isAdmin || isLibrarian) ? myRoute = "/staffHome" : myRoute = "/home";
      }
      return myRoute;
    } catch (e) {
      print("$e: User is not logged in");
      return myRoute;
    }
  }
}

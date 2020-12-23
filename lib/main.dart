import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Screens/book_details.dart';
import 'package:librarix/config.dart';
import 'package:librarix/first_view.dart';
import 'Screens/Navigation Bar/librarix_navigations.dart';
import 'Screens/Navigation Bar/librarix_navigations_librarian.dart';
import 'Screens/Navigation Bar/librarix_navigation_admin.dart';
import './Screens/login.dart';
import './Screens/borrow_book_scanner.dart';
import './Models/user.dart';
import 'Screens/book_details.dart';

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
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print('Changes');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
                title: "LibrariX",
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: currentTheme.currentTheme(),
                //^ named Navigator routes
                initialRoute: snapshot.data,
                routes: {
                  "/": (context) => FirstView(),
                  "/login": (context) => Login(),
                  "/home": (context) => Home(),
                  "/librarianHome": (context) => LibrarianHome(),
                  "/adminHome": (context) => AdminHome(),
                  "/scanner": (context) => BarcodeScanner(),
                  "/bookDetails": (context) => BookDetails(),
                });
          }
          return SpinKitWave(
            color: Theme.of(context).accentColor,
          );
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

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarix/config.dart';
import 'package:librarix/first_view.dart';
import 'Screens/Navigation_Bar/librarix_navigations.dart';
import 'Screens/Navigation_Bar/librarix_navigations_librarian.dart';
import 'Screens/Navigation_Bar/librarix_navigation_admin.dart';
import './Screens/login.dart';
import './Screens/borrow_book_scanner.dart';
import './Models/user.dart';
import 'Screens/Search/search_view.dart';
import 'Screens/fines_view.dart';

main() async {
  //? initialises firebase instances for authentication and Cloud FireStore
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance;
  String myRoute = await checkLoggedIn();
  runApp(MyApp(myRoute));
}

class MyApp extends StatefulWidget {
  final String myRoute;
  MyApp(this.myRoute);
  @override
  _MyAppState createState() => _MyAppState();
}

//Get the state of dark mode or light mode and update it
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    currentTheme.addListener(() {
      print('Changes');
      setState(() {});
    });
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "LibrariX",
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: currentTheme.currentTheme(),
        //^ named Navigator routes
        initialRoute: widget.myRoute,
        routes: {
          "/": (context) => FirstView(),
          "/login": (context) => Login(),
          "/home": (context) => Home(),
          "/librarianHome": (context) => LibrarianHome(),
          "/adminHome": (context) => AdminHome(),
          "/scanner": (context) => BarcodeScanner(),
          "/search": (context) => SearchFunction(),
          "/fines": (context) => Fines(),
        });
  }
}

Future<String> checkLoggedIn() async {
  String myRoute = "/home";
  try {
    User currentUserId = FirebaseAuth.instance.currentUser;
    if (currentUserId == null) {
      myRoute = "/";
    } else {
      ActiveUser currentUser = await myActiveUser(docId: currentUserId.uid);
      (currentUser.role == "Admin")
          ? myRoute = "/adminHome" //~ (if admin)
          : (currentUser.role == "Librarian")
              ? myRoute = "/librarianHome" //~ (if librarian)
              : myRoute = "/home"; //~ (if user)
    }
  } catch (e) {
    print("$e: User is not logged in");
  }
  return myRoute;
}

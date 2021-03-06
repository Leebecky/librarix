import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librarix/Screens/Notifications/local_notifications_initializer.dart';
import 'package:librarix/config.dart';
import 'package:librarix/Screens/first_view.dart';
import 'Screens/Navigation_Bar/librarix_navigations.dart';
import 'Screens/Navigation_Bar/librarix_navigations_librarian.dart';
import 'Screens/Navigation_Bar/librarix_navigation_admin.dart';
import './Screens/login.dart';
import './Screens/Borrow_Books/borrow_book_scanner.dart';
import 'Screens/Search/search_view.dart';
import 'Screens/Notifications/notifications_display.dart';
import 'package:get/get.dart';
import 'Screens/Report_Generator/report_generator.dart';

main() async {
  //~ initialises firebase instances for authentication and Cloud FireStore
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance;
  //~ Redirects users
  String myRoute = await checkLoggedIn();
  //~  Initializing stuff for notifications
  initializePlatformSpecifics();
  initialiseTimeZones();

  //~ Run application
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
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
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
          "/notifications": (context) => NotificationsDisplay(),
          "/reports": (context) => ReportGenerator(),
        });
  }
}

Future<String> checkLoggedIn() async {
  String myRoute = "/home", currentRole;
  try {
    User currentUserId = FirebaseAuth.instance.currentUser;
    if (currentUserId == null) {
      myRoute = "/";
    } else {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(currentUserId.uid)
          .collection("Login")
          .doc("LoginRole")
          .get()
          .then((value) => currentRole = value.data()["LoggedInAs"]);

      (currentRole == "Admin")
          ? myRoute = "/adminHome" //~ (if admin)
          : (currentRole == "Librarian")
              ? myRoute = "/librarianHome" //~ (if librarian)
              : myRoute = "/home"; //~ (if user)
    }
  } catch (e) {
    print("$e: User is not logged in");
  }
  return myRoute;
}

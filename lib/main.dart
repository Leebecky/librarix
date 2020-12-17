import 'package:flutter/material.dart';
import 'librarix_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Models/user.dart';
import './Screens/test.dart';
import './Screens/login.dart';

main() async {
  //initialises firebase instances for authentication and Cloud FireStore
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
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      //^ named Navigator routes
      initialRoute: keepLoggedIn(),
      routes: {
        "/": (context) => Login(),
        "/home": (context) => LibrarixHome(),
        "/menuPlaceholder": (context) => Menu(),
      },
      // home: LibrarixHome(),
    );
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

/*      
class LibrarixHome extends StatefulWidget {
  @override
  _LibrarixHomeState createState() => _LibrarixHomeState();
}

class _LibrarixHomeState extends State<LibrarixHome> {
  int tabIndex = 2;
  List<Widget> pages = [
    TestProfile(),
    Notifications(),
    GetBook(),
    Booking(),
    DisplayImage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FutureBuilder(
          future: getActiveUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return IconButton(
                icon: Icon(Icons.account_circle),
                iconSize: 40.0,
                onPressed: logout,
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final ActiveUser activeUser =
                  ActiveUser.fromJson(snapshot.data.data());
              return IconButton(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    activeUser.avatar,
                  ),
                ),
                iconSize: 40.0,
                onPressed: logout,
              );
            }
            return IconButton(
              icon: Icon(Icons.account_circle),
              iconSize: 40.0,
              onPressed: logout,
            );
          },
        ),
        title: Text("LibrariX"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.qr_code_scanner_rounded),
              iconSize: 35.0,
              onPressed: () => Navigator.pushNamed(context, "/menu"))
        ],
      ),
      body: pages[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
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
      home: Home(),
    );
  }

      
  void changePage(int i) {
    setState(() {
      tabIndex = i;
    });
  }
*/
  void logout() async {
    //? placeholder logout test
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", ModalRoute.withName("/"));
  }
}


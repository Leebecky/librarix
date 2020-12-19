import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarix/Screens/borrow_book_scanner.dart';
import '../test.dart';
import '../catalogue_view.dart';
//import 'package:librarix/views/BookCatalogue/book_details.dart';

class AdminHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminHomeState();
  }
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 1;
  String currentProfilePic =
      "https://avatars3.githubusercontent.com/u/16825392?s=460&v=4";

  final List<Widget> _pages = [
    BookingView(),
    CatalogueView(),
    HistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LibrariX"),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_stories),
            onPressed: () => Navigator.pushNamed(context, "/scanner"),
            iconSize: 35.0,
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Bramvbilsen"),
              accountEmail: new Text("bramvbilsen@gmail.com"),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(currentProfilePic),
                ),
                onTap: () => print("This is your current account."),
              ),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new NetworkImage(
                          "https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                      fit: BoxFit.fill)),
            ),
            new ListTile(
                title: new Text("Notifications"),
                trailing: new Icon(Icons.notifications),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
                }),
            new ListTile(
                title: new Text("Booking Records"),
                trailing: new Icon(Icons.book_rounded),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            new ListTile(
                title: new Text("Fines Management"),
                trailing: new Icon(Icons.attach_money),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            new ListTile(
                title: new Text("Report Generator"),
                trailing: new Icon(Icons.bar_chart),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            new ListTile(
                title: new Text("Librarian Management"),
                trailing: new Icon(Icons.camera_front),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            new Divider(),
            new ListTile(
              title: new Text("Logout"),
              trailing: new Icon(Icons.logout),
              onTap: () => logout(),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[300],
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.event_available),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            label: "Catalogue",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.check_circle),
            label: "Book Return",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

//? Logout function
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", ModalRoute.withName("/"));
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../test.dart';
import '../Staff/booking_records.dart';
import '../catalogue_view.dart';
import '../Staff/book_management.dart';
import 'package:librarix/config.dart';
import '../booking_maker.dart';

class LibrarianHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LibrarianHomeState();
  }
}

class _LibrarianHomeState extends State<LibrarianHome> {
  double screenWidth, screenHeight;
  int _currentIndex = 1;
  String currentProfilePic =
      "https://avatars3.githubusercontent.com/u/16825392?s=460&v=4";

  final List<Widget> _pages = [
    BookingMaker(),
    CatalogueView(),
    HistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LibrariX"),
        actions: [
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () => Navigator.pushNamed(context, "/search"), 
            iconSize: 35.0
          ),
          IconButton(
            icon: Icon(Icons.auto_stories),
            onPressed: () => Navigator.pushNamed(context, "/scanner"),
            iconSize: 35.0,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Bramvbilsen"),
              accountEmail: Text("bramvbilsen@gmail.com"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(currentProfilePic),
                ),
                onTap: () => print("This is your current account."),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                      fit: BoxFit.fill)),
            ),
            ListTile(
                title: Text("Notifications"),
                trailing: Icon(Icons.notifications),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
                }),
            ListTile(
                title: Text("Booking Records"),
                trailing: Icon(Icons.book_rounded),
                onTap: () {
                  //Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BookingRecords();
                  }));
                }),
            ListTile(
                title: Text("Book Management"),
                trailing: Icon(Icons.book_online),
                onTap: () {
                  //Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BookManagementListView();
                  }));
                }),
            ListTile(
                title: Text("Fines Management"),
                trailing: Icon(Icons.attach_money),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            ListTile(
                title: Text("Report Generator"),
                trailing: Icon(Icons.bar_chart),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            ListTile(
                title: Text("Switch theme"),
                trailing: Icon(Icons.toggle_off_rounded),
                onTap: () {
                  currentTheme.switchTheme();
                }),
            Divider(),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.logout),
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

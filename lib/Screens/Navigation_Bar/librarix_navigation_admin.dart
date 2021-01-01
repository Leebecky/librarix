import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarix/Models/user.dart';
import '../Staff/update_booking/update_booking_record.dart';
import '../Staff/update_book/update_book_record.dart';
import '../Staff/librarian_management.dart';
import 'package:librarix/config.dart';
import '../catalogue_view.dart';
import '../Booking/booking_maker.dart';
import '../Staff/booking_records.dart';
import '../Staff/book_management.dart';

class AdminHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminHomeState();
  }
}

class _AdminHomeState extends State<AdminHome> {
  double screenWidth, screenHeight;
  int _currentIndex = 1;

  final List<Widget> _pages = [
    BookingMaker(),
    CatalogueView(),
    UpdateBook(),
    UpdateBooking(),
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
              iconSize: 35.0),
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
            // Retrieve the data of the user that currently login
            FutureBuilder<ActiveUser>(
                future: myActiveUser(),
                builder:
                    (BuildContext context, AsyncSnapshot<ActiveUser> user) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(user.data.name),
                    accountEmail: Text(user.data.email),
                    currentAccountPicture: GestureDetector(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.data.avatar),
                      ),
                      onTap: () => print("This is your current account."),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                            fit: BoxFit.fill)),
                  );
                }),
            ListTile(
                title: Text("Notifications"),
                trailing: Icon(Icons.notifications),
                onTap: () {
                  //Navigator.of(context).pop();
                  //Navigator.of(context).push( MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
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
                title: Text("Librarian Management"),
                trailing: Icon(Icons.camera_front),
                onTap: () {
                  //Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LibrarianManagement();
                  }));
                }),
            ListTile(
                title: Text("Switch theme"),
                trailing: Icon(Icons.toggle_off_rounded),
                onTap: () {
                  currentTheme.switchTheme();
                }),
            SizedBox(height: screenHeight * 0.04),
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
            icon: Icon(Icons.event_available),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Catalogue",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "Book Update", //return & reservation
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "Booking Update", //study table & discussion room
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

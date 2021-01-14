import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarix/config.dart';
import '../Staff/book_management/book_management.dart';
import '../Staff/librarian_management/librarian_management.dart';
import '../../Models/notifications.dart';
import '../../Models/user.dart';
import '../../modules.dart';
import '../Staff/fines_management.dart';
import '../Staff/update_booking/update_booking_record.dart';
import '../Staff/update_book/update_book_record.dart';
import '../../config.dart';
import '../catalogue_view.dart';
import '../Booking/booking_maker.dart';
import '../Staff/booking_records.dart';

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
                  if (user.hasData) {
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
                  }
                  return LinearProgressIndicator();
                }),
            ListTile(
                title: Text("Notifications"),
                trailing: notificationIcon(),
                onTap: () {
                  Navigator.pushNamed(context, "/notifications");
                }),
            ListTile(
                title: Text("Booking Records"),
                trailing: Icon(Icons.book_rounded),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BookingRecords();
                  }));
                }),
            ListTile(
                title: Text("Book Management"),
                trailing: Icon(Icons.book_online),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BookManagementListView();
                  }));
                }),
            ListTile(
                title: Text("Fines Management"),
                trailing: Icon(Icons.attach_money),
                onTap: () {
                  //Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FinesManagement();
                  }));
                }),
            ListTile(
                title: Text("Report Generator"),
                trailing: Icon(Icons.bar_chart),
                onTap: () {
                  Navigator.pushNamed(context, "/reports");
                }),
            ListTile(
                title: Text("Librarian Management"),
                trailing: Icon(Icons.camera_front),
                onTap: () {
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
            icon: Icon(Icons.autorenew),
            label: "Book Update", //return & reservation
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.av_timer),
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

  //? Displays a badge over the notification icon if there are unread notifications
  Widget notificationIcon() {
    CollectionReference staffNotificationDb =
        FirebaseFirestore.instance.collection("StaffNotifications");

    return StreamBuilder<QuerySnapshot>(
        stream: staffNotificationDb.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            //^  Processing notifications to only display those that have been deployed
            List<Notifications> notificationsList = [];
            snapshot.data.docs.forEach((doc) {
              notificationsList.add(notificationsFromJson(doc.data()));
            });

            notificationsList.removeWhere((notif) =>
                parseStringToDate(notif.displayDate).isAfter(DateTime.now()) ||
                notif.read == true);
            notificationsList.join(",");

            //^ Display Notification icon + badge
            if (notificationsList.length > 0) {
              return SizedBox(
                  width: 25,
                  child: Stack(children: [
                    Icon(Icons.notifications),
                    Positioned(
                        right: 0,
                        top: -2,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (currentTheme.currentTheme() == ThemeMode.light)
                                    ? Colors.blue
                                    : Colors.red,
                          ),
                          child: Text(notificationsList.length.toString(),
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white)),
                        ))
                  ]));
            }
          }
          return Icon(Icons.notifications);
        });
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarix/Models/user.dart';
import 'package:librarix/Screens/Fines/fines_view.dart';
import 'package:librarix/Screens/Rewards/rewards_view.dart';
import '../Catalogue/catalogue_view.dart';
import '../History/history_view.dart';
import 'package:librarix/config.dart';
import 'package:librarix/Screens/Booking/booking_maker.dart';
import 'package:librarix/modules.dart';
import '../../Models/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  double screenWidth, screenHeight;
  int _currentIndex = 1;

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
        actions: <Widget>[
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
                  Navigator.popAndPushNamed(context, "/notifications");
                }),
            ListTile(
                title: Text("Rewards"),
                trailing: Icon(Icons.outlined_flag_rounded),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Rewards();
                  }));
                }),
            ListTile(
                title: Text("Fines"),
                trailing: Icon(Icons.monetization_on_rounded),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FinesDisplay();
                  }));
                }),
            ListTile(
                title: Text("Switch Theme"),
                trailing: Icon(Icons.toggle_off_rounded),
                onTap: () {
                  currentTheme.switchTheme();
                }),
            // SizedBox(height: screenHeight * 0.35),
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
        unselectedItemColor: Colors.grey[400],
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
            icon: Icon(Icons.history),
            label: "History",
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

  Widget notificationIcon() {
    CollectionReference notificationDb = FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("Notifications");

    return StreamBuilder<QuerySnapshot>(
        stream: notificationDb.snapshots(),
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
                        color: (currentTheme.currentTheme() == ThemeMode.light)
                            ? Colors.blue
                            : Colors.red,
                      ),
                      child: Text(notificationsList.length.toString(),
                          style: TextStyle(fontSize: 11, color: Colors.white)),
                    ),
                  ),
                ]),
              );
            }
          }
          return Icon(Icons.notifications);
        });
  }
}

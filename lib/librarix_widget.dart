import 'package:flutter/material.dart';
import './Screens/test.dart';
import './Screens/catalogue_view.dart';
//import 'package:librarix/views/BookCatalogue/book_details.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  String currentProfilePic = "https://avatars3.githubusercontent.com/u/16825392?s=460&v=4";
  String otherProfilePic = "https://yt3.ggpht.com/-2_2skU9e2Cw/AAAAAAAAAAI/AAAAAAAAAAA/6NpH9G8NWf4/s900-c-k-no-mo-rj-c0xffffff/photo.jpg";

  void switchAccounts() {
    String picBackup = currentProfilePic;
    this.setState(() {
      currentProfilePic = otherProfilePic;
      otherProfilePic = picBackup;
    });
  }

  int _currentIndex = 2;
  final List<Widget> _pages = [
    MenuView(),
    NotificationsView(),
    CatalogueView(),
    BookingView(),
    HistoryView(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LibrariX"),
        /*leading: IconButton(
            icon: Icon(Icons.account_circle), 
            onPressed: null,
            iconSize: 35.0,
          ),*/
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.qr_code_scanner), 
              onPressed: null,
              iconSize: 35.0,
            ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountEmail: new Text("bramvbilsen@gmail.com"),
              accountName: new Text("Bramvbilsen"),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(currentProfilePic),
                ),
                onTap: () => print("This is your current account."),
              ),
              otherAccountsPictures: <Widget>[
                new GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage(otherProfilePic),
                  ),
                  onTap: () => switchAccounts(),
                ),
              ],
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new NetworkImage("https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                  fit: BoxFit.fill
                )
              ),
            ),
            new ListTile(
              title: new Text("Notifications"),
              trailing: new Icon(Icons.notifications),
              onTap: () {
                //Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
              }
            ),
            new ListTile(
              title: new Text("Rewards"),
              trailing: new Icon(Icons.outlined_flag_rounded),
              onTap: () {
                //Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
              }
            ),
            new ListTile(
              title: new Text("Fines"),
              trailing: new Icon(Icons.monetization_on_rounded),
              onTap: () {
                //Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
              }
            ),
            new Divider(),
            new ListTile(
              title: new Text("Logout"),
              trailing: new Icon(Icons.logout),
              onTap: () {
                //Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
              },
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
            title: new Text("Booking"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            title: new Text("Catalogue"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text("History"),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}

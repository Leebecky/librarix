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
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[300],
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.menu),
            title: new Text("Menu"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications),
            title: new Text("Notifications"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            title: new Text("Catalogue"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.event_available),
            title: new Text("Booking"),
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

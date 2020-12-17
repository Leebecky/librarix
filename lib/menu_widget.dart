import 'package:flutter/material.dart';
//import 'package:librarix/librarix_widget.dart';

final Color backgroundColor = Color(0xFF95A2AC);

class SideBarMenu extends StatefulWidget {
  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashbaord(context),
        ],
      ),
    );
  }

  Widget menu(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Dashboard",
                style: TextStyle(color: Colors.white, fontSize: 22.0)),
            SizedBox(height: 20.0),
            Text("Notifications",
                style: TextStyle(color: Colors.white, fontSize: 22.0)),
            SizedBox(height: 20.0),
            Text("Rewards",
                style: TextStyle(color: Colors.white, fontSize: 22.0)),
            SizedBox(height: 20.0),
            Text("Fines",
                style: TextStyle(color: Colors.white, fontSize: 22.0)),
          ],
        ),
      ),
    );
  }

  
  Widget dashbaord(context) {
    return AnimatedPositioned(
      duration: duration,
      top: isCollapsed ? 0 : 0.05 * screenHeight,
      bottom: isCollapsed ? 0 : 0.05 * screenHeight,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: Material(
        animationDuration: duration,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 48.0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  child: IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: null,
                      iconSize: 35.0),
                  onTap: () {
                    setState(() {
                      isCollapsed = !isCollapsed;
                    });
                  },
                ),
                Text("LibrariX", style: TextStyle(fontSize: 30.0)),
                IconButton(
                    icon: Icon(Icons.qr_code_scanner),
                    onPressed: null,
                    iconSize: 35.0),
              ],
            ),
            SizedBox(height: 50),
            BottomNavigationBar(
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
            )
          ]),
        ),
      ),
    );
  }
}

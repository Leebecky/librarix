import 'package:flutter/material.dart';

class BookReturn extends StatefulWidget {
  @override
  _BookReturnState createState() => _BookReturnState();
}

class _BookReturnState extends State<BookReturn>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).accentColor,
              tabs: [
                Tab(
                  text: "Discussion Room",
                ),
                Tab(
                  text: "Study Table Room",
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            )
          ],
        ),
      ),
    );
  }
}

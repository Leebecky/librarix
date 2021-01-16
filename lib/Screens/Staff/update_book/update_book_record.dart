import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'book_reservation_list.dart';
import 'book_return_list.dart';

class UpdateBook extends StatefulWidget {
  @override
  _UpdateBookState createState() => _UpdateBookState();
}

class _UpdateBookState extends State<UpdateBook>
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
        body: DoubleBackToCloseApp(
      snackBar: const SnackBar(
        content: Text('Tap back again to leave'),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).accentColor,
              tabs: [
                Tab(
                  text: "Book Return",
                ),
                Tab(
                  text: "Book Reservation",
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BookReturnList(),
                  BookReservationList(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

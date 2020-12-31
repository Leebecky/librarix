import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/borrow.dart';
import 'package:librarix/Screens/Staff/update_book/book_reservation_list.dart';
import 'package:librarix/Screens/Staff/update_book/book_return_list.dart';

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
      body: Container(
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
                children: [
                  Container(
                    child: FutureBuilder<Borrow>(
                        future: borrowedStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return BookReturnList(
                                returnList: snapshot.data.status);
                          }
                          return Center(
                              child: SpinKitWave(
                            color: Theme.of(context).accentColor,
                          ));
                        }),
                  ),
                  Container(
                    child: FutureBuilder<Borrow>(
                        future: borrowedStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return BookReservationList(
                                reservationList: snapshot.data.status);
                          }
                          return Center(
                              child: SpinKitWave(
                            color: Theme.of(context).accentColor,
                          ));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

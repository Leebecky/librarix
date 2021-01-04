import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/user.dart';
import 'booking_list.dart';
import 'borrowed_list.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>
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
                  text: 'Booking',
                ),
                Tab(
                  text: 'Borrowed Book',
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: FutureBuilder<ActiveUser>(
                        future: myActiveUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return BookingList(bList: snapshot.data.userId);
                          }
                          return Center(
                              child: SpinKitWave(
                            color: Theme.of(context).accentColor,
                          ));
                        }),
                  ),
                  Container(
                    child: FutureBuilder<ActiveUser>(
                        future: myActiveUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return BorrowedList(
                                borrowedList: snapshot.data.userId);
                          }
                          return Center(
                              child: SpinKitWave(
                            color: Theme.of(context).accentColor,
                          ));
                        }),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

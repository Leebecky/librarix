import 'package:flutter/material.dart';
import 'discussion_room_list.dart';
import 'study_table_list.dart';

class UpdateBooking extends StatefulWidget {
  @override
  _UpdateBookingState createState() => _UpdateBookingState();
}

class _UpdateBookingState extends State<UpdateBooking>
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
                  text: "Study Table",
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    child: DiscussionRoomList(),
                  ),
                  Container(
                    child: StudyTableList(),
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

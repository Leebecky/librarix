import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './booking_list.dart';

class HistoryView extends StatefulWidget {

  //final DocumentSnapshot booking;
  //HistoryView({this.booking});

  //final List<DocumentSnapshot> bList;
  //final int index;

  //const HistoryView({Key key, this.bList, this.index}) : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>with SingleTickerProviderStateMixin {
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("User").snapshots(),
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(
                            child: SpinKitWave(
                              color: Theme.of(context).accentColor,
                            )
                          );
                        }else{
                          return ListView.builder(
                            itemCount: snapshot.data.docs.length, 
                            itemBuilder: (_, index){
                              List<DocumentSnapshot> bookings = snapshot.data.docs;
                              return BookingList(bList: bookings, index: index);
                            }
                          );
                        }
                      }
                  ),
                ),
                  Container(child: Center(child: Text('Person'))),
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

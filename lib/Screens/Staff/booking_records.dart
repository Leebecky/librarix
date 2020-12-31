import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Models/booking.dart';

class BookingRecords extends StatelessWidget {
  final List<Booking> myBooking = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Record"),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
            future: getBooking(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null) {
                return SpinKitWave(
                  color: Theme.of(context).accentColor,
                );
              } else {
                snapshot.data.docs.forEach((doc) {
                  myBooking.add(bookingFromJson(doc.data()));
                });
                return ListView.builder(
                  itemCount: myBooking.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border:
                                new Border(right: new BorderSide(width: 1.0))),
                        child:
                            (myBooking[index].bookingType == "Discussion Room")
                                ? Icon(Icons.meeting_room)
                                : Icon(Icons.self_improvement),
                      ),
                      title: Text(
                        myBooking[index].roomOrTableNum,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(myBooking[index].userId),
                          )),
                          Text(
                            myBooking[index].bookingStartTime +
                                " - " +
                                myBooking[index].bookingEndTime,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

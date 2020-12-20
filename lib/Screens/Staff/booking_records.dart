import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Models/booking.dart';

class BookingRecords extends StatelessWidget {
  List<Booking> myBooking = [];

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
                return Center(
                    child: Text(
                  "Loading ... ",
                  textAlign: TextAlign.center,
                ));
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
                            border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.blueGrey))),
                        child:
                            Icon(Icons.meeting_room, color: Colors.grey[600]),
                      ),
                      title: Text(
                        myBooking[index].roomOrTableNum,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              myBooking[index].userId + "  |  TeohXP",
                              style: TextStyle(color: Colors.black),
                            ),
                          )),

                          //wanna make it to the new line
                          Text(
                            // "Timing: " +
                            myBooking[index].bookingStartTime +
                                " - " +
                                myBooking[index].bookingEndTime,
                            style: TextStyle(color: Colors.black),
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

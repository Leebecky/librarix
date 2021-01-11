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
                    return Column(
                      children: <Widget>[
                        Container(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    right: new BorderSide(
                                                        width: 2.0,
                                                        color:
                                                            Colors.blueGrey))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: (myBooking[index]
                                                          .bookingType ==
                                                      "Discussion Room")
                                                  ? Icon(
                                                      Icons.meeting_room,
                                                      size: 30,
                                                    )
                                                  : Icon(
                                                      Icons.self_improvement,
                                                      size: 30,
                                                    ),
                                            ),
                                          ),
                                          Text(
                                              "   " +
                                                  myBooking[index]
                                                      .roomOrTableNum,
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 4.0, right: 100),
                                    child: Row(
                                      children: [
                                        Text(
                                            "               " +
                                                myBooking[index].userId,
                                            style: TextStyle(fontSize: 19)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: [
                                        Text(
                                            "               " +
                                                myBooking[index]
                                                    .bookingStartTime +
                                                " - " +
                                                myBooking[index].bookingEndTime,
                                            style: TextStyle(fontSize: 18)),
                                        Text("  |  ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.blueGrey)),
                                        Text(myBooking[index].bookingDate,
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: [
                                        Text(
                                            "               " +
                                                myBooking[index].bookingStatus,
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // child: Padding(
                          //   padding: const EdgeInsets.all(5),
                          //   child: Column(
                          //     children: <Widget>[
                          //       Card(
                          //         child: ListTile(
                          //           leading: Container(
                          //             padding: EdgeInsets.all(10),
                          //             decoration: new BoxDecoration(
                          //                 border: new Border(
                          //                     right: new BorderSide(
                          //                         width: 2.0,
                          //                         color: Colors.blueGrey))),
                          //             child: (myBooking[index].bookingType ==
                          //                     "Discussion Room")
                          //                 ? Icon(
                          //                     Icons.meeting_room,
                          //                     size: 32,
                          //                   )
                          //                 : Icon(
                          //                     Icons.self_improvement,
                          //                     size: 32,
                          //                   ),
                          //           ),
                          //           title: Text(
                          //             myBooking[index].roomOrTableNum,
                          //             style: TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 20,
                          //             ),
                          //           ),
                          //           subtitle: Row(
                          //             children: <Widget>[
                          //               Expanded(
                          //                   child: Padding(
                          //                 padding:
                          //                     EdgeInsets.only(top: 5, left: 5),
                          //                 child: Text(
                          //                   myBooking[index].userId,
                          //                   style: TextStyle(fontSize: 18),
                          //                 ),
                          //               )),
                          //               Text(
                          //                 myBooking[index].bookingStartTime +
                          //                     " - " +
                          //                     myBooking[index].bookingEndTime,
                          //                 style: TextStyle(fontSize: 18),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        )
                      ],
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

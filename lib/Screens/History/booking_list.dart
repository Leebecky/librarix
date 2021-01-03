import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/booking.dart';

class BookingList extends StatefulWidget {
  final String bList;
  const BookingList({Key key, this.bList}) : super(key: key);

  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Booking>>(
        stream: getBookingsWithDocIdOf("UserId", widget.bList),
        builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Column(
                      children: [
                    Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 4.0),
                                child: Row(children: <Widget>[
                                  Text(
                                    snapshot.data[index].roomOrTableNum,
                                    style: TextStyle(fontSize: 35.0),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          iconSize: 35.0,
                                          onPressed: () {
                                            return showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Cancel Booking'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            "Do you want to cancel this booking?"),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        child: Text("Yes"),
                                                        onPressed: () async {
                                                          if (snapshot
                                                                  .data[index]
                                                                  .bookingStatus ==
                                                              "Active") {
                                                            updateBookingCancelledStatus(
                                                                snapshot
                                                                    .data[index]
                                                                    .bookingId);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                      title: Text(
                                                                          "Warning!"),
                                                                      content: Text(
                                                                          "You are not valid to cancel this booking because it's over time"),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          child:
                                                                              Text("OK"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ]);
                                                                });
                                                          }
                                                        }),
                                                    TextButton(
                                                        child: Text("Cancel"),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop())
                                                  ],
                                                );
                                              },
                                            );
                                          }),
                                    ],
                                  )
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4.0),
                                child: Row(children: <Widget>[
                                  Text(
                                    snapshot.data[index].bookingDate,
                                    style: TextStyle(fontSize: 25.0),
                                  ),
                                  Spacer(),
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 30.0),
                                child: Row(children: <Widget>[
                                  Text(
                                    snapshot.data[index].bookingStatus,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  Spacer(),
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index].bookingStartTime,
                                      style: TextStyle(fontSize: 30.0),
                                    ),
                                    Text(" - "),
                                    Text(
                                      snapshot.data[index].bookingEndTime,
                                      style: TextStyle(fontSize: 30.0),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ].toList());
                });
          }
          return SpinKitWave(
            color: Theme.of(context).accentColor,
          );
        });
  }

  Future<void> updateBookingStatus(String docId) async {
    FirebaseFirestore.instance
        .collection("Booking")
        .doc(docId)
        .update({"BookingStatus": "Cancelled"})
        .then((value) => print("Booking has been cancelled successfully!"))
        .catchError((onError) => print("An error has occurred: $onError"));
  }
}

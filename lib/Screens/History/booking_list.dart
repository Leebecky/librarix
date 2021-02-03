import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Models/booking.dart';
import '../../Models/notifications.dart';
import '../Notifications/notifications_build.dart';

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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 4.0),
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
                                        return actionAlertDialog(
                                          context,
                                          title: "Cancel Booking",
                                          content:
                                              "Do you want to cancel this booking?",
                                          onPressed: () async {
                                            if (snapshot.data[index]
                                                    .bookingStatus ==
                                                "Booked") {
                                              updateBookingStatus(
                                                  snapshot
                                                      .data[index].bookingId,
                                                  "Cancelled");

                                              //~ Delete the notification
                                              await deleteNotification(
                                                  userId: widget.bList,
                                                  hasId: false,
                                                  queryItem: snapshot
                                                      .data[index].bookingId);
                                              //~ Cancel any pending notifications
                                              if (snapshot.data[index]
                                                      .bookingType ==
                                                  "Discussion Room") {
                                                await cancelNotification(1);
                                                cancelNotification(2);
                                              } else {
                                                await cancelNotification(3);
                                                cancelNotification(4);
                                              }
                                              Navigator.of(context).pop();
                                            } else if (snapshot.data[index]
                                                    .bookingStatus ==
                                                "Completed") {
                                              customAlertDialog(context,
                                                  title: "Invalid Selection",
                                                  content:
                                                      "This booking has already been completed!",
                                                  navigateHome: true);
                                            } else if (snapshot.data[index]
                                                    .bookingStatus ==
                                                "Cancelled") {
                                              customAlertDialog(context,
                                                  title: "Invalid Selection",
                                                  content:
                                                      "This booking has already been cancelled!",
                                                  navigateHome: true);
                                            }
                                          },
                                        );
                                      },
                                    )
                                  ],
                                )
                              ]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: Text(
                                snapshot.data[index].bookingDate,
                                style: TextStyle(fontSize: 25.0),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 30.0),
                              child: Text(
                                snapshot.data[index].bookingStatus,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Text(
                                  "${snapshot.data[index].bookingStartTime} - ${snapshot.data[index].bookingEndTime}",
                                  style: TextStyle(fontSize: 30.0),
                                )),
                          ],
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
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/booking.dart';

class StudyTableList extends StatefulWidget {
  @override
  _StudyTableListState createState() => _StudyTableListState();
}

class _StudyTableListState extends State<StudyTableList> {
  List<Booking> activeBookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Booking>>(
        stream: getBookingsWithDocIdOf("BookingType", "Study Table"),
        builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
          if (snapshot.hasData) {
            activeBookings = snapshot.data
                .where((details) =>
                    details.bookingStatus ==
                        "Booked" || //update to active / cancelled
                    details.bookingStatus == "Active") //active to completed
                .toList();
            return ListView.builder(
                itemCount: activeBookings.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: <Widget>[
                      Container(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        activeBookings[index].roomOrTableNum,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28),
                                      ),
                                      Spacer(),
                                      Column(
                                        children: actionButtons(index),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(activeBookings[index].userId,
                                          style: TextStyle(fontSize: 24))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(activeBookings[index].bookingDate,
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                          activeBookings[index]
                                                  .bookingStartTime +
                                              " - " +
                                              activeBookings[index]
                                                  .bookingEndTime,
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(activeBookings[index].bookingStatus,
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
          }
          return SpinKitWave(
            color: Theme.of(context).accentColor,
          );
        },
      ),
    );
  }

  List<Widget> actionButtons(int index) {
    List<Widget> buttons = [];
    if (activeBookings[index].bookingStatus == "Active") {
      buttons.add(IconButton(
        icon: Icon(Icons.done_sharp),
        onPressed: () {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Study Table Booking Completed',
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[Text("Close this booking?")],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes"),
                      onPressed: () async {
                        updateBookingStatus(
                            activeBookings[index].bookingId, "Completed");
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
      ));
    } else if (activeBookings[index].bookingStatus == "Booked") {
      buttons.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //booked => cancelled
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                return showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Cancel Study Table Booking',
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[Text("Cancel this booking?")],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              updateBookingStatus(
                                  activeBookings[index].bookingId, "Cancelled");

                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
            Container(
              width: 20.0,
            ),
            //booked => active
            IconButton(
              icon: Icon(Icons.update),
              onPressed: () {
                return showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Activate Study Table Booking',
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text("Check-in for Study Table?")
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              updateBookingStatus(
                                  activeBookings[index].bookingId, "Active");
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ]);
    }
    return buttons;
  }
}

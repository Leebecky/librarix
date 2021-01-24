import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Models/notifications.dart';
import 'package:librarix/Screens/Notifications/notifications_build.dart';
import 'package:librarix/modules.dart';
import 'package:librarix/Models/borrow.dart';

class BorrowedList extends StatefulWidget {
  final DocumentSnapshot borrow;

  final String borrowedList;
  const BorrowedList({Key key, this.borrowedList, this.borrow})
      : super(key: key);

  @override
  _BorrowedListState createState() => _BorrowedListState();
}

class _BorrowedListState extends State<BorrowedList> {
  // List<Borrow> records = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Borrow>>(
        stream: getBorrowedWithDocIdOf("UserId", widget.borrowedList),
        builder: (BuildContext context, AsyncSnapshot<List<Borrow>> snapshot) {
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
                                    snapshot.data[index].bookTitle,
                                    style: TextStyle(fontSize: 25.0),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.refresh),
                                          iconSize: 30.0,
                                          onPressed: () {
                                            return showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Renew Borrowed Book'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            "Do you wish to extend the borrow period?"),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        child: Text("Yes"),
                                                        onPressed: () async {
                                                          //~ Obtain notification Id
                                                          int notifId = await searchNotification(
                                                                  userId: widget
                                                                      .borrowedList,
                                                                  queryField:
                                                                      "NotificationAdditionalDetail",
                                                                  queryItem: snapshot
                                                                      .data[
                                                                          index]
                                                                      .borrowedId)
                                                              .then((value) =>
                                                                  value[0]
                                                                      .id
                                                                      .hashCode);
                                                          //~ Renew Book
                                                          if (snapshot
                                                                  .data[index]
                                                                  .status ==
                                                              "Borrowed") {
                                                            if (snapshot
                                                                    .data[index]
                                                                    .timesRenewed <
                                                                2) {
                                                              updateBookRenewedTimes(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .borrowedId);
                                                              updateBorrowedBookReturnedDate(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .borrowedId,
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .returnedDate);

                                                              //~ Resets notifications for book return
                                                              await cancelNotification(
                                                                  notifId);
                                                              //~ Schedules a new notification
                                                              await bookReturnNotification(
                                                                  returnDate: parseDate(
                                                                      calculateReturnDate(snapshot
                                                                          .data[
                                                                              index]
                                                                          .returnedDate)),
                                                                  title: snapshot
                                                                      .data[
                                                                          index]
                                                                      .bookTitle,
                                                                  notificationId:
                                                                      notifId);

                                                              //~ Updates the notification record
                                                              await updateBookReturnNotification(
                                                                  userId: widget
                                                                      .borrowedList,
                                                                  newDate: parseDate(parseStringToDate(parseDate(calculateReturnDate(snapshot
                                                                          .data[
                                                                              index]
                                                                          .returnedDate)))
                                                                      .subtract(Duration(
                                                                          days:
                                                                              3))
                                                                      .toString()),
                                                                  borrowedId: snapshot
                                                                      .data[
                                                                          index]
                                                                      .borrowedId,
                                                                  bookTitle: snapshot
                                                                      .data[
                                                                          index]
                                                                      .bookTitle,
                                                                  returnDate: parseDate(
                                                                      calculateReturnDate(snapshot
                                                                          .data[index]
                                                                          .returnedDate)));

                                                              //~ Message
                                                              customAlertDialog(
                                                                  context,
                                                                  title:
                                                                      "Renew Borrowed Book",
                                                                  content:
                                                                      "Borrowed book period successfully extended!");
                                                            } else if (snapshot
                                                                    .data[index]
                                                                    .timesRenewed >
                                                                2) {
                                                              customAlertDialog(
                                                                  context,
                                                                  title:
                                                                      "Failed to Renew Borrowed Book",
                                                                  content:
                                                                      "Renew limit reached! This book can no longer be renewed.");
                                                            }
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
                                                                          "This book cannot be renewed!"),
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
                                    snapshot.data[index].status,
                                    style: TextStyle(fontSize: 20.0),
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
                                      snapshot.data[index].borrowedDate,
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Text(" - "),
                                    Text(
                                      snapshot.data[index].returnedDate,
                                      style: TextStyle(fontSize: 18.0),
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

  //? Update the BorrowRenewTimes
  Future<void> updateBookRenewedTimes(String docId) async {
    FirebaseFirestore.instance
        .collection("BorrowedBook")
        .doc(docId)
        .update({"BorrowRenewedTimes": FieldValue.increment(1)})
        .then((value) =>
            print("Borrowed book renew times has been updated successfully!"))
        .catchError((onError) => print("An error has occurred: $onError"));
  }

  //?Update the BorrowReturnedDate
  Future<void> updateBorrowedBookReturnedDate(String docId, String date) async {
    FirebaseFirestore.instance
        .collection("BorrowedBook")
        .doc(docId)
        .update({"BorrowReturnedDate": parseDate(calculateReturnDate(date))})
        .then((value) =>
            print("Borrowed book returned date has been renewed successfully!"))
        .catchError((onError) => print("An error has occurred: $onError"));
  }

  //?Calculate the return date
  String calculateReturnDate(String date) {
    DateTime startDate = parseStringToDate(date);
    DateTime returnDate = startDate.add(Duration(days: 6));

    //^ Checks if the returnDate lands on a weekend and extends it to Monday if so
    if (returnDate.weekday == DateTime.saturday) {
      returnDate = returnDate.add(Duration(days: 2));
    } else if (returnDate.weekday == DateTime.sunday) {
      returnDate = returnDate.add(Duration(days: 1));
    }
    return returnDate.toString();
  }
}

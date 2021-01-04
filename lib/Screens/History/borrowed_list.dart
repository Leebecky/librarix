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
  List<Borrow> records = [];

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
                                                      'Renew Borrow Status'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            "Do you want to extend the borrow period?"),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        child: Text("Yes"),
                                                        onPressed: () async {
                                                          //~ Obtain notification Id
                                                          int notifId = await searchNotification(
                                                                  widget
                                                                      .borrowedList,
                                                                  "NotificationAdditionalDetail",
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .bookId)
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
                                                                      .borrowedId);

                                                              //~ Resets notifications for book return
                                                              cancelNotification(
                                                                  notifId);
                                                              //~ Schedules a new notification
                                                              bookReturnNotification(
                                                                  returnDate:
                                                                      parseDate(
                                                                          calculateReturnDate()),
                                                                  title: snapshot
                                                                      .data[
                                                                          index]
                                                                      .bookTitle,
                                                                  notificationId:
                                                                      notifId);

                                                              //~ Updates the notification record
                                                              updateBookReturnNotification(
                                                                  userId: widget
                                                                      .borrowedList,
                                                                  newDate: parseDate(parseStringToDate(
                                                                          parseDate(
                                                                              calculateReturnDate()))
                                                                      .subtract(
                                                                          Duration(
                                                                              days:
                                                                                  3))
                                                                      .toString()),
                                                                  bookId: snapshot
                                                                      .data[
                                                                          index]
                                                                      .bookId);

                                                              //~ Message
                                                              customAlertDialog(
                                                                  context,
                                                                  title:
                                                                      "Renew Borrowed Book",
                                                                  content:
                                                                      "You have renewed your borrowed book period sucessfully");
                                                            } else if (records
                                                                    .length >=
                                                                2) {
                                                              customAlertDialog(
                                                                  context,
                                                                  title:
                                                                      "Failed To Renew Borrowed Book",
                                                                  content:
                                                                      "You are not able to renew your borrowed book period because already over the renew times limit.");
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
                                                                          "You are not valid to renew this booking because it's over time"),
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
  Future<void> updateBorrowedBookReturnedDate(String docId) async {
    FirebaseFirestore.instance
        .collection("BorrowedBook")
        .doc(docId)
        .update({"BorrowReturnedDate": parseDate(calculateReturnDate())})
        .then((value) =>
            print("Borrowed book returned date has been renewed successfully!"))
        .catchError((onError) => print("An error has occurred: $onError"));
  }

  //?Calculate the return date
  String calculateReturnDate() {
    DateTime startDate = DateTime.now();
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

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
                                          return actionAlertDialog(context,
                                              title: "Renew Borrowed Book",
                                              content:
                                                  "Do you wish to extend the borrow period?",
                                              onPressed: () async {
                                            //~ Obtain notification Id
                                            int notifId = await searchNotification(
                                                    userId: widget.borrowedList,
                                                    queryField:
                                                        "NotificationAdditionalDetail",
                                                    queryItem: snapshot
                                                        .data[index].borrowedId)
                                                .then((value) =>
                                                    value[0].id.hashCode);
                                            //~ Renew Book
                                            if (snapshot.data[index].status ==
                                                "Borrowed") {
                                              if (snapshot.data[index]
                                                      .timesRenewed <
                                                  2) {
                                                updateBookRenewedTimes(snapshot
                                                    .data[index].borrowedId);
                                                updateBorrowedBookReturnedDate(
                                                    snapshot
                                                        .data[index].borrowedId,
                                                    snapshot.data[index]
                                                        .returnedDate);

                                                //~ Resets notifications for book return
                                                await cancelNotification(
                                                    notifId);
                                                //~ Schedules a new notification
                                                await bookReturnNotification(
                                                    returnDate: parseDate(
                                                        calculateRenewedReturnDate(
                                                            snapshot.data[index]
                                                                .returnedDate)),
                                                    title: snapshot
                                                        .data[index].bookTitle,
                                                    notificationId: notifId);

                                                //~ Updates the notification record
                                                await updateBookReturnNotification(
                                                    userId: widget.borrowedList,
                                                    newDate: parseDate(parseStringToDate(
                                                            calculateRenewedReturnDate(
                                                                snapshot
                                                                    .data[index]
                                                                    .returnedDate))
                                                        .subtract(
                                                            Duration(days: 3))
                                                        .toString()),
                                                    borrowedId: snapshot
                                                        .data[index].borrowedId,
                                                    bookTitle: snapshot
                                                        .data[index].bookTitle,
                                                    returnDate: parseDate(
                                                        calculateRenewedReturnDate(
                                                            snapshot.data[index]
                                                                .returnedDate)));

                                                //~ Message
                                                customAlertDialog(context,
                                                    title:
                                                        "Renew Borrowed Book",
                                                    content:
                                                        "Borrowed book period successfully extended!");
                                              } else if (snapshot.data[index]
                                                      .timesRenewed >
                                                  2) {
                                                customAlertDialog(context,
                                                    title:
                                                        "Failed to Renew Borrowed Book",
                                                    content:
                                                        "Renew limit reached! This book can no longer be renewed.");
                                              }
                                            } else {
                                              return customAlertDialog(context,
                                                  title: "Warning!",
                                                  content:
                                                      "This book cannot be renewed!");
                                            }
                                          });
                                        })
                                  ],
                                )
                              ]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: Text(
                                snapshot.data[index].status,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                "${snapshot.data[index].borrowedDate} - ${snapshot.data[index].returnedDate}",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            )
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

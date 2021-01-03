import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/borrow.dart';

class BookReservationList extends StatefulWidget {
  @override
  _BookReservationListState createState() => _BookReservationListState();
}

class _BookReservationListState extends State<BookReservationList> {
  List<Borrow> activeReserve = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Borrow>>(
        stream: getBorrowedWithDocIdOf("BorrowStatus", "Reserved"),
        builder: (BuildContext context, AsyncSnapshot<List<Borrow>> snapshot) {
          if (snapshot.hasData) {
            activeReserve = snapshot.data.toList();
            return ListView.builder(
                itemCount: activeReserve.length,
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
                                        activeReserve[index].bookTitle,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23),
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
                                      Text(activeReserve[index].userId,
                                          style: TextStyle(fontSize: 22)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                          activeReserve[index].borrowedDate +
                                              " - " +
                                              activeReserve[index].returnedDate,
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(activeReserve[index].status,
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
    buttons.addAll([
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Cancel Reserved Book',
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("Wanted to cancel reserved book?")
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () async {
                          updateCancelStatus(activeReserve[index].borrowedId);
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
          width: 15.0,
        ),
        IconButton(
          icon: Icon(Icons.update),
          onPressed: () {
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Update Reserved Book',
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[Text("Borrow reserved book?")],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () async {
                          updateBorrowStatus(activeReserve[index].borrowedId);
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
      ]),
    ]);
    return buttons;
  }
}

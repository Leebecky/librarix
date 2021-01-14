import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/borrow.dart';
import '../../../Models/notifications.dart';
import '../../../modules.dart';
import 'fines_add.dart';

class BookReturnList extends StatefulWidget {
  @override
  _BookReturnListState createState() => _BookReturnListState();
}

class _BookReturnListState extends State<BookReturnList> {
  List<Borrow> activeReserve = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Borrow>>(
        stream: getBorrowedWithDocIdOf("BorrowStatus", "Borrowed"),
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
    buttons.add(IconButton(
      icon: Icon(Icons.update),
      onPressed: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Return Book',
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("Book Returned?")],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      updateReturnStatus(activeReserve[index].borrowedId,
                          activeReserve[index].bookId);
                      return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Fines',
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text("Does the user need to be fined?"),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return AddFines(
                                          activeReserve[index].userId);
                                    }));
                                  },
                                ),
                                TextButton(
                                  child: Text("No"),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return BookReturnList();
                                    // }));
                                  },
                                ),
                              ],
                            );
                          });
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
    return buttons;
  }
}

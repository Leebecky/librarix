import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/borrow.dart';

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
}

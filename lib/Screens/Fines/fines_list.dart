import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Models/fines.dart';

class FinesList extends StatefulWidget {
  final String finesList;

  const FinesList({Key key, this.finesList}) : super(key: key);

  @override
  _FinesListState createState() => _FinesListState();
}

class _FinesListState extends State<FinesList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getFinesOf("UserId", widget.finesList),
      builder: (BuildContext context, AsyncSnapshot<List<Fines>> snapshot) {
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
                                child: Row(
                                  children: [
                                    Text(
                                      "RM ${snapshot.data[index].total}",
                                      style: TextStyle(fontSize: 35.0),
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.info_outline),
                                          iconSize: 35.0,
                                          onPressed: () async {
                                            if (snapshot.data[index].status ==
                                                "Unpaid") {
                                              return customAlertDialog(context,
                                                  title: "Reminder",
                                                  content:
                                                      "You need to settle your payment at the counter before the due date.");
                                            } else if (snapshot
                                                    .data[index].status ==
                                                "Paid") {
                                              return customAlertDialog(context,
                                                  title: "Info",
                                                  content:
                                                      "You have paid the fines successfully!");
                                            } else {
                                              return customAlertDialog(context,
                                                  title: "Warning",
                                                  content:
                                                      "Your fee is overdue, please settle it as soon as possible.");
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4.0),
                                child: Row(
                                  children: [
                                    Text(
                                      snapshot.data[index].reason,
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 30.0),
                                child: Row(
                                  children: [
                                    Text(
                                      snapshot.data[index].status,
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Row(
                                  children: [
                                    Text(snapshot.data[index].dueDate,
                                        style: TextStyle(fontSize: 30.0)),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        }
        return SpinKitWave(color: Theme.of(context).accentColor);
      },
    );
  }
}

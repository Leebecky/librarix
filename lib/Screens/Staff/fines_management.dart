import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Models/fines.dart';

class FinesManagement extends StatefulWidget {
  @override
  _FinesManagementState createState() => _FinesManagementState();
}

class _FinesManagementState extends State<FinesManagement> {
  List<Fines> activeFines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fines Management"),
      ),
      body: StreamBuilder<List<Fines>>(
        stream: getFinesWithDocIdOf("FinesStatus", "Unpaid"),
        builder: (BuildContext context, AsyncSnapshot<List<Fines>> snapshot) {
          if (snapshot.hasData) {
            activeFines = snapshot.data.toList();
            return ListView.builder(
                itemCount: activeFines.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 4.0),
                                child: Row(
                                  children: [
                                    Text(
                                      activeFines[index].userId,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
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
                                child: Text(
                                  "RM " + activeFines[index].total,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 4.0),
                                child: Text(
                                  "Issue Date: " + activeFines[index].issueDate,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 4.0),
                                child: Text(
                                  "Reason : " + activeFines[index].reason,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
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
        return actionAlertDialog(
          context,
          title: "Fines Management",
          content: "Paying fines?",
          onPressed: () async {
            updateFinesPaidStatus(activeFines[index].finesId);
            Navigator.of(context).pop();
            return customAlertDialog(context,
                title: "Fines Management", content: "Fines payment received");
          },
        );
      },
    ));
    return buttons;
  }
}

Future<void> updateFinesPaidStatus(String docId) async {
  FirebaseFirestore.instance
      .collection("Fines")
      .doc(docId)
      .update({"FinesStatus": "Paid"});
}

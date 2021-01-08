import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
                                  child: Row(
                                    children: [
                                      Text(
                                        "RM " + activeFines[index].total,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Due Date: " +
                                            activeFines[index].dueDate,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Reason : " + activeFines[index].reason,
                                        style: TextStyle(fontSize: 16),
                                      ),
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
                  'Paid Fines',
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text("Paying fines?")],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      updateFinesPaidStatus(activeFines[index].finesId);
                      return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Received'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Receive Fines Payment Succesfully'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () async {
                                  //   Navigator.push(context,
                                  //       MaterialPageRoute(builder: (context) {
                                  //     return FinesManagement();
                                  //   }));
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
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

Future<void> updateFinesPaidStatus(String docId) async {
  FirebaseFirestore.instance
      .collection("Fines")
      .doc(docId)
      .update({"FinesStatus": "Paid"});
}

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
        stream: getFinesOf("FinesStatus", "Unpaid"),
        builder: (BuildContext context, AsyncSnapshot<List<Fines>> snapshot) {
          if (snapshot.hasData) {
            activeFines = snapshot.data.toList();
            return ListView.builder(
                itemCount: activeFines.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      Container(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    activeFines[index].userId,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
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

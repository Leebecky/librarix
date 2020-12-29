import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookingList extends StatelessWidget{
  final List<DocumentSnapshot> bList;
  final int index;

  const BookingList({Key key, this.bList, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("Booking").where('UserId', isEqualTo: bList[index]['UserId']).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: SpinKitWave(
              color: Theme.of(context).accentColor,
            )
          );
        }else{
          return Column(
            children: snapshot.data.docs.map((DocumentSnapshot document){
              return Container(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Row(children: <Widget>[
                            Text(document['BookingType'], style: TextStyle(fontSize: 35.0),),
                            Text(document["Room/TableNum"], style: TextStyle(fontSize: 35.0),),
                            Spacer(),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 60.0),
                          child: Row(children: <Widget>[
                            Text(document['BookingDate'], style: TextStyle(fontSize: 25.0),),
                            Spacer(),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text(document['BookingStartTime'], style: TextStyle(fontSize: 30.0),),
                              Text(" - "),
                              Text(document['BookingEndTime'], style: TextStyle(fontSize: 30.0),),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
                  
            }).toList(),
          );
        }
      },);
  }
}
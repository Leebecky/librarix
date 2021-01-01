import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/user.dart';
import 'fines_list.dart';

class Fines extends StatefulWidget{
  @override
  _FinesState createState() => _FinesState();
}

class _FinesState extends State<Fines> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fines"),
      ),
      body: Container(
        child: FutureBuilder(
          future: myActiveUser(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return FinesList(finesList: snapshot.data.userId);
            }
            else{
              return SpinKitWave(color: Theme.of(context).accentColor);
            }
          },),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:librarix/Models/librarian.dart';
import '../Models/user.dart';
// import '../Screens/BookManagement.dart';

//! This entire page consists of placeholder testers
//! Will be deleted upon completion of application so don't implement anything here!

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

class NotificationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Menu placeholder"));
  }
}

class BookingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
    );
  }
}

class TestProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: FutureBuilder<DocumentSnapshot>(
          future: getActiveUser(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Oops, user does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final ActiveUser activeUser =
                  ActiveUser.fromJson(snapshot.data.data());
              return Center(
                  child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child:
                      Text(activeUser.userId, style: TextStyle(fontSize: 20)),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    activeUser.avatar,
                    height: 200,
                  ),
                )
              ]));
            }
            return Text("Loading your details");
          },
        ));
  }
}

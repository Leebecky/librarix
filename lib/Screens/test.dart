import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:librarix/Models/librarian.dart';
import '../Models/user.dart';

//! This entire page consists of placeholder testers
//! Will be deleted upon completion of application so don't implement anything here!
class GetBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference books =
        FirebaseFirestore.instance.collection('BookCatalogue');

    return StreamBuilder<QuerySnapshot>(
      stream: books.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document.data()['BookTitle']),
              subtitle: new Text(document.data()['BookDescription']),
            );
          }).toList(),
        );
      },
    );
  }
}

//^ Test for displaying images
class DisplayImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        child: Image.network(
            'https://www.oxfordfajar.com.my/img_m/cover_2017_secondary/whizz_thru/english_/201805241523278950_Cover-20Whizz-20Thru-20SPM-20Chem-20copy.jpg'));
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Menu placeholder");
  }
}

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Notification page placeholder"),
    );
  }
}

class Booking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Booking placeholder"),
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

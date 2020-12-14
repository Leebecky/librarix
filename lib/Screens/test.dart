import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/user.dart';

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

//for displaying images
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
    return Center(
      child: Column(children: [
        Text("Menu page placeholder"),
      ]),
    );
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

class TestActiveUser {
  final activeUser = getActiveUser();
  // @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: activeUser, builder: null);
  }
}

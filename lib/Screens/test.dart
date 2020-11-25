import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              title: new Text(document.data()['Title']),
              subtitle: new Text(document.data()['ISBNCode']),
            );
          }).toList(),
        );
      },
    );
  }
}

//for displaying images
/* Image.network(
            'https://user-images.githubusercontent.com/55550611/100253364-f9997a00-2f7b-11eb-9c4a-7f8607d4d248.jpg') */

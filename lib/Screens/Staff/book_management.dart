// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Models/book.dart';
import 'package:librarix/Models/librarian.dart';

class BookManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book Management"),
      ),
    );
  }
}

class BookManagemenListView extends StatelessWidget {
  List<Book> myBook = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
          future: getBook(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null) {
              return Center(
                  child: Text(
                "Loading ... ",
                textAlign: TextAlign.center,
              ));
            } else {
              snapshot.data.docs.forEach((doc) {
                  myBook.add(bookFromJson(doc.data()));
                });
                return ListView.builder(
                  itemCount: myBook.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return https://api.flutter.dev/flutter/material/ListTile-class.html
                  }
                  );
                },
              );
            }
          }),
    );
  }
}

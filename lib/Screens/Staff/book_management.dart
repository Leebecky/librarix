// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Models/librarian.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BookCatelogueListItem {
//   String bookAuthor;
//   String bookBarcode;
//   String bookDesc;
//   String bookGenre;
//   String bookISBN;
//   String bookImageURL;
//   String bookPublisherDate;
//   String bookPublisher;
//   String bookTitle;
//   int bookStock;

//   BookCatelogueListItem(
//       {this.bookAuthor,
//       this.bookBarcode,
//       this.bookDesc,
//       this.bookGenre,
//       this.bookISBN,
//       this.bookImageURL,
//       this.bookPublisher,
//       this.bookPublisherDate,
//       this.bookStock,
//       this.bookTitle});
// }

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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getLibrarian(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading ... ")));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                  );
                },
              );
            }
          }),
    );
  }
}

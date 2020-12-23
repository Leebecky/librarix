import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../loader.dart';
import 'book_management_detail_page.dart';
import 'book_management_add.dart';

class BookManagementListView extends StatefulWidget {
  @override
  _BookManagementListViewState createState() => _BookManagementListViewState();
}

class _BookManagementListViewState extends State<BookManagementListView> {
  Future getBook() async {
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot bookDetail =
        await firestore.collection("BookCatalogue").get();
    return bookDetail.docs;
  }

  navigateToBookManagementDetail(DocumentSnapshot bookCatalogue) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BookManagementDetailPage(bookCatalogue: bookCatalogue)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Management"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddNewBook();
          }));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getBook(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            } else {
              // snapshot.data.docs.forEach((doc) {
              //   myBook.add(bookFromJson(doc.data()));
              // });
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Image.network(
                            snapshot.data[index].data()['BookImage']),
                      ),
                      title: Text(
                        snapshot.data[index].data()['BookTitle'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        snapshot.data[index].data()['BookAuthor'],
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        navigateToBookManagementDetail(snapshot.data[index]);
                      },
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

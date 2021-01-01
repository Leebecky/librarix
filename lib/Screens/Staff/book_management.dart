import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:librarix/Screens/Staff/book_management_edit_book.dart';
import 'book_management_detail_page.dart';
import 'book_management_add.dart';

class BookManagementListView extends StatefulWidget {
  @override
  _BookManagementListViewState createState() => _BookManagementListViewState();
}

class _BookManagementListViewState extends State<BookManagementListView> {
  // Stream getBook() async {
  //   await Firebase.initializeApp();
  //   var firestore = FirebaseFirestore.instance;
  //   QuerySnapshot bookDetail =
  //       await firestore.collection("BookCatalogue").get();
  //   return bookDetail.docs;
  // }

  CollectionReference bookDb =
      FirebaseFirestore.instance.collection("BookCatalogue");

  navigateToBookManagementDetail(DocumentSnapshot bookCatalogue) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BookManagementDetailPage(bookCatalogue: bookCatalogue)));
  }

  navigateToEditBook(DocumentSnapshot bookCatalogue) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditBook(bookCatalogue: bookCatalogue)));
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
        child: StreamBuilder<QuerySnapshot>(
            stream: bookDb.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                // snapshot.data.docs.forEach((doc) {
                //   myBook.add(bookFromJson(doc.data()));
                // });
                return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    print(document.data()["BookImage"]);
                    return Container(
                      child: GestureDetector(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        document.data()['BookImage'],
                                        width: 170,
                                        height: 150,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  document.data()['BookTitle'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          navigateToBookManagementDetail(document);
                          // navigateToEditBook(document);
                        },
                      ),
                    );
                  }).toList(),
                );
              }
              return SpinKitWave(
                color: Theme.of(context).accentColor,
              );
            }),
      ),
    );
  }
}

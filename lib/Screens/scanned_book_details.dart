import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/book.dart';

class ScannedBookDetails extends StatefulWidget {
  final String bookCode, bookCodeType;
  ScannedBookDetails(this.bookCode, this.bookCodeType);
  @override
  _ScannedBookDetailsState createState() => _ScannedBookDetailsState();
}

class _ScannedBookDetailsState extends State<ScannedBookDetails> {
  //^ Database Collection reference
  final CollectionReference catalogueDb =
      FirebaseFirestore.instance.collection("BookCatalogue");

  //! TEST Variables
  List<Book> booksFound;
  Book myBook;
  int i;

  @override
  void initState() {
    i = 0;
    booksFound = [];
    print(widget.bookCodeType);
    print(widget.bookCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Books"),
        ),
        body: Center());
  }

  //? Search for book in catalogue based on scanned barcode/ISBN code
  Future<QuerySnapshot> searchCatalogue(
      String bookCode, String codeType) async {
    final QuerySnapshot bookdb = await FirebaseFirestore.instance
        .collection("BookCatalogue")
        .where(codeType, isEqualTo: bookCode)
        .get();
    if (int.parse(bookdb.docs.length.toString()) == 1) {
      bookdb.docs.forEach((doc) => {myBook = bookFromJson(doc.data())});
    } else if (int.parse(bookdb.docs.length.toString()) > 1) {
      bookdb.docs.forEach((doc) {
        booksFound.add(bookFromJson(doc.data()));
      });
    }
  }
}

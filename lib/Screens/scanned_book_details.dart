import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/book.dart';
import '../Custom_Widget/book_list_tile.dart';

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
    // print(widget.bookCodeType);
    // print(widget.bookCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: searchCatalogue(widget.bookCode, widget.bookCodeType),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            snapshot.data.docs
                .forEach((doc) => myBook = bookFromJson(doc.data()));

            //~ Display Books found
            return SingleChildScrollView(
                child: Column(
              children: [
                Card(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomBookTile(
                        title: myBook.title,
                        author: myBook.author,
                        stock: myBook.stock,
                        thumbnail: Container(
                          child: Image.network(myBook.image),
                        ))
                  ],
                )),
                Text("Return Date: "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: FlatButton(
                          onPressed: () => print("Accepted"),
                          child: Icon(Icons.check),
                          color: Colors.green,
                        )),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: FlatButton(
                          onPressed: () => print("Declined"),
                          child: Icon(Icons.clear),
                          color: Colors.red,
                        )),
                  ],
                )
              ],
            ));
          }

          return LinearProgressIndicator();
        },
      ),
    );
  }

  //? Search for book in catalogue based on scanned barcode/ISBN code
  Future<QuerySnapshot> searchCatalogue(
      String bookCode, String codeType) async {
    // try {
    final QuerySnapshot bookdb = await FirebaseFirestore.instance
        .collection("BookCatalogue")
        .where(codeType, isEqualTo: bookCode)
        .get();
    return bookdb;
//ToDo account for multiple books being returned
    /* if (int.parse(bookdb.docs.length.toString()) == 1) {
      bookdb.docs.forEach((doc) => {booksFound.add(bookFromJson(doc.data()))});
      return booksFound;
    } else if (int.parse(bookdb.docs.length.toString()) > 1) {
      bookdb.docs.forEach((doc) {
        booksFound.add(bookFromJson(doc.data()));
      });
    } */
    /* else {
        print("No books found");
      }
    } catch (e) {
      print("An error has occurred: $e");
    }
  } */
    // return booksFound;
  }

  void displayDescription(String description) {
    print(description);
  }
}

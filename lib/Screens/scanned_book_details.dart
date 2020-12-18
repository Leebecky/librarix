import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/book.dart';
import '../Custom_Widget/book_list_tile.dart';
import '../Models/borrow.dart';

//TODO what happens when there are multiple records returned

class ScannedBookDetails extends StatefulWidget {
  final String bookCode, bookCodeType, userId;
  ScannedBookDetails(this.bookCode, this.bookCodeType, this.userId);
  @override
  _ScannedBookDetailsState createState() => _ScannedBookDetailsState();
}

class _ScannedBookDetailsState extends State<ScannedBookDetails> {
  //^ Database Collection reference
  final CollectionReference catalogueDb =
      FirebaseFirestore.instance.collection("BookCatalogue");

  //^ List of Books returned from search query
  List<Book> booksFound;
  Borrow record;
  List<String> bookId;

  @override
  void initState() {
    booksFound = [];
    bookId = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Books"),
        ),
        body: FutureBuilder<List<Book>>(
            future: searchCatalogue(widget.bookCode, widget.bookCodeType),
            builder:
                (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
              //~ Display Book found
              if (snapshot.data.length == 1) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomBookTile(
                              title: booksFound[0].title,
                              author: booksFound[0].author,
                              stock: booksFound[0].stock,
                              thumbnail: Container(
                                child: Image.network(booksFound[0].image),
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
                                onPressed: () => createBorrowRecord(record),
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
                  ),
                );
              }

              //~  Selection screen when >1 book is returned from the database
              if (snapshot.data.length > 1) {
                return ListView.builder(
                    itemCount: booksFound.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Image.network(booksFound[i].image),
                        title: Text(booksFound[i].title),
                        subtitle: Text(booksFound[i].author),
                      );
                    });
              }

              //~ Error message when no book was found
              if (snapshot.data.length <= 0) {
                return Center(
                  child: Text(
                      "Sorry, no book matching the provided ${widget.bookCodeType} has been found. Please try again."),
                );
              }

              //~  Progress Indicator when data is buffering
              return LinearProgressIndicator();
            }));
  }

  //? Search for book in catalogue based on scanned barcode/ISBN code
  Future<List<Book>> searchCatalogue(String bookCode, String codeType) async {
    List<String> booksFoundId = [];
    try {
      final QuerySnapshot bookDb = await FirebaseFirestore.instance
          .collection("BookCatalogue")
          .where(codeType, isEqualTo: bookCode)
          .get();

      //^ Returns books matching the given barcode/isbn code and adds it to the booksFound list and the corresponding id to the booksFoundId list
      if (int.parse(bookDb.docs.length.toString()) >= 1) {
        bookDb.docs
            .forEach((doc) => {booksFound.add(bookFromJson(doc.data()))});
        bookDb.docs.forEach((doc) {
          booksFoundId.add(doc.id);
        });
      }

      setState(() {
        bookId = booksFoundId;
      });
    } catch (e) {
      print("An error has occurred: $e");
    }

    return booksFound;
  }

  void calculateReturnDate() {
    //TODO get current date, +6
  }

//? Creates the new borrow record (hopefully im really tired zzz)
  void createRecord(String startDate, String returnDate) {
    String userId = widget.userId;
    String borrowBookId = bookId[0];
    String borrowBookTitle = booksFound[0].title;
    Borrow newRecord;

    newRecord = Borrow(userId, borrowBookId, borrowBookTitle, startDate,
        returnDate, "Borrowed");

    setState(() {
      record = newRecord;
    });
  }
}

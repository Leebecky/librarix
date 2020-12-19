import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/book.dart';
import '../Custom_Widget/book_list_tile.dart';
import '../Models/borrow.dart';

//TODO what happens when there are multiple records returned and handle book stock = 0 as well!

class ScannedBookDetails extends StatefulWidget {
  //^ Parameters were passed form borrow_book_scanner.dart
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
  List<String> bookId;
  NavigatorState nav;

  @override
  void initState() {
    nav = Navigator.of(context);
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
                if (booksFound[0].stock > 0) {
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
                        Text(
                            "Return Date: ${parseDate(calculateReturnDate())}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                //~ Accept and borrow the book
                                padding: EdgeInsets.all(20),
                                child: FlatButton(
                                  onPressed: () async {
                                    if (await hasBorrowed()) {
                                      showDialog(
                                          context: context,
                                          child: AlertDialog(
                                              content: Text(
                                                  "You have currently borrowing this book!"),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Close"),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                )
                                              ]));
                                    } else {
                                      createBorrowRecord(createRecord(
                                          parseDate(DateTime.now().toString()),
                                          parseDate(calculateReturnDate())));
                                      nav.pop();
                                      nav.pop();
                                    }
                                  },
                                  child: Icon(Icons.check),
                                  color: Colors.green,
                                )),
                            Padding(
                                //~ Decline and return to home()
                                padding: EdgeInsets.all(20),
                                child: FlatButton(
                                  onPressed: () {
                                    nav.pop();
                                    nav.pop();
                                  },
                                  child: Icon(Icons.clear),
                                  color: Colors.red,
                                )),
                          ],
                        )
                      ],
                    ),
                  );
                } else if (booksFound[0].stock <= 0) {
                  //~ if the book is currently out of stock (in the case of entered ISBN)
                  return Column(children: [
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
                    FlatButton(
                      child: Text("Place Reservation"),
                      color: Colors.yellow,
                      onPressed: () => print("Reserved!"),
                    )
                  ]);
                }
              }
              //~  Selection screen when >1 book is returned from the database
              else if (snapshot.data.length > 1) {
                return ListView.builder(
                    itemCount: booksFound.length,
                    itemBuilder: (context, i) {
                      return ExpansionTile(
                        leading: Image.network(booksFound[i].image),
                        title: Text(booksFound[i].title),
                        children: [
                          Text(
                              "Return Date: ${parseDate(calculateReturnDate())}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  //~ Accept and borrow the book
                                  padding: EdgeInsets.all(20),
                                  child: FlatButton(
                                    onPressed: () async {
                                      if (await hasBorrowed()) {
                                        createBorrowRecord(createRecord(
                                            parseDate(
                                                DateTime.now().toString()),
                                            parseDate(calculateReturnDate())));
                                        nav.pop();
                                        nav.pop();
                                      } else {
                                        showDialog(
                                            context: context,
                                            child: AlertDialog(
                                                content: Text(
                                                    "You have currently borrowing this book!"),
                                                actions: [
                                                  FlatButton(
                                                    child: Text("Close"),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  )
                                                ]));
                                      }
                                    },
                                    child: Icon(Icons.check),
                                    color: Colors.green,
                                  )),
                              Padding(
                                  //~ Decline and return to home()
                                  padding: EdgeInsets.all(20),
                                  child: FlatButton(
                                    onPressed: () {
                                      nav.pop();
                                      nav.pop();
                                    },
                                    child: Icon(Icons.clear),
                                    color: Colors.red,
                                  )),
                            ],
                          )
                        ],
                      );
                      /* return ListTile(
                        leading: Image.network(booksFound[i].image),
                        title: Text(booksFound[i].title),
                        subtitle: Text(booksFound[i].author),
                      ); */
                    });
              } //~ Error message when no book was found
              else if (snapshot.data.length <= 0) {
                return Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Sorry, no book matching the provided ${widget.bookCodeType} has been found. Please try again.",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ));
              }

              //~  Progress Indicator when data is buffering
              return LinearProgressIndicator();
            }));
  }

  //? Search for book in catalogue based on scanned barcode/ISBN code
  Future<List<Book>> searchCatalogue(String bookCode, String codeType) async {
    try {
      final QuerySnapshot bookDb = await FirebaseFirestore.instance
          .collection("BookCatalogue")
          .where(codeType, isEqualTo: bookCode)
          .get();

      //^ Returns books matching the given barcode/isbn code and adds it to the booksFound list and the corresponding id to the booksFoundId list
      if (int.parse(bookDb.docs.length.toString()) >= 1) {
        bookDb.docs.forEach((doc) {
          booksFound.add(bookFromJson(doc.data()));
          bookId.add(doc.id);
        });
      }
    } catch (e) {
      print("An error has occurred: $e");
    }
    return booksFound;
  }

  //? Retrieves the current date and returns the book returnDate
  String calculateReturnDate() {
    DateTime startDate = DateTime.now();
    DateTime returnDate = startDate.add(Duration(days: 6));

    //^ Checks if the returnDate lands on a weekend and extends it to Monday if so
    if (returnDate.day == DateTime.saturday) {
      returnDate.add(Duration(days: 2));
      return returnDate.toString();
    } else if (returnDate.day == DateTime.sunday) {
      returnDate.add(Duration(days: 1));
      return returnDate.toString();
    } else {
      return returnDate.toString();
    }
  }

  //? Takes the dateTime string and extracts only the day/month/year
  String parseDate(String date) {
    var dateParse = DateTime.parse(date);
    var dateString = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return dateString.toString();
  }

//? Creates the new borrow record
  Borrow createRecord(String startDate, String returnDate, [int i = 0]) {
    String userId = widget.userId;
    String borrowBookId = bookId[i];
    String borrowBookTitle = booksFound[i].title;
    Borrow newRecord;

    newRecord = Borrow(userId, borrowBookId, borrowBookTitle, startDate,
        returnDate, "Borrowed");
    return newRecord;
  }

  //? Checks if the User is currently borrowing the book
  Future<bool> hasBorrowed([int i = 0]) async {
    QuerySnapshot existingRecord = await FirebaseFirestore.instance
        .collection("BorrowedBook")
        .where("BookId", isEqualTo: bookId[i])
        .where("UserId", isEqualTo: widget.userId)
        .where("Status", isEqualTo: "Borrowed")
        .get();

    print(existingRecord);
    return existingRecord.docs.isEmpty;
  }

  @override
  void dispose() {
    nav.dispose();
    super.dispose();
  }
}

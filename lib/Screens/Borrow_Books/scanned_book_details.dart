import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/notifications.dart';
import 'package:librarix/Screens/Notifications/notifications_build.dart';
import '../../modules.dart';
import '../../Models/book.dart';
import '../../Models/borrow.dart';
import '../../Custom_Widget/book_list_tile.dart';
import '../../Custom_Widget/custom_alert_dialog.dart';

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

  //? Screen
  @override
  Widget build(BuildContext context) {
    String printCodeType;
    (widget.bookCodeType == "BookISBNCode")
        ? printCodeType = "Book ISBN Code"
        : printCodeType = "Book Barcode";

    return Scaffold(
        appBar: AppBar(
          title: Text("Books"),
        ),
        body: FutureBuilder<List<Book>>(
            future: searchCatalogue(widget.bookCode, widget.bookCodeType),
            builder:
                (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
              //~ Display Book found
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.length == 1) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        BookCard(booksFound),
                        borrowDetails(context),
                      ],
                    ),
                  );
                }
                //~  Selection screen when >1 book is returned from the database
                else if (snapshot.data.length > 1) {
                  return ListView.builder(
                      itemCount: booksFound.length,
                      itemBuilder: (context, i) {
                        return ExpansionTile(
                          leading: Image.network(booksFound[i].image),
                          title: Text(booksFound[i].title),
                          children: <Widget>[
                            Text(booksFound[i].author),
                            Text("${booksFound[i].stock.toString()} available"),
                            borrowDetails(context, i: i),
                          ],
                        );
                      });
                } //~ Error message when no book was found
                else if (snapshot.data.length <= 0) {
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Sorry, no book matching the provided $printCodeType has been found. Please try again.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ));
                }
              }
              //~  Progress Indicator when data is buffering
              return SpinKitWave(color: Theme.of(context).accentColor);
            }));
  }

//? Borrow Book Options
  Widget borrowDetails(BuildContext context, {int i = 0}) {
    if (booksFound[i].stock > 0) {
      return Column(children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text("Return Date: ${parseDate(calculateReturnDate())}")),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                //~ Accept and borrow the book
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: FlatButton(
                  onPressed: () async {
                    var existingRecord = await hasBorrowed(index: i);

                    if (existingRecord.isNotEmpty) {
                      customAlertDialog(context,
                          title: "Request Cancelled",
                          content: "This book has already been borrowed!");
                    } else {
                      await createBorrowRecord(createRecord(
                              recordType: "Borrowed",
                              startDate: parseDate(DateTime.now().toString()),
                              returnDate: parseDate(calculateReturnDate()),
                              i: i))
                          .then((value) async {
                        //~ Save Notification to database
                        await saveNotification(
                            userId: widget.userId,
                            notificationInstance: createInstance(
                                details: value,
                                title: "Book Return - ${widget.userId}",
                                content:
                                    "${booksFound[i].title} is due to be returned on ${parseDate(calculateReturnDate())}",
                                displayDate: parseDate(parseStringToDate(
                                        parseDate(calculateReturnDate()))
                                    .subtract(Duration(days: 3))
                                    .toString()),
                                type: "Book Return"));

                        if (await isStaff() == false) {
                          //~ Schedule local Book Return Notification if not a staff member
                          await bookReturnNotification(
                              notificationId: value.hashCode,
                              returnDate: parseDate(calculateReturnDate()),
                              title: booksFound[i].title);
                        }
                      });
                      customAlertDialog(context,
                          title: "Request Approved",
                          content:
                              "${booksFound[i].title} has been successfully borrowed!",
                          navigateHome: true);
                    }
                  },
                  child: Icon(Icons.check),
                  color: Colors.green,
                )),
            Padding(padding: EdgeInsets.all(15)),
            Padding(
                //~ Decline and return to home()
                padding: EdgeInsets.symmetric(horizontal: 10),
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
      ]);
    } else {
      return Column(children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text("Return Date: ${parseDate(calculateReturnDate())}")),
        FlatButton(
          child: Text("Place Reservation"),
          color: Colors.yellow,
          textColor: Colors.black,
          onPressed: () => createBorrowRecord(createRecord(
              recordType: "Reserved",
              startDate: "Not Available",
              returnDate: "Not Available")),
        )
      ]);
    }
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
    if (returnDate.weekday == DateTime.saturday) {
      returnDate = returnDate.add(Duration(days: 2));
    } else if (returnDate.weekday == DateTime.sunday) {
      returnDate = returnDate.add(Duration(days: 1));
    }
    return returnDate.toString();
  }

//? Creates the new borrow record
  Borrow createRecord(
      {String recordType, String startDate, String returnDate, int i = 0}) {
    String userId = widget.userId;
    String borrowBookId = bookId[i];
    String borrowBookTitle = booksFound[i].title;
    Borrow newRecord;

    newRecord = Borrow(userId, borrowBookId, borrowBookTitle, startDate, 0,
        returnDate, recordType);
    return newRecord;
  }

  //? Checks if the User is currently borrowing the book
  Future<List<Borrow>> hasBorrowed({int index = 0}) async {
    var userRecords = await getUserBorrowRecords(widget.userId);
    if (userRecords.isNotEmpty) {
      return userRecords
          .where(
              (doc) => doc.bookId == bookId[index] && doc.status == "Borrowed")
          .toList();
    }
    return userRecords = [];
  }
}

//? BookCard widget
class BookCard extends StatelessWidget {
  final List<Book> booksFound;
  final int i;

  BookCard(this.booksFound, {this.i = 0});
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomBookTile(
            title: booksFound[i].title,
            author: booksFound[i].author,
            stock: booksFound[i].stock,
            thumbnail: Container(
              child: Image.network(booksFound[i].image),
            ))
      ],
    ));
  }
}

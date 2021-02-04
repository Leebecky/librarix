import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Models/booking.dart';
import 'package:librarix/Models/borrow.dart';
import 'package:librarix/Screens/Search/search_details.dart';
import 'package:librarix/Screens/Staff/update_book/fines_add.dart';
import '../../Models/book.dart';

Widget bookSearchCard(BuildContext context, DocumentSnapshot document) {
  final book = Book.fromSnapshot(document);

  return new Container(
    child: Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(
                  book.image,
                  width: 150,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 4.0),
                child: AutoSizeText(book.title,
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  book.author,
                  style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailBookView(book: book)),
          );
        },
      ),
    ),
  );
}

Widget borrowSearchCard(BuildContext context, DocumentSnapshot document) {
  final borrowRecord = Borrow.fromSnapshot(document);

  return Column(children: [
    Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Row(children: <Widget>[
                Text(
                  borrowRecord.userId,
                  style: TextStyle(fontSize: 25.0),
                ),
                Spacer(),
                Column(children: borrowActionButtons(context, borrowRecord))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                borrowRecord.bookTitle,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                borrowRecord.status,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                "${borrowRecord.borrowedDate} - ${borrowRecord.returnedDate}",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    )
  ]);
}

Widget bookingSearchCard(BuildContext context, DocumentSnapshot document) {
  final bookingRecord = Booking.fromSnapshot(document);
  return Card(
      child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Row(children: [
                    Text(
                      bookingRecord.roomOrTableNum,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    Spacer(),
                    Column(
                      children: actionButtons(context, bookingRecord),
                    )
                  ])),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text(bookingRecord.userId,
                      style: TextStyle(fontSize: 24))),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 4.0),
                child: Text(bookingRecord.bookingDate,
                    style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                    bookingRecord.bookingStartTime +
                        " - " +
                        bookingRecord.bookingEndTime,
                    style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(bookingRecord.bookingStatus,
                    style: TextStyle(fontSize: 20)),
              ),
            ],
          )));
}

List<Widget> actionButtons(BuildContext context, Booking bookingRecord) {
  List<Widget> buttons = [];
  if (bookingRecord.bookingStatus == "Active") {
    buttons.add(IconButton(
      icon: Icon(Icons.done_sharp),
      onPressed: () {
        return actionAlertDialog(
          context,
          title: "Booking Completed",
          content: "Close this booking?",
          onPressed: () async {
            await updateBookingStatus(bookingRecord.bookingId, "Completed");
            Get.back();
          },
        );
      },
    ));
  } else if (bookingRecord.bookingStatus == "Booked") {
    buttons.addAll([
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //booked => cancelled
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              return actionAlertDialog(context,
                  title: "Cancel Booking",
                  content: "Cancel this booking?", onPressed: () async {
                updateBookingStatus(bookingRecord.bookingId, "Cancelled");
                Get.back();
              });
            },
          ),
          Container(
            width: 20.0,
          ),
          //booked => active
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              return actionAlertDialog(context,
                  title: "Activate Booking",
                  content: "Check-in for this booking?", onPressed: () async {
                updateBookingStatus(bookingRecord.bookingId, "Active");
                Get.back();
              });
            },
          ),
        ],
      ),
    ]);
  }
  return buttons;
}

List<Widget> borrowActionButtons(BuildContext context, Borrow borrowRecord) {
  List<Widget> buttons = [];
  if (borrowRecord.status == "Borrowed") {
    buttons.add(IconButton(
      icon: Icon(Icons.update),
      onPressed: () {
        return actionAlertDialog(context,
            title: "Return Book",
            content: "Book Returned?", onPressed: () async {
          updateReturnStatus(borrowRecord.borrowedId, borrowRecord.bookId);
          Get.back();
          return actionAlertDialog(context,
              title: "Fines",
              content: "Does the user need to be fined?", onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddFines(borrowRecord.userId);
            }));
          });
        });
      },
    ));
  } else {
    buttons.addAll([
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            return actionAlertDialog(context,
                title: "Book Reservation",
                content: "Cancel book reservation?", onPressed: () async {
              updateCancelStatus(borrowRecord.borrowedId);
              Get.back();
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.update),
          onPressed: () {
            return actionAlertDialog(context,
                title: "Book Reservation",
                content: "Borrow reserved book?", onPressed: () async {
              updateBorrowStatus(borrowRecord.borrowedId, borrowRecord.bookId);
              Get.back();
            });
          },
        ),
      ]),
    ]);
  }
  return buttons;
}

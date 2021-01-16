import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:librarix/Models/borrow.dart';
import '../../Custom_Widget/buttons.dart';
import '../../modules.dart';

class BookDetails extends StatefulWidget {
  final DocumentSnapshot bookCatalogue;
  BookDetails({this.bookCatalogue});

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  ValueNotifier get userId => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(widget.bookCatalogue["BookImage"],
                    height: 300, fit: BoxFit.fill),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 60.00,
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.bookCatalogue["BookTitle"],
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                  child: Text(widget.bookCatalogue["BookAuthor"],
                      style: TextStyle(
                          fontSize: 20.0, fontStyle: FontStyle.italic)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: AutoSizeText(
                    widget.bookCatalogue["BookDescription"],
                    style: TextStyle(fontSize: 15.0),
                    maxLines: 20,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Barcode: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.bookCatalogue["BookBarcode"],
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Genre: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.bookCatalogue["BookGenre"],
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Publish Year: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.bookCatalogue["BookPublishDate"],
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Publisher: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.bookCatalogue["BookPublisher"],
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Stock: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.bookCatalogue["BookStock"].toString(),
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: verifyUser(userId),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget verifyUser(ValueNotifier userId) {
    return FutureBuilder<bool>(
        future: isStaff(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == false) {
            return CustomOutlineButton(
                buttonText: "Reserve Book", onClick: () => _showMyDialog());
          } else
            return SizedBox(height: 0);
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reserve Book'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Do you want to reserve ${widget.bookCatalogue["BookTitle"]} ?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                createReservationRecord(
                    widget.bookCatalogue.id, widget.bookCatalogue["BookTitle"]);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }
}

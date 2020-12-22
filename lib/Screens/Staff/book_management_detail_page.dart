import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'book_management_edit_book.dart';

class BookManagementDetailPage extends StatefulWidget {
  final DocumentSnapshot bookCatalogue;
  BookManagementDetailPage({this.bookCatalogue});

  @override
  _BookManagementDetailPageState createState() =>
      _BookManagementDetailPageState();
}

class _BookManagementDetailPageState extends State<BookManagementDetailPage> {
  final primaryColor = const Color(0xFF7fbfe9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookCatalogue["BookTitle"]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditBook()));
        },
        child: Icon(Icons.edit_outlined),
      ),
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            // SliverAppBar(
            //   backgroundColor: primaryColor,
            //   expandedHeight: 350.0,
            //   flexibleSpace: FlexibleSpaceBar(
            //     background: Image.network(widget.bookCatalogue["BookImage"]),
            //   ),
            // ),
            SliverFixedExtentList(
              itemExtent: 60.00,
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    widget.bookCatalogue["BookImage"],
                    height: 100,
                    width: 100,
                    fit: BoxFit.fitWidth,
                  ),
                ),
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
              ]),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librarix/Custom_Widget/textfield.dart';

class EditBook extends StatefulWidget {
  final DocumentSnapshot bookCatalogue;
  EditBook({this.bookCatalogue});

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  String title,
      isbnCode,
      barcode,
      genre,
      author,
      publisher,
      publishedDate,
      description,
      stock,
      image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.bookCatalogue.id + "\n" + widget.bookCatalogue["BookTitle"]),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextField(
                    text: "Book Title",
                    fixKeyboardToNum: false,
                    onChange: (value) => title = value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

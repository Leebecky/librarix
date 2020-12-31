import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBook extends StatefulWidget {
  final DocumentSnapshot bookCatalogue;
  EditBook({this.bookCatalogue});

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookCatalogue["BookTitle"]),
      ),
    );
  }
}

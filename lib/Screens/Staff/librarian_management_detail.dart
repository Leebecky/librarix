import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LibrarianManagementDetail extends StatefulWidget {
  final DocumentSnapshot librarian;
  LibrarianManagementDetail({this.librarian});

  @override
  _LibrarianManagementDetailState createState() =>
      _LibrarianManagementDetailState();
}

class _LibrarianManagementDetailState extends State<LibrarianManagementDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

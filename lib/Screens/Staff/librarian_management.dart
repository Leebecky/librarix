import 'package:flutter/material.dart';
import 'package:librarix/Models/librarian.dart';

class LibrarianManagement extends StatefulWidget {
  @override
  _LibrarianManagementState createState() => _LibrarianManagementState();
}

class _LibrarianManagementState extends State<LibrarianManagement> {
  final List<Librarian> myLibrarian = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Librarian Management"),
      ),
      body: Container(),
    );
  }
}

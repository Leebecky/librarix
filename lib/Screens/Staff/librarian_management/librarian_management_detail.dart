import 'package:flutter/material.dart';
import '../../../Models/librarian.dart';

class LibrarianManagementDetail extends StatefulWidget {
  final String dlibrarian;
  final Librarian data;
  LibrarianManagementDetail({this.dlibrarian, this.data});

  @override
  _LibrarianManagementDetailState createState() =>
      _LibrarianManagementDetailState();
}

class _LibrarianManagementDetailState extends State<LibrarianManagementDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data.name),
        ),
        body: (Container(
          child: Text(widget.data.status),
        )));
  }
}

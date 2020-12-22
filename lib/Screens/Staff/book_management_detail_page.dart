import 'package:flutter/material.dart';
import 'package:librarix/Models/book.dart';

class BookManagementDetailPage extends StatelessWidget {
  BookManagementDetailPage(Book myBook);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Detail"),
      ),
    );
  }
}

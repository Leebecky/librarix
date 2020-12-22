import 'package:flutter/material.dart';
import 'package:librarix/Models/book.dart';

class BookManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Management"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddBook_BookManagement();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddBook_BookManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book"),
      ),
    );
  }
}

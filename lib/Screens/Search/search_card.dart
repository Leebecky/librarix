import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Screens/Search/search_details.dart';
import '../../Models/book.dart';

Widget buildSearchCard(BuildContext context, DocumentSnapshot document) {
  final book = Book.fromSnapshot(document);

  return new Container(
    child: Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 100),
                child: Row(children: <Widget>[
                  Image.network(book.image, width: 150, fit: BoxFit.fitWidth,),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(children: <Widget>[
                  Text(book.title, style: TextStyle(fontSize: 20.0),),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text(book.author, style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailBookView(book: book)),
          );
        },
      ),
    ),
  );
}
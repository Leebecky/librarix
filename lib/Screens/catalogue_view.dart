import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Catalogue.dart';
//import 'BookCatalogue/book_details.dart';

class CatalogueView extends StatelessWidget {
  final List<Catalogue> catalogueList = [
    Catalogue(
        "Mary Norton",
        "9780152047320 ",
        "Driven out of their house by the rat catcher, the Clocks find themselves lost and alone in a frightening new world: the outdoors. Cow, moths, mice - even cold - are life threatening dangers to the tiny Borrowers. But they must brave it all to find a new home",
        "Fantasy",
        "9780152047320",
        "https://user-images.githubusercontent.com/55550611/100258031-88f55c00-2f81-11eb-860d-f173c297a0ef.jpg",
        "1983",
        "Odyssey",
        2,
        "The Borrowers Afield"),
    Catalogue(
        "Mary Norton",
        "9780152047320 ",
        "Driven out of their house by the rat catcher, the Clocks find themselves lost and alone in a frightening new world: the outdoors. Cow, moths, mice - even cold - are life threatening dangers to the tiny Borrowers. But they must brave it all to find a new home",
        "Fantasy",
        "9780152047320",
        "https://user-images.githubusercontent.com/55550611/100258031-88f55c00-2f81-11eb-860d-f173c297a0ef.jpg",
        "1983",
        "Odyssey",
        2,
        "The Borrowers Afield"),
    Catalogue(
        "Mary Norton",
        "9780152047320 ",
        "Driven out of their house by the rat catcher, the Clocks find themselves lost and alone in a frightening new world: the outdoors. Cow, moths, mice - even cold - are life threatening dangers to the tiny Borrowers. But they must brave it all to find a new home",
        "Fantasy",
        "9780152047320",
        "https://user-images.githubusercontent.com/55550611/100258031-88f55c00-2f81-11eb-860d-f173c297a0ef.jpg",
        "1983",
        "Odyssey",
        2,
        "The Borrowers Afield"),
    Catalogue(
        "Mary Norton",
        "9780152047320 ",
        "Driven out of their house by the rat catcher, the Clocks find themselves lost and alone in a frightening new world: the outdoors. Cow, moths, mice - even cold - are life threatening dangers to the tiny Borrowers. But they must brave it all to find a new home",
        "Fantasy",
        "9780152047320",
        "https://user-images.githubusercontent.com/55550611/100258031-88f55c00-2f81-11eb-860d-f173c297a0ef.jpg",
        "1983",
        "Odyssey",
        2,
        "The Borrowers Afield"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new GridView.builder(
          itemCount: catalogueList.length,
          itemBuilder: (BuildContext context, int index) =>
              buildTripCard(context, index), 
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 4.0,
            ),
          ),
    );
  }

  Widget buildTripCard(BuildContext context, int index) {
    final catalogue = catalogueList[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 24.0),
                child: Row(children: <Widget>[
                  Text(catalogue.bookTitle, style: new TextStyle(fontSize: 12.0)),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 10.0),
                child: Row(children: <Widget>[
                  Image.network(catalogue.bookImage, width: 170, fit: BoxFit.fitWidth),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



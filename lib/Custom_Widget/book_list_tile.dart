import 'package:flutter/material.dart';

class CustomBookTile extends StatelessWidget {
  //^ Constructor
  const CustomBookTile({
    this.thumbnail,
    this.title,
    this.author,
    this.stock,
  });

  //^ Attributes
  final Widget thumbnail;
  final String title;
  final String author;
  final int stock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _BookDescription(
              title: title,
              author: author,
              stock: stock,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookDescription extends StatelessWidget {
  const _BookDescription({
    Key key,
    this.title,
    this.author,
    this.stock,
  }) : super(key: key);

  final String title;
  final String author;
  final int stock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            author,
            style: const TextStyle(fontSize: 15.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
          Text(
            '$stock available',
            style: const TextStyle(
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}

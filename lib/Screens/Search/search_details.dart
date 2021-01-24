import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:librarix/Custom_Widget/buttons.dart';
import 'package:librarix/Models/book.dart';
import 'package:librarix/Models/borrow.dart';

import '../../modules.dart';

class DetailBookView extends StatefulWidget {
  final Book book;

  DetailBookView({Key key, @required this.book}) : super(key: key);

  @override
  _DetailBookViewState createState() => _DetailBookViewState();
}

class _DetailBookViewState extends State<DetailBookView> {
  ValueNotifier get userId => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(widget.book.image,
                      height: 300, fit: BoxFit.fill)),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.book.title,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 8.0, bottom: 10.0),
                  child: Text(widget.book.author,
                      style: TextStyle(
                          fontSize: 20.0, fontStyle: FontStyle.italic)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: AutoSizeText(
                    widget.book.description,
                    style: TextStyle(fontSize: 15.0),
                    maxLines: 20,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Barcode: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.book.barcode,
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Genre: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.book.genre, style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Publish Year: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.book.publishDate,
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Publisher: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.book.publisher,
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Row(
                    children: [
                      Text("Stock: ", style: TextStyle(fontSize: 15.0)),
                      Text(widget.book.stock.toString(),
                          style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: verifyUser(userId),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget verifyUser(ValueNotifier userId) {
    return FutureBuilder<bool>(
        future: isStaff(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          //^ if User is Staff, create a textfield
          if (snapshot.data == false) {
            return CustomOutlineButton(
                buttonText: "Reserve Book", onClick: () => _showMyDialog());
          } else
            return SizedBox(height: 0.01);
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reserve Book'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Do you want to reserve ${widget.book.title} ?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                createReservationRecord(widget.book.id, widget.book.title);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }
}

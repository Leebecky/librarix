import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../Models/borrow.dart';

class BorrowedList extends StatefulWidget {
  final String borrowedList;
  const BorrowedList({Key key, this.borrowedList}) : super(key: key);

  @override
  _BorrowedListState createState() => _BorrowedListState();
}

class _BorrowedListState extends State<BorrowedList> {
  var unreturnedBooks;
  ValueNotifier<String> userId = ValueNotifier("");
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Borrow>>(
        stream: getBorrowedOf("UserId", widget.borrowedList),
        builder: (BuildContext context, AsyncSnapshot<List<Borrow>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Column(
                      children: [
                    Container(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 4.0),
                                child: Row(children: <Widget>[
                                  Text(
                                    snapshot.data[index].bookTitle,
                                    style: TextStyle(fontSize: 25.0),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.refresh), 
                                        iconSize: 30.0,
                                        onPressed: () {
                                          return showDialog(
                                            context: context,
                                            barrierDismissible: false, 
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Renew Borrow Status'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text("Do you want to extends the borrow period?"),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text("Yes"),
                                                    onPressed: () async { 
                                                      if(snapshot.data[index].status == "Borrowed"){
                                                        
                                                      }else{
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible: false, 
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Warning!"),
                                                              content: Text("You are not valid to renew this booking because it's over time"),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: Text("OK"),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              ]
                                                            );
                                                          }
                                                        );
                                                      }
                                                    }
                                                  ),
                                                  TextButton(
                                                    child: Text("Cancel"),
                                                    onPressed: () => Navigator.of(context).pop()
                                                    )
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                    ],
                                  )
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4.0),
                                child: Row(children: <Widget>[
                                  Text(
                                    snapshot.data[index].status,
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Spacer(),
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Row(
                                  children: <Widget>[
                                      Text(
                                        snapshot.data[index].borrowedDate,
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      Text(" - "),
                                      Text(
                                        snapshot.data[index].returnedDate,
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      Spacer(),
                                    ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ].toList());
                });
          }
          return SpinKitWave(
            color: Theme.of(context).accentColor,
          );
        });
  }                                                                                                       
}

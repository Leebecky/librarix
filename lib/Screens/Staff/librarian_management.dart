import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      body: Container(
        child: FutureBuilder<List<String>>(
            future: librarianData(),
            builder: (BuildContext context, AsyncSnapshot<List<String>> docId) {
              if (docId.hasData) {
                return FutureBuilder<List<Librarian>>(
                    future: getLibrarianData(docId.data),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Librarian>> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          child: Column(
                            children: [
                              Text(snapshot.data[0].name),
                              Text(snapshot.data[1].phoneNum)
                            ],
                          ),
                        );
                      }
                      return SpinKitWave(
                        color: Theme.of(context).accentColor,
                      );
                    });
              }
              return SpinKitWave(
                color: Theme.of(context).accentColor,
              );
            }),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Models/librarian.dart';
import 'librarian_management_detail.dart';

class LibrarianManagement extends StatefulWidget {
  @override
  _LibrarianManagementState createState() => _LibrarianManagementState();
}

class _LibrarianManagementState extends State<LibrarianManagement> {
  final List<Librarian> myLibrarian = [];

  CollectionReference librarianDb =
      FirebaseFirestore.instance.collection("User");

  navigateToLibrarianManagementDetail(DocumentSnapshot librarian) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LibrarianManagementDetail(dlibrarian: librarian)));
  }

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
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: GestureDetector(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 4.0),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data[index].name,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          snapshot.data[index]
                                                              .userId,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           LibrarianManagementDetail(
                                  //               dlibrarian:)),
                                  // );
                                  navigateToLibrarianManagementDetail();
                                },
                              ),
                            );
                          },
                        );
                      }
                      return SpinKitWave(
                        color: Theme.of(context).accentColor,
                      );
                    });
              }
              return Center(
                  child: SpinKitWave(
                color: Theme.of(context).accentColor,
              ));
            }),
      ),
    );
  }
}

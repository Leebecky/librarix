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
                LibrarianManagementDetail(librarian: librarian)));
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
                            return Column(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          child: ListTile(
                                            title: Text(
                                              snapshot.data[index].name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    snapshot.data[index].userId,
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
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

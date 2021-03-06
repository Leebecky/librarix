import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'book_details.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class CatalogueView extends StatefulWidget {
  @override
  _CatalogueViewState createState() => _CatalogueViewState();
}

class _CatalogueViewState extends State<CatalogueView> {
  Future getBookCatalogue() async {
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn =
        await firestore.collection("BookCatalogue").orderBy("BookTitle").get();
    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot bookCatalogue) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookDetails(bookCatalogue: bookCatalogue)));
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: Container(
          child: FutureBuilder(
              future: getBookCatalogue(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitWave(
                      color: Theme.of(context).accentColor,
                    ),
                  );
                } else {
                  return GridView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        child: Container(
                            child: Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 10.0, left: 10.0),
                                        child: Image.network(
                                            snapshot.data[index]
                                                .data()['BookImage'],
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.fitHeight),
                                      ),
                                      Flexible(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Text(
                                            snapshot.data[index]
                                                .data()['BookTitle'],
                                            style: TextStyle(fontSize: 14.0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ])))),
                        onTap: () {
                          navigateToDetail(snapshot.data[index]);
                        },
                      );
                    },
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 3.0,
                      crossAxisSpacing: 4.0,
                    ),
                  );
                }
              }),
        ));
  }
}

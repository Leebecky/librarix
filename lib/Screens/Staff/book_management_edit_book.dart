import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librarix/Custom_Widget/buttons.dart';
import 'package:librarix/Custom_Widget/textfield.dart';
import 'package:librarix/Screens/Staff/book_management.dart';

class EditBook extends StatefulWidget {
  final DocumentSnapshot bookCatalogue;
  EditBook({this.bookCatalogue});

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  String title,
      isbnCode,
      barcode,
      genre,
      author,
      publisher,
      publishedDate,
      description,
      stock,
      image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.bookCatalogue.id + "\n" + widget.bookCatalogue["BookTitle"]),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextField(
                    text: "Book Title",
                    fixKeyboardToNum: false,
                    onChange: (value) => title = value,
                  ),
                ),
                CustomFlatButton(
                  roundBorder: true,
                  buttonText: "Update",
                  onClick: () async {
                    updateBook();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BookManagementListView();
                    }));
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                      width: 150,
                      height: 50,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: Colors.red,
                          // colorBrightness: Colors.white,
                          child: Text(
                            "Delete",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () {
                            return showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Delete Book Catalogue',
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              "Do you sure wanted to delete this book catalogue?")
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          return showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Double Confirm',
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            "Confirm to delete this book catalogue?")
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text("Yes"),
                                                      onPressed: () async {
                                                        deleteBook(widget
                                                            .bookCatalogue.id);
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text("No"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          })),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateBook() async {
//       // DocumentReference ref =
//       FirebaseFirestore.instance.collection("BookCatalogue")
//       .doc(docId)
//       .update({'BookTitle': title},
//         {'BookISBNCode': isbnCode},
//         {'BookBarcode': barcode},
//         {'BookGenre': genre},
//        { 'BookAuthor': author},
//         {'BookPublisher': publisher},
//        { 'BookPublishDate': publishedDate},
//        { 'BookDescription': description},
//        { 'BookImage':
//             "https://images-na.ssl-images-amazon.com/images/I/61bKTJvsWGL._SX334_BO1,204,203,200_.jpg"}, //temp
//        { 'BookStock': stock,})
//        .then((value) =>
//           print("Active Status for Discussion Room update successfully!"))
//       .catchError((onError) => print("An error has occurred: $onError"));
  }

  Future<void> deleteBook(String docId) async {
    FirebaseFirestore.instance
        .collection("BookCatalogue")
        .doc(docId)
        .delete()
        .then((value) =>
            print("Active Status for Discussion Room update successfully!"))
        .catchError((onError) => print("An error has occurred: $onError"));
  }
}

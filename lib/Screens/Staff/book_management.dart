import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Models/book.dart';
import '../Staff/book_management_detail_page.dart';

class BookManagement extends StatelessWidget {
  List<Book> myBook = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Management"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddNewBook_BookManagement();
          }));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: getBook(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null) {
              return Center(
                  child: Text(
                "Loading ... ",
                textAlign: TextAlign.center,
              ));
            } else {
              snapshot.data.docs.forEach((doc) {
                myBook.add(bookFromJson(doc.data()));
              });
              return ListView.builder(
                  itemCount: myBook.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Image.network(
                          myBook[index].image,
                        ),
                      ),
                      title: Text(
                        myBook[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        myBook[index].description,
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             new BookManagementDetailPage(
                        //                 myBook[index])));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BookManagementDetailPage();
                        }));
                      },
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

class AddNewBook_BookManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Book"),
      ),
    );
  }
}

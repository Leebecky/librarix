import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarix/Models/user.dart';

customAlertDialog(BuildContext context,
    {String title = "",
    String content = "",
    Widget imageContent,
    navigateHome = false}) {
  return showDialog(
      context: context,
      child: AlertDialog(
          title: Text(title),
          content: (imageContent == null) ? Text(content) : imageContent,
          actions: [
            FlatButton(
                onPressed: () async {
                  if (navigateHome) {
                    //^ When true, returns to the Book Catalogue page
                    ActiveUser myUser = await myActiveUser(
                        docId: FirebaseAuth.instance.currentUser.uid);
                    (myUser.role == "Admin")
                        ? Navigator.pushNamed(context, "/adminHome")
                        : (myUser.role == "Librarian")
                            ? Navigator.pushNamed(context, "/librarianHome")
                            : Navigator.pushNamed(context, "/home");
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text("Close"))
          ]));
}

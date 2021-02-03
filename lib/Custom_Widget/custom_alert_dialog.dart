import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
                        ? Navigator.popAndPushNamed(context, "/adminHome")
                        : (myUser.role == "Librarian")
                            ? Navigator.popAndPushNamed(
                                context, "/librarianHome")
                            : Navigator.popAndPushNamed(context, "/home");
                  } else {
                    Get.back();
                  }
                },
                child: Text("Close"))
          ]));
}

actionAlertDialog(BuildContext context,
    {String title = "",
    String content = "",
    navigateHome = false,
    Function onPressed}) {
  return showDialog(
      context: context,
      child: AlertDialog(title: Text(title), content: Text(content), actions: [
        FlatButton(
          onPressed: onPressed,
          child: Text("Yes"),
        ),
        FlatButton(
            onPressed: () async {
              if (navigateHome) {
                //^ When true, returns to the Book Catalogue page
                ActiveUser myUser = await myActiveUser(
                    docId: FirebaseAuth.instance.currentUser.uid);
                (myUser.role == "Admin")
                    ? Navigator.popAndPushNamed(context, "/adminHome")
                    : (myUser.role == "Librarian")
                        ? Navigator.popAndPushNamed(context, "/librarianHome")
                        : Navigator.popAndPushNamed(context, "/home");
              } else {
                Get.back();
              }
            },
            child: Text("No"))
      ]));
}

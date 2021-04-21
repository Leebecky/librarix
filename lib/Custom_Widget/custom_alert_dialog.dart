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
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: (imageContent == null) ? Text(content) : imageContent,
            actions: [
              ElevatedButton(
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
            ]);
      });
}

actionAlertDialog(BuildContext context,
    {String title = "",
    String content = "",
    navigateHome = false,
    Function onPressed}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              ElevatedButton(
                onPressed: onPressed,
                child: Text("Yes"),
              ),
              ElevatedButton(
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
                  child: Text("No"))
            ]);
      });
}

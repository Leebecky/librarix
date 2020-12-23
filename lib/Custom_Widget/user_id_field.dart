import 'package:flutter/material.dart';
import '../modules.dart';
import '../Models/user.dart';

Widget userIdField(ValueNotifier userId) {
  return FutureBuilder<bool>(
    future: isStaff(),
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      //^ if User is Staff, create a textfield
      if (snapshot.data == true) {
        return TextField(
          onChanged: (text) {
            userId.value = text.toUpperCase();
          },
          
          decoration: InputDecoration(
              labelText: "Please enter the Student/Lecturer's ID",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).accentColor,
              ))),
        );
      } else {
        //^ If User is not Staff, return UserId in Text()
        return FutureBuilder<ActiveUser>(
          future: myActiveUser(),
          builder: (BuildContext context, AsyncSnapshot<ActiveUser> user) {
            if (user.hasData) {
              userId.value = user.data.userId;
              return Text("User ID: ${user.data.userId}");
            }
            return LinearProgressIndicator();
          },
        );
      }
    },
  );
}

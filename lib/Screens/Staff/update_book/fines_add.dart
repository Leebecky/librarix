import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Custom_Widget/buttons.dart';
import '../../../Custom_Widget/textfield.dart';
import '../fines_management.dart';

class AddFines extends StatefulWidget {
  @override
  _AddFinesState createState() => _AddFinesState();
}

class _AddFinesState extends State<AddFines> {
  String userid, due, reason, total;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fines"),
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
                    text: "User ID",
                    fixKeyboardToNum: false,
                    onChange: (value) => userid = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: DropdownButtonFormField(
                    items: [
                      DropdownMenuItem(
                        value: "Late Return",
                        child: Text("Late Return"),
                      ),
                      DropdownMenuItem(
                        value: "Book Damage",
                        child: Text("Book Damage"),
                      ),
                      DropdownMenuItem(
                        value: "Book Lost",
                        child: Text("Book Lost"),
                      ),
                    ],
                    decoration: InputDecoration(
                        labelText: "Fines Reason",
                        hintText: "Please select fines reason",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor))),
                    onChanged: (String value) {
                      setState(() {
                        reason = value;
                      });
                    },
                  ),
                ),
                CustomFlatButton(
                  roundBorder: true,
                  buttonText: "Add",
                  onClick: () async {
                    createFines();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FinesManagement();
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future createFines() async {
    try {
      await FirebaseFirestore.instance.collection("Fines").add({
        'UserId': userid,
        'FinesReason': reason,
        'FinesDue': "21/06/2021", //due,
        'FinesStatus': "Unpaid",
        'FinesTotal': "0.10" //total,
      });
    } catch (e) {
      print(e.message);
    }
  }
}

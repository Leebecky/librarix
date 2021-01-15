import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/modules.dart';
import '../../../Custom_Widget/buttons.dart';
import '../fines_management.dart';
import '../../../modules.dart';

class AddFines extends StatefulWidget {
  final String userId;
  AddFines(this.userId);
  @override
  _AddFinesState createState() => _AddFinesState();
}

class _AddFinesState extends State<AddFines> {
  String userid, due, reason, total, date;

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
                  // child: CustomDisplayTextField(
                  //   controller: _userId,
                  //   fixKeyboardToNum: false,
                  //   onChange: (value) => userid = widget.userId,
                  // ),
                  child: Text(
                    widget.userId,
                    style: TextStyle(fontSize: 25),
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
                        calcFines();
                      });
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Visibility(
                      visible: true,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text("Fines Total : RM$total"),

                          //calculate total fines
                        ],
                      ),
                    )),
                CustomFlatButton(
                  roundBorder: true,
                  buttonText: "Add",
                  onClick: () async {
                    createFines();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FinesManagement();
                    }));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
        'FinesIssueDate': parseDate(DateTime.now().toString()),
        'FinesReason': reason,
        'FinesStatus': "Unpaid",
        'FinesTotal': total, //total,
        'UserId': widget.userId,
      });
    } catch (e) {
      print(e.message);
    }
  }

  void calcFines() {
    switch (reason) {
      case "Late Return":
        total = "5.00";
        break;
      case "Book Damage":
        total = "50.00";
        break;
      case "Book Lost":
        total = "100.00";
        break;
    }
  }
}

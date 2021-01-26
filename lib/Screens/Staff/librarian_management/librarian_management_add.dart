import 'package:flutter/material.dart';
import 'package:librarix/Custom_Widget/buttons.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Custom_Widget/textfield.dart';
import 'package:librarix/Models/librarian.dart';
import '../../../modules.dart';

//! You can enter the id of an existing librarian
class AddLibrarian extends StatefulWidget {
  @override
  _AddLibrarianState createState() => _AddLibrarianState();
}

class _AddLibrarianState extends State<AddLibrarian> {
  String userID, phoneNo;
  @override
  void initState() {
    phoneNo = "";
    userID = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Librarian"),
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
                    text: "Librarian User ID",
                    fixKeyboardToNum: false,
                    onChange: (value) => userID = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextField(
                    text: "Phone Number",
                    fixKeyboardToNum: true,
                    onChange: (value) => phoneNo = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomFlatButton(
                    roundBorder: true,
                    buttonText: "Add",
                    onClick: () async {
                      if (phoneNo.isEmpty || userID.isEmpty) {
                        customAlertDialog(
                          context,
                          title: "Empty Textfield",
                          content: "Please fill in the empty textfields!",
                        );
                      } else {
                        if (await validUser(userID)) {
                          await createLibrarian(userID, phoneNo);
                          // updateLibrarianStatus();
                          Navigator.of(context).pop();
                          customAlertDialog(
                            context,
                            title: "Librarian Registered",
                            content: "New Librarian Trainee added!",
                          );
                        } else {
                          customAlertDialog(
                            context,
                            title: "Invalid User ID",
                            content: "Invalid UserID entered. Please recheck!",
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

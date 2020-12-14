import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/user.dart';
import '../Models/librarian.dart';
//TODO implement role selector

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Text Editing Controllers
  final userIdCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  //Dropdown Button list value
  String dropdownValue = "Role:";
  String enteredEmail = "";

  @override
  void initState() {
    // TODO: implement initState\
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
            child: Expanded(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(40)),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(Icons.circle),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("LibrariX",
                        style: TextStyle(fontSize: 50, color: Colors.white)),
                  )
                ],
              ),
              Padding(
                  //^ UserID field
                  padding: EdgeInsets.all(20),
                  child: TextField(
                      onChanged: (newText) {
                        setState(() {
                          enteredEmail = newText;
                        });
                      },
                      controller: userIdCtrl,
                      decoration: InputDecoration(
                        labelText: "APU ID",
                        border: OutlineInputBorder(),
                      ))),
              Padding(
                //^ password field
                padding: EdgeInsets.all(20),
                child: TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    )),
              ),
              //^ Role Selection
              DropdownButton<String>(
                  value: dropdownValue,
                  items: roleList(enteredEmail),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  }),
              CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text("Remember Me"),
                  value: false,
                  onChanged: null),
              Padding(
                padding: EdgeInsets.all(20),
                child: RaisedButton(
                  child: Text("Login"),
                  onPressed: accountLogin,
                ),
              ),
            ],
          ),
        )));
  }

  //? Login
  void accountLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userIdCtrl.text, password: passwordCtrl.text);

//! TEsting grounds
      final activeUser = await myActiveUser();
      print(activeUser.userId + " has logged in!");

//! Testing for type of user
      await getLibrarian().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          print("Librarian incoming");
        } else {
          print("I assume you are a student");
        }
      });

      Navigator.pushNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //^ Dropdown menu items
  List<DropdownMenuItem<String>> roleList(String emailEntered) {
    List<String> roleValues = ["Role:"];
    if (emailEntered.startsWith("tp")) {
      roleValues.add("Student");
      roleValues.add("Librarian");
    } else if (emailEntered.startsWith("lp")) {
      roleValues.add("Lecturer");
      roleValues.add("Admin");
    }
    var dropMenuItem = roleValues.map((String value) {
      return DropdownMenuItem(value: value, child: Text(value));
    }).toList();
    return dropMenuItem;
  }

  //^ Dispose of the widget once login is completed
  @override
  void dispose() {
    passwordCtrl.dispose();
    userIdCtrl.dispose();
    super.dispose();
  }
}

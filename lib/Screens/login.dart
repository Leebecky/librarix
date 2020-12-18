import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //^ Text Editing Controllers
  final userIdCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  //^ Dropdown Button list value
  String dropdownValue, enteredEmail;
  //^ Password field attributes - password visibility toggle + icon
  bool passwordHidden;
  var iconShowPassword;

  //? Intialises inital value of variables
  @override
  void initState() {
    dropdownValue = "Role:";
    enteredEmail = "";
    passwordHidden = true;
    iconShowPassword = Icons.visibility_off_rounded;
    super.initState();
  }

  //? Build method for Login screen
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
                  //~ UserID field
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
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ))),
              Padding(
                //~ Password field
                padding: EdgeInsets.all(20),
                child: TextField(
                    controller: passwordCtrl,
                    obscureText: passwordHidden,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: IconButton(
                        icon: Icon(iconShowPassword),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            passwordHidden = !passwordHidden;
                            (passwordHidden)
                                ? iconShowPassword = Icons.visibility_rounded
                                : iconShowPassword =
                                    Icons.visibility_off_rounded;
                          });
                        },
                      ),
                    )),
              ),
              //~ Role Selection
              FutureBuilder<List<String>>(
                  future: roleList(enteredEmail, ["Role:"]),
                  builder: (context, snapshot) {
                    return DropdownButton<String>(
                      value: dropdownValue,
                      items: snapshot.data.map((String value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Theme.of(context).primaryColor,
                    );
                  }),
              Padding(
                padding: EdgeInsets.all(30),
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
  //TODO change path for Library Staff
  void accountLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userIdCtrl.text, password: passwordCtrl.text);

      //^ Testing for type of user
      if (dropdownValue == "Student" || dropdownValue == "Lecturer") {
        Navigator.popAndPushNamed(context, "/home");
      } else if (dropdownValue == "Librarian" || dropdownValue == "Admin") {
        Navigator.popAndPushNamed(context, "/home");
      } else {
        loginError(context, "invalidRole");
        print("Please select a role");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        loginError(context, "invalidUser");
      } else if (e.code == 'wrong-password') {
        loginError(context, "invalidPassword");
      } else if (e.code == "invalid-email") {
        loginError(context, "invalidEmail");
      }
    }
  }

  //? Dropdown menu items
  Future<List<String>> roleList(
      String emailEntered, List<String> roleValues) async {
    bool role;
    String docId = await getUserRole(enteredEmail);
    if (docId == null) {
      roleValues = ["Role:"];
    } else {
      if (emailEntered.startsWith("tp")) {
        roleValues.add("Student");
        role = await checkRole(docId, "Librarian");
        if (role) {
          roleValues.add("Librarian");
        }
      } else if (emailEntered.startsWith("lc")) {
        roleValues.add("Lecturer");
        role = await checkRole(docId, "Admin");
        if (role) {
          roleValues.add("Admin");
        }
      }
    }
    return roleValues;
  }

  //? AlertDialog notification when login error is triggered
  void loginError(BuildContext context, String errorType) {
    String errorMsg;

    //^ Determines error type and the appropriate message to return
    switch (errorType) {
      case "invalidRole":
        errorMsg = "Please select a role";
        break;
      case "invalidUser":
        errorMsg = "No user with this email has been found";
        break;
      case "invalidPassword":
        errorMsg = "Sorry, your password was incorrect";
        break;
      case "invalidEmail":
        errorMsg = "Please ensure that your email has been entered correctly";
        break;
    }

    //^ Build method for AlertDialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error logging in"),
            content: Text(errorMsg),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Close"))
            ],
          );
        });
  }

  //? Disposes of the widget once login is completed
  @override
  void dispose() {
    passwordCtrl.dispose();
    userIdCtrl.dispose();
    super.dispose();
  }
}

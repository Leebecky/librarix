import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final primaryColor = const Color(0xFF7fbfe9); 

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
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
            child: Expanded(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(40)),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Image(image: AssetImage('assets/Icon/library.png'), width: 50.0, fit: BoxFit.fitWidth,),
                  ),
                  SizedBox(width: 16.0),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("LibrariX",
                        style: GoogleFonts.getFont('ZCOOL XiaoWei',textStyle: TextStyle(fontSize: 50, color: Colors.white))),
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
              SizedBox(height: 20.0),
              FutureBuilder<List<String>>(
                  future: roleList(enteredEmail, ["Role:"]),
                  builder: (context, listItems) {
                    return DropdownButton<String>(
                      value: dropdownValue,
                      icon:  Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      items: listItems.data.map((String value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                      iconEnabledColor: Colors.white,
                      dropdownColor: primaryColor,
                    );
                  }),
              Padding(
                padding: EdgeInsets.all(30),
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                    child: Text("Login", style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w600)),
                  ),
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

      //^ Testing for type of user
      if (dropdownValue == "Student" || dropdownValue == "Lecturer") {
        Navigator.popAndPushNamed(context, "/home");
      } else if (dropdownValue == "Librarian" || dropdownValue == "Admin") {
        Navigator.popAndPushNamed(context, "/staffHome");
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Custom_Widget/textfield.dart';
import '../Models/user.dart';
import '../Custom_Widget/custom_alert_dialog.dart';
import 'package:get/get.dart';

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
  bool _isVerifying;
  //? Intialises inital value of variables
  @override
  void initState() {
    dropdownValue = "Role:";
    enteredEmail = "";
    passwordHidden = true;
    _isVerifying = false;
    iconShowPassword = Icons.visibility_off_rounded;
    super.initState();
  }

  //? Build method for Login screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(40)),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Image(
                      image: AssetImage('assets/Icon/library.png'),
                      width: 50.0,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("LibrariX",
                        style: GoogleFonts.getFont('ZCOOL XiaoWei',
                            textStyle:
                                TextStyle(fontSize: 50, color: Colors.white))),
                  )
                ],
              ),
              Padding(
                  //~ Email field
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    text: "Email",
                    controller: userIdCtrl,
                    borderColor: Colors.white,
                    onChange: (newText) {
                      setState(() {
                        enteredEmail = newText;
                      });
                    },
                  )),
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
                    if (listItems.hasData) {
                      return DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
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
                        iconEnabledColor: Colors.white,
                      );
                    }
                    return SpinKitWave(color: Theme.of(context).accentColor);
                  }),
              Padding(
                padding: EdgeInsets.all(30),
                //^ Displays a loader to indicate when login is being processed
                child: (_isVerifying)
                    ? Container(
                        width: 135,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: SpinKitThreeBounce(
                          color: primaryColor,
                          size: 25.0,
                        ),
                      )
                    : RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                                left: 30.0,
                                right: 30.0),
                            child: Text("Login",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600))),
                        onPressed: accountLogin,
                      ),
              ),
            ],
          ),
        ));
  }

  //? Login
  void accountLogin() async {
    setState(() {
      _isVerifying = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userIdCtrl.text, password: passwordCtrl.text);

      await saveRole(dropdownValue);

      //^ Routing based on type of user
      if (dropdownValue == "Student" || dropdownValue == "Lecturer") {
        Get.offAllNamed("/home");
      } else if (dropdownValue == "Librarian") {
        Get.offAllNamed("/librarianHome");
      } else if (dropdownValue == "Admin") {
        Get.offAllNamed("/adminHome");
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
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  //? Dropdown menu items
  Future<List<String>> roleList(
      String emailEntered, List<String> roleValues) async {
    ActiveUser currentUser;
    String docId = await findUser("UserEmail", enteredEmail);
    if (docId == null) {
      roleValues = ["Role:"];
    } else {
      currentUser = await myActiveUser(docId: docId);
      if (emailEntered.startsWith("tp")) {
        roleValues.add("Student");
        if (currentUser.role == "Librarian") {
          roleValues.add("Librarian");
        }
      } else if (emailEntered.startsWith("lc")) {
        roleValues.add("Lecturer");
        if (currentUser.role == "Admin") {
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
    customAlertDialog(context, title: "Error logging in", content: errorMsg);
  }

  //? Disposes of the widget once login is completed
  @override
  void dispose() {
    passwordCtrl.dispose();
    userIdCtrl.dispose();
    super.dispose();
  }
}

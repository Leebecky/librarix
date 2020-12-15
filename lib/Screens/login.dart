import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/user.dart';

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
  bool passwordVisiblity;
  var iconShowPassword;

  @override
  void initState() {
    // TODO: implement initState
    passwordVisiblity = false;
    iconShowPassword = Icons.visibility_rounded;
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
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ))),
              Padding(
                //^ Password field
                padding: EdgeInsets.all(20),
                child: TextField(
                    controller: passwordCtrl,
                    obscureText: passwordVisiblity,
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
                            passwordVisiblity = !passwordVisiblity;
                            (passwordVisiblity)
                                ? iconShowPassword = Icons.visibility_rounded
                                : iconShowPassword =
                                    Icons.visibility_off_rounded;
                          });
                        },
                      ),
                    )),
              ),
              //^ Role Selection
              FutureBuilder<List<String>>(
                  future: roleList(enteredEmail),
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
  void accountLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userIdCtrl.text, password: passwordCtrl.text);

//^ Testing for type of user
      if (dropdownValue == "Student" || dropdownValue == "Lecturer") {
        Navigator.pushNamed(context, "/home");
      } else if (dropdownValue == "Librarian" || dropdownValue == "Admin") {
        Navigator.popAndPushNamed(context, "/menuPlaceholder");
      } else {
        //TODO add an alert dialog when role is not selected
        print("Please select a role");
      }
    } on FirebaseAuthException catch (e) {
      //TODO implement notifications when error is triggered
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //^ Dropdown menu items
  Future<List<String>> roleList(String emailEntered) async {
    List<String> roleValues = ["Role:"];
    String docId = await getUserRole(enteredEmail);
    bool role;
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
    return roleValues;
  }

  //^ Dispose of the widget once login is completed
  @override
  void dispose() {
    passwordCtrl.dispose();
    userIdCtrl.dispose();
    super.dispose();
  }
}

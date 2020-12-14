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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Spacer(),
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
          Spacer(),
        ],
      ),
    );
  }

  //? Login
  void accountLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: userIdCtrl.text, password: passwordCtrl.text);
      print(getActiveUser());
      Navigator.pushNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //^ Dispose of the widget once login is completed
  @override
  void dispose() {
    passwordCtrl.dispose();
    userIdCtrl.dispose();
    super.dispose();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
// import './Screens/login.dart';

 /*  //? Login
  void accountLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: "", password: "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  } */
class FirebaseAuthenticator {
// final auth = FirebaseAuth.instance();


  //? Tracking condition of user
  FirebaseAuthenticator.authStateChanges();
  FirebaseAuthenticator.listen(User user) {
    if (user == null) {
      print("User is currently signed out");
    } else {
      print("User is signed in!");
    }
  }
}

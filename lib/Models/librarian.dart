import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './user.dart';

class Librarian extends ActiveUser {
  //attributes
  String phoneNum, status;

//Constructor
  Librarian(
      String avatar,
      String email,
      String userId,
      String intakeCodeOrSchool,
      String name,
      String role,
      this.phoneNum,
      this.status)
      : super(avatar, email, userId, intakeCodeOrSchool, name, role);

  @override
  factory Librarian.fromJson(Map<dynamic, dynamic> json) =>
      _librarianFromJson(json);
}

Librarian _librarianFromJson(Map<dynamic, dynamic> json) {
  return Librarian(
    json["UserAvatar"] as String,
    json["UserEmail"] as String,
    json["UserId"] as String,
    json["UserIntakeCodeOrSchool"] as String,
    json["UserName"] as String,
    json["UserRole"] as String,
    json["LibrarianPhoneNumber"] as String,
    json["LibrarianStatus"] as String,
  );
}

//? Retrieve data from Firestore - Use with FutureBuilder
Future<DocumentSnapshot> getLibrarian() async {
  final librarianDetails = await FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Librarian")
      .doc("LibrarianDetails")
      .get();

  return librarianDetails;
}

//~ Whats the use of the librarian object? Dunno. Proof of concept I guess
Future<Librarian> myLibrarian(myUser) async {
  final librarianDetails = await FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Librarian")
      .doc("LibrarianDetails")
      .get();

  //retrieve user details
  var user = await myUser();
  Map userDetails = user.toJson();
  //Librarian specific Details
  Map details = librarianDetails.data();

  //Map the two sets of key/values together
  Map map = {};
  map.addAll(userDetails);
  map.addAll(details);

  //Instantiate librarian based on that
  Librarian librarian = Librarian.fromJson(map);

  return librarian;
}

//librarian management - list view
Future<DocumentSnapshot> librarianData() async {
  final librarianData = await FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Librarian")
      .doc("LibrarianDetails")
      .get();

  return librarianData;
}

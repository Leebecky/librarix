import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './user.dart';

class Admin extends ActiveUser {
  //attributes
  String phoneNum;

  Admin(String avatar, String email, String userId, String intakeCodeOrSchool,
      String name, String role, this.phoneNum)
      : super(avatar, email, userId, intakeCodeOrSchool, name, role);

  @override
  factory Admin.fromJson(Map<dynamic, dynamic> json) => _adminFromJson(json);
}

Admin _adminFromJson(Map<dynamic, dynamic> json) {
  return Admin(
    json["UserAvatar"] as String,
    json["UserEmail"] as String,
    json["UserId"] as String,
    json["UserIntakeCodeOrSchool"] as String,
    json["UserName"] as String,
    json["UserRole"] as String,
    json["AdminPhoneNumber"] as String,
  );
}

//? Retrieve data from Firestore - Use with FutureBuilder
Future<DocumentSnapshot> getAdmin() async {
  final adminDetails = await FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Admin")
      .doc("AdminDetails")
      .get();

  return adminDetails;
}

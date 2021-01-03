import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';

class ActiveUser {
  //^ Attributes
  String avatar, email, userId, intakeCodeOrSchool, name, role;

  //^ Constructor
  ActiveUser(this.avatar, this.email, this.userId, this.intakeCodeOrSchool,
      this.name, this.role);

  //? Factory - creates the ActiveUser instance from the JSON (database storage type) passed
  //? When Factory is used, implementing a constructor doesn't always create a new instance of its class
  factory ActiveUser.fromJson(Map<dynamic, dynamic> json) =>
      _activeUserFromJson(json);

  //? Converts the ActiveUser into a map of key/value pairs
  Map<String, String> toJson() => _activeUserToJson(this);
}

//? Converts map of values from Firestore into ActiveUser class.
//! This method is invoked by ActiveUser.fromJson. Don't call this method.
ActiveUser _activeUserFromJson(Map<dynamic, dynamic> json) {
  return ActiveUser(
    json["UserAvatar"] as String,
    json["UserEmail"] as String,
    json["UserId"] as String,
    json["UserIntakeCodeOrSchool"] as String,
    json["UserName"] as String,
    json["UserRole"] as String,
  );
}

//? Converts the ActiveUser class into key/value pairs
Map<String, String> _activeUserToJson(ActiveUser instance) => <String, String>{
      "UserAvatar": instance.avatar,
      "UserEmail": instance.email,
      "UserId": instance.userId,
      "UserIntakeCodeOrSchool": instance.intakeCodeOrSchool,
      "UserName": instance.name,
      "UserRole": instance.role,
    };

//? Retrieve data from Firestore - Use with FutureBuilder
Future<DocumentSnapshot> getActiveUser() async {
  CollectionReference userDb = FirebaseFirestore.instance.collection("User");
  final User currentUser = FirebaseAuth.instance.currentUser;
  final currentId = currentUser.uid;
  final activeUserDetails = await userDb.doc(currentId).get();
  return activeUserDetails;
}

//? Retrieves data from Firestore and stores in an ActiveUser object
Future<ActiveUser> myActiveUser({String docId}) async {
  String currentId;
  User currentUser = FirebaseAuth.instance.currentUser;
  (docId == null) ? currentId = currentUser.uid : currentId = docId;

  var activeUserDetails =
      await FirebaseFirestore.instance.collection("User").doc(currentId).get();

  final ActiveUser activeUser = ActiveUser.fromJson(activeUserDetails.data());
  return activeUser;
}

//? Checks if the user email exists in the database
Future<String> findUser(String queryField, String queryItem) async {
  String docId;
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("User")
        .where(queryField, isEqualTo: queryItem)
        .get();
    docId = snapshot.docs[0].id;
  } catch (e) {
    print("$e : User not found");
  }
  return docId;
}

//? Saves the role that the user is logged in as
Future<void> saveRole(String role) async {
  String userId = FirebaseAuth.instance.currentUser.uid;
  if (userId != null) {
    var loggedInAs = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Login")
        .doc("LoginRole");
    await loggedInAs.set({"LoggedInAs": role});
  }
  print("You are logged in as a $role");
}

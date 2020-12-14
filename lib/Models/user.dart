import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActiveUser {
  //Attributes
  String avatar, email, userId, intakeCodeOrSchool, name, role;

  //Document Reference (Firestore)
  DocumentReference userRef;

  //Constructor
  ActiveUser(this.avatar, this.email, this.userId, this.intakeCodeOrSchool,
      this.name, this.role);

  //Factory - creates the ActiveUser instance from the JSON (database storage type)
  factory ActiveUser.fromJson(Map<dynamic, dynamic> json) =>
      _activeUserFromJson(json);

  //! Converts the ActiveUser into a map of key/value pairs
  Map<String, String> toJson() => _activeUserToJson(this);
  @override
  String toString() => "Active User ID <$userId>";
  String getId(obj) => obj.userId;
}

//Converts map of values from Firestore into ActiveUser class
ActiveUser _activeUserFromJson(Map<dynamic, dynamic> json) {
  return ActiveUser(
    json["UserAvatar"] as String,
    json["UserEmail"] as String,
    json["UserId"] as String,
    json["UserIntakeCode/School"] as String,
    json["UserName"] as String,
    json["UserRole"] as String,
  );
}

//! Converts the ActiveUser class into key/value pairs
Map<String, String> _activeUserToJson(ActiveUser instance) => <String, String>{
      "UserAvatar": instance.avatar,
      "UserEmail": instance.email,
      "UserId": instance.userId,
      "UserIntakeCode/School": instance.intakeCodeOrSchool,
      "UserName": instance.name,
      "UserRole": instance.role,
    };

//? Retrieve data from Firestore
Future<DocumentSnapshot> getActiveUser() async {
  CollectionReference userDb = FirebaseFirestore.instance.collection("User");
  final User currentUser = FirebaseAuth.instance.currentUser;
  final currentId = currentUser.uid;
  final activeUserDetails = await userDb.doc(currentId).get();
  return activeUserDetails;
}

//? Retrieves data from Firestore and stores in an ActiveUser instance
Future<ActiveUser> myActiveUser() async {
  CollectionReference userDb = FirebaseFirestore.instance.collection("User");
  final User currentUser = FirebaseAuth.instance.currentUser;
  final currentId = currentUser.uid;
  final activeUserDetails = await userDb.doc(currentId).get();
  final ActiveUser activeUser = ActiveUser.fromJson(activeUserDetails.data());
  return activeUser;
}



import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './Models/user.dart';
//^ Common Functions that can be reused

//? Takes the dateTime string and extracts only the day/month/year
String parseDate(String date) {
  var dateParse = DateTime.parse(date);
  var dateString = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
  return dateString.toString();
}

//? Checks if the User is a library staff member
Future<bool> isStaff() async {
  bool isStaff;
  String currentUserId = FirebaseAuth.instance.currentUser.uid;
  ActiveUser currentUser = await myActiveUser(docId: currentUserId);

  (currentUser.role == "Librarian" || currentUser.role == "Admin")
      ? isStaff = true
      : isStaff = false;
  return isStaff;
}

//? Checks if the entered UserId belongs to a valid user
Future<bool> validUser(String userId) async {
  var validUser = await FirebaseFirestore.instance
      .collection("User")
      .where("UserId", isEqualTo: userId)
      .get();
  return validUser.docs.isNotEmpty;
}
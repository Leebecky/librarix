import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//^ Common Functions that can be reused

//? Takes the dateTime string and extracts only the day/month/year
String parseDate(String date) {
  var dateParse = DateTime.parse(date);
  var dateString = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
  return dateString.toString();
}

//? Takes the date String and converts it to DateTime
DateTime parseStringToDate(String date) {
  DateTime parsedDate;
  List<String> newDate = date.split("/");
  String day, month, year, displayDate;

  (int.parse(newDate[0]) < 10) ? day = "0${newDate[0]}" : day = newDate[0];
  (int.parse(newDate[1]) < 10) ? month = "0${newDate[1]}" : month = newDate[1];
  year = newDate[2];
  displayDate = year + month + day;
  parsedDate = DateTime.parse(displayDate);
  return parsedDate;
}

//? Checks if the User is a library staff member
Future<bool> isStaff() async {
  String currentUserId = FirebaseAuth.instance.currentUser.uid, currentRole;
  if (currentUserId != null) {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(currentUserId)
        .collection("Login")
        .doc("LoginRole")
        .get()
        .then((value) => currentRole = value.data()["LoggedInAs"]);
    return (currentRole == "Librarian" || currentRole == "Admin")
        ? true
        : false;
  } else {
    return false;
  }
}

//? Checks if the entered UserId belongs to a valid user
Future<bool> validUser(String userId) async {
  var validUser = await FirebaseFirestore.instance
      .collection("User")
      .where("UserId", isEqualTo: userId)
      .get();
  return validUser.docs.isNotEmpty;
}

//? Retrieves the document id of the enquired document
Future<String> getDocId(
    {String collectionName, String queryField, String queryItem}) async {
  String docId;
  await FirebaseFirestore.instance
      .collection(collectionName)
      .where(queryField, isEqualTo: queryItem)
      .get()
      .then((value) => docId = value.docs[0].id);
  return docId;
}

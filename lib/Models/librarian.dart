import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modules.dart';
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
Future<List<String>> librarianData() async {
  List<String> docId = [];
  final librarianData = await FirebaseFirestore.instance
      .collection("User")
      .where("UserRole", isEqualTo: "Librarian")
      .get();

  librarianData.docs.forEach((doc) {
    docId.add(doc.id);
  });
  return docId;
}

Future<List<Librarian>> getLibrarianData(List<String> docId) async {
  List<Librarian> librarianList = [];

  for (var i = 0; i < docId.length; i++) {
    var librarians = await FirebaseFirestore.instance
        .collection("User")
        .doc(docId[i])
        .collection("Librarian")
        .doc("LibrarianDetails")
        .get();

    //retrieve user details
    var user = await myActiveUser(docId: docId[i]);
    Map userDetails = user.toJson();
    //Librarian specific Details
    Map details = librarians.data();

    //Map the two sets of key/values together
    Map map = {};
    map.addAll(userDetails);
    map.addAll(details);

    //Instantiate librarian based on that
    librarianList.add(Librarian.fromJson(map));
  }
  return librarianList;
}

Future<void> createLibrarian(String librarianid, String librarianhp) async {
  String docid = await getDocId(
      collectionName: "User", queryField: "UserId", queryItem: librarianid);
  var addLibrarian = FirebaseFirestore.instance
      .collection("User")
      .doc(docid)
      .collection("Librarian")
      .doc("LibrarianDetails");

  await addLibrarian.set({
    "LibrarianPhoneNumber": librarianhp,
    "LibrarianStatus": "Trainee",
  }).catchError((e) => print(e));
}

Future<void> updateLibrarianStatus(String librarianid) async {
  String docid = await getDocId(
      collectionName: "User", queryField: "UserId", queryItem: librarianid);
  FirebaseFirestore.instance
      .collection("User")
      .doc(docid)
      .update({"UserRole": "Librarian"});
}

Future<void> deleteLibrarian(String librarianid) async {
  String docid = await getDocId(
      collectionName: "User", queryField: "UserId", queryItem: librarianid);
  FirebaseFirestore.instance
      .collection("User")
      .doc(docid)
      .update({"UserRole": "Student"});
}

Future<void> deleteLibrarianSubCollection(String librarianid) async {
  String docid = await getDocId(
      collectionName: "User", queryField: "UserId", queryItem: librarianid);
  FirebaseFirestore.instance
      .collection("User")
      .doc(docid)
      .collection("Librarian")
      .doc("LibrarianDetails")
      .delete();
}

// Future<void> deleteBook(String docId) async {
//   FirebaseFirestore.instance
//       .collection("BookCatalogue")
//       .doc(docId)
//       .delete()
//       .then((value) =>
//           print("Active Status for Discussion Room update successfully!"))
//       .catchError((onError) => print("An error has occurred: $onError"));
// }

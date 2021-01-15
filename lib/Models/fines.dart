import 'package:cloud_firestore/cloud_firestore.dart';

class Fines {
  String total, issueDate, reason, status, userId, finesId;

  Fines(this.issueDate, this.finesId, this.reason, this.status, this.total,
      this.userId);

  Map<String, String> toJson() => _fineToJson(this);

  Fines.fromSnapshot(DocumentSnapshot snapshot)
      : issueDate = snapshot['FinesIssueDate'],
        finesId = snapshot.id,
        reason = snapshot['FinesReason'],
        status = snapshot['FinesStatus'],
        total = snapshot['FinesTotal'],
        userId = snapshot['Userid'];
}

//? Converts map of values from Firestore into Fine object.
Fines fineFromJson(Map<String, dynamic> json) {
  return Fines(
    json["FinesIssueDate"] as String,
    json["FinesId"] as String,
    json["FinesReason"] as String,
    json["FinesStatus"] as String,
    json["FinesTotal"] as String,
    json["UserId"] as String,
  );
}

//? Converts the Fine class into key/value pairs
Map<String, dynamic> _fineToJson(Fines instance) => <String, dynamic>{
      "FinesIssueDate": instance.issueDate,
      "FinesReason": instance.reason,
      "FinesStatus": instance.status,
      "FinesTotal": instance.total,
      "UserId": instance.userId,
    };

//? Returns all fine records
Stream<List<Fines>> getAllFines() async* {
  List<Fines> allFines = [];
  await FirebaseFirestore.instance
      .collection("Fines")
      .get()
      .then((value) => value.docs.forEach((element) {
            allFines.add(fineFromJson(element.data()));
          }))
      .catchError((onError) => print(onError));
  yield allFines;
}

//? Returns all fines of a given attribute
Stream<List<Fines>> getFinesOf(String queryField, String queryItem) async* {
  List<Fines> finesOf = [];
  QuerySnapshot fines = await FirebaseFirestore.instance
      .collection("Fines")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .catchError((onError) =>
          print("Error retrieving fines data from database: $onError"));

  if (fines.docs.isNotEmpty) {
    fines.docs.forEach((doc) {
      finesOf.add(fineFromJson(doc.data()));
    });
  }
  yield finesOf;
}

Stream<List<Fines>> getFinesWithDocIdOf(
    String queryField, String queryItem) async* {
  List<Fines> finesOf = [];
  List<Fines> finalFines = [];
  List<String> finesId = [];
  QuerySnapshot finess = await FirebaseFirestore.instance
      .collection("Fines")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .catchError((onError) =>
          print("Error retrieving fines data from database: $onError"));

  if (finess.docs.isNotEmpty) {
    finess.docs.forEach((doc) {
      finesOf.add(fineFromJson(doc.data()));
      finesId.add(doc.id);
    });
  }
  for (var i = 0; i < finesOf.length; i++) {
    finalFines.add(Fines(
      finesOf[i].issueDate,
      finesId[i],
      finesOf[i].reason,
      finesOf[i].status,
      finesOf[i].total,
      finesOf[i].userId,
    ));
  }

  yield finalFines;
}

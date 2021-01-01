import 'package:cloud_firestore/cloud_firestore.dart';

class Fine {
  String total, dueDate, reason, status, userId, finesId;

  Fine(
    this.dueDate,
    this.finesId,
    this.reason,
    this.status,
    this.total,
    this.userId
  );

  Map<String, String> toJson() => _fineToJson(this);

  Fine.fromSnapshot(DocumentSnapshot snapshot) :
  dueDate = snapshot['FinesDue'],
  finesId = snapshot.id,
  reason = snapshot['FinesReason'],
  status = snapshot['FinesStatus'],
  total = snapshot['FinesTotal'],
  userId = snapshot['Userid'];
}

//? Converts map of values from Firestore into Fine object.
Fine fineFromJson(Map<String, dynamic> json) {
  return Fine(
      json["FinesDue"] as String,
      json["FinesId"] as String,
      json["FinesReason"] as String,
      json["FinesStatus"] as String,
      json["FinesTotal"] as String,
      json["UserId"] as String,
  );
}

//? Converts the Fine class into key/value pairs
Map<String, dynamic> _fineToJson(Fine instance) => <String, dynamic>{
      "FinesDue": instance.dueDate,
      "FinesReason": instance.reason,
      "FinesStatus": instance.status,
      "FinesTotal": instance.total,
      "UserId": instance.userId,
};

//? Returns all fines of a given attribute
Stream<List<Fine>> getFinesOf(
    String queryField, String queryItem) async* {
  List<Fine> finesOf = [];
  QuerySnapshot fines = await FirebaseFirestore.instance
      .collection("Fines")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .catchError((onError) =>
          print("Error retrieving booking data from database: $onError"));

  if (fines.docs.isNotEmpty) {
    fines.docs.forEach((doc) {
      finesOf.add(fineFromJson(doc.data()));
    });
  }
  yield finesOf;
}


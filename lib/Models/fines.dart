import 'package:cloud_firestore/cloud_firestore.dart';

class Fines {
  //^ Attributes
  String dueDate, reason, status, total, userId;

  //^ Constructor
  Fines(this.dueDate, this.reason, this.status, this.total, this.userId);

  Map<String, String> toJson() => _finesToJson(this);
}

//? Converts data from Firestore to a Fines instance
Fines finesFromJson(Map<String, dynamic> json) {
  return Fines(
    json["FinesDue"] as String,
    json["FinesReason"] as String,
    json["FinesStatus"] as String,
    json["FinesTotal"] as String,
    json["UserId"] as String,
  );
}

//? Converts data from Fines instance to map of key/value for sending to Firestore
Map<String, dynamic> _finesToJson(Fines instance) => <String, dynamic>{
      "FinesDue": instance.dueDate,
      "FinesReason": instance.reason,
      "FinesStatus": instance.status,
      "FinesTotal": instance.total,
      "UserId": instance.userId,
    };

Future<List<Fines>> getFinesOf(String queryField, String queryItem) async {
  List<Fines> finesList = [];
  await FirebaseFirestore.instance
      .collection("Fines")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .then((value) => value.docs.forEach((doc) {
            finesList.add(finesFromJson(doc.data()));
          }))
      .catchError((onError) =>
          print("Error retrieving data from Fines database: $onError"));
  return finesList;
}

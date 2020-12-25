import 'package:cloud_firestore/cloud_firestore.dart';

class StudyTable {
  //^ Attributes
  String tableNum, svgPath;

  //^ Constructor
  StudyTable(this.tableNum, this.svgPath);
}

//? Converts data from Firestore to a StudyTable instance
StudyTable studyTableFromJson(Map<String, dynamic> json) {
  return StudyTable(
    json["TableNum"] as String,
    json["TableSvgPath"] as String,
  );
}

//? Retrieve data from the database
Future<List<StudyTable>> getStudyTables() async {
  List<StudyTable> studyTable = [];
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection("StudyTable").get();

  snapshot.docs.forEach((doc) {
    studyTable.add(studyTableFromJson(doc.data()));
  });
  return studyTable;
}

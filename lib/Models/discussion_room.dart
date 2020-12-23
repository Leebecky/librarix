import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionRoom {
  //^ Attributes
  String roomNum, location;
  int size;

  //^ Constructor
  DiscussionRoom(this.location, this.roomNum, this.size);

  Map<String, String> toJson() => _discussionRoomToJson(this);
}

//? Converts data from Firestore to a DiscussionRoom instance
DiscussionRoom discussionRoomFromJson(Map<String, dynamic> json) {
  return DiscussionRoom(
    json["RoomLocation"] as String,
    json["RoomNum"] as String,
    json["RoomSize"] as int,
  );
}

//? Converts data from DiscussionRoom instance to map of key/value for sending to Firestore
Map<String, dynamic> _discussionRoomToJson(DiscussionRoom instance) =>
    <String, dynamic>{
      "RoomLocation": instance.location,
      "RoomNum": instance.roomNum,
      "RoomSize": instance.size,
    };

//? Retrive rooms of a given size
Future<List<DiscussionRoom>> getRoomsOfSize(int size) async {
  List<DiscussionRoom> dr = [];
  var rooms = await FirebaseFirestore.instance
      .collection("DiscussionRoom")
      .orderBy("RoomNum")
      // .where("RoomSize", isGreaterThanOrEqualTo: size)
      .get()
      .catchError((onError) => print(
          "An error has occurred while retrieving discussion room data: $onError"));

  if (rooms.docs.isNotEmpty) {
    rooms.docs.forEach((doc) {
      dr.add(discussionRoomFromJson(doc.data()));
    });
  }
  return dr.where((room) => room.size >= size).toList();
}

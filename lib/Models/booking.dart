import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// define booking class
class DiscussionRoomBooking {
  String roomNum, bookingDate, bookingStartTime, bookingEndTime, userId;

  DiscussionRoomBooking(this.roomNum, this.bookingDate, this.bookingStartTime,
      this.bookingEndTime, this.userId);

  Map<String, String> toJson() => _discussionRoomBookingToJson(this);
}

DiscussionRoomBooking discussionRoomBookingFromJson(Map<String, dynamic> json) {
  return DiscussionRoomBooking(
    json["RoomNum"] as String,
    json["BookingDate"] as String,
    json["BookingStartTime"] as String,
    json["BookingEndTime"] as String,
    json["UserId"] as String,
  );
}

Map<String, String> _discussionRoomBookingToJson(
        DiscussionRoomBooking instance) =>
    <String, String>{
      "RoomNum": instance.roomNum,
      "BookingDate": instance.bookingDate,
      "BookingStartTime": instance.bookingStartTime,
      "BookingEndTime": instance.bookingEndTime,
      "UserId": instance.userId,
    };

// define Study Table Booking
class StudyTableBooking {
  String tableNum, bookingDate, bookingStartTime, bookingEndTime, userId;

  StudyTableBooking(this.bookingDate, this.bookingEndTime,
      this.bookingStartTime, this.tableNum, this.userId);

  Map<String, String> toJson() => _bookingStudyTableToJson(this);
}

StudyTableBooking bookingStudyTableFromJson(Map<String, dynamic> json) {
  return StudyTableBooking(
    json["TableNum"] as String,
    json["BookingDate"] as String,
    json["BookingStartTime"] as String,
    json["BookingEndTime"] as String,
    json["UserId"] as String,
  );
}

Map<String, String> _bookingStudyTableToJson(StudyTableBooking instance) =>
    <String, String>{
      "TableNum": instance.tableNum,
      "BookingDate": instance.bookingDate,
      "BookingStartTime": instance.bookingStartTime,
      "BookingEndTime": instance.bookingEndTime,
      "UserId": instance.userId,
    };

Future<QuerySnapshot> getDiscussionRoomBooking() async {
  var firestore = FirebaseFirestore.instance;

  QuerySnapshot discussionRoomBookingDetails =
      await firestore.collection("DiscussionRoomBooking").get();

  return discussionRoomBookingDetails;
}

Future<QuerySnapshot> getStudyTableBooking() async {
  var firestore = FirebaseFirestore.instance;

  QuerySnapshot studyTableBookingDetails =
      await firestore.collection("StudyTableBooking").get();

  return studyTableBookingDetails;
}

// //merge
// class BookingRecord {
//   String roomNum,
//       bookingDate,
//       bookingStartTime,
//       bookingEndTime,
//       userId,
//       tableNum;

//   BookingRecord(this.bookingDate, this.bookingEndTime, this.bookingStartTime,
//       this.roomNum, this.userId, this.tableNum);

//   Map<String, String> toJson() => _bookingRecordToJson(this);
// }

// BookingRecord bookingRecordFromJson(Map<String, dynamic> json) {
//   return BookingRecord(
//     json["RoomNum"] as String,
//     json["BookingDate"] as String,
//     json["BookingStartTime"] as String,
//     json["BookingEndTime"] as String,
//     json["UserId"] as String,
//     json["TableNum"] as String,
//   );
// }

// Map<String, String> _bookingRecordToJson(BookingRecord instance) =>
//     <String, String>{
//       "RoomNum": instance.roomNum,
//       "BookingDate": instance.bookingDate,
//       "BookingStartTime": instance.bookingStartTime,
//       "BookingEndTime": instance.bookingEndTime,
//       "UserId": instance.userId,
//       "TableNum": instance.tableNum,
//     };

// Future<List<QuerySnapshot>> getBookingFuture() async {
//   var firestore = FirebaseFirestore.instance;

//   var data = await firestore
//       .collection("StudyTableBooking")
//       .doc(FirebaseFirestore.instance.toString())
//       .collection("DiscussionRoomBoking")
//       .get();

//   var bookingRecord = data.docs;
//   return bookingRecord;
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// define booking class
class Booking {
  String bookingDate,
      bookingStartTime,
      bookingEndTime,
      userId,
      roomOrTableNum,
      bookingType;

  Booking(this.bookingDate, this.bookingStartTime, this.bookingEndTime,
      this.userId, this.roomOrTableNum, this.bookingType);

  Map<String, String> toJson() => _bookingToJson(this);
}

Booking bookingFromJson(Map<String, dynamic> json) {
  return Booking(
    json["BookingDate"] as String,
    json["BookingStartTime"] as String,
    json["BookingEndTime"] as String,
    json["UserId"] as String,
    json["Room/TableNum"] as String,
    json["BookingType"] as String,
  );
}

Map<String, String> _bookingToJson(Booking instance) => <String, String>{
      "BookingDate": instance.bookingDate,
      "BookingStartTime": instance.bookingStartTime,
      "BookingEndTime": instance.bookingEndTime,
      "UserId": instance.userId,
      "Room/TableNum": instance.roomOrTableNum,
      "BookingType": instance.bookingType,
    };

//booking_Record Future Builder
Future<QuerySnapshot> getBooking() async {
  var firestore = FirebaseFirestore.instance;

  QuerySnapshot bookingDetails = await firestore.collection("Booking").get();

  return bookingDetails;
}

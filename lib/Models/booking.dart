import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//? Booking class
class Booking {
  String bookingDate,
      bookingStartTime,
      bookingEndTime,
      userId,
      roomOrTableNum,
      bookingType,
      bookingStatus;

  Booking(
    this.bookingDate,
    this.bookingEndTime,
    this.bookingStartTime,
    this.bookingStatus,
    this.bookingType,
    this.roomOrTableNum,
    this.userId,
  );
  Map<String, String> toJson() => _bookingToJson(this);
}

Booking bookingFromJson(Map<String, dynamic> json) {
  return Booking(
    json["BookingDate"] as String,
    json["BookingEndTime"] as String,
    json["BookingStartTime"] as String,
    json["BookingStatus"] as String,
    json["BookingType"] as String,
    json["Room/TableNum"] as String,
    json["UserId"] as String,
  );
}

Map<String, String> _bookingToJson(Booking instance) => <String, String>{
      "BookingDate": instance.bookingDate,
      "BookingEndTime": instance.bookingEndTime,
      "BookingStartTime": instance.bookingStartTime,
      "BookingStatus": instance.bookingStatus,
      "BookingType": instance.bookingType,
      "Room/TableNum": instance.roomOrTableNum,
      "UserId": instance.userId,
    };

//booking_Record Future Builder
Future<QuerySnapshot> getBooking() async {
  var firestore = FirebaseFirestore.instance;

  QuerySnapshot bookingDetails = await firestore.collection("Booking").get();

  return bookingDetails;
}

import 'package:cloud_firestore/cloud_firestore.dart';

//? Booking class
class Booking {
  String bookingDate,
      bookingStartTime,
      bookingEndTime,
      userId,
      roomOrTableNum,
      bookingType,
      bookingStatus,
      bookingId;

  Booking(this.bookingDate, this.bookingEndTime, this.bookingStartTime,
      this.bookingStatus, this.bookingType, this.roomOrTableNum, this.userId,
      [this.bookingId]);

  Map<String, String> toJson() => _bookingToJson(this);

  Booking.fromSnapshot(QueryDocumentSnapshot snapshot)
      : bookingDate = snapshot['BookingDate'],
        bookingStartTime = snapshot['BookingStartTime'],
        bookingEndTime = snapshot['BookingEndTime'],
        userId = snapshot['UserId'],
        roomOrTableNum = snapshot['RoomOrTableNum'],
        bookingType = snapshot['BookingType'],
        bookingStatus = snapshot['BookingStatus'],
        bookingId = snapshot.id;
}

Booking bookingFromJson(Map<String, dynamic> json) {
  return Booking(
    json["BookingDate"] as String,
    json["BookingEndTime"] as String,
    json["BookingStartTime"] as String,
    json["BookingStatus"] as String,
    json["BookingType"] as String,
    json["RoomOrTableNum"] as String,
    json["UserId"] as String,
  );
}

Map<String, String> _bookingToJson(Booking instance) => <String, String>{
      "BookingDate": instance.bookingDate,
      "BookingEndTime": instance.bookingEndTime,
      "BookingStartTime": instance.bookingStartTime,
      "BookingStatus": instance.bookingStatus,
      "BookingType": instance.bookingType,
      "RoomOrTableNum": instance.roomOrTableNum,
      "UserId": instance.userId,
    };

//booking_Record Future Builder
Future<QuerySnapshot> getBooking() async {
  var firestore = FirebaseFirestore.instance;

  QuerySnapshot bookingDetails = await firestore.collection("Booking").get();

  return bookingDetails;
}

//? Creates new record in database
Future<void> createBooking(Booking bookingRecord) async {
  FirebaseFirestore.instance
      .collection("Booking")
      .add(_bookingToJson(bookingRecord))
      .then(
        (value) => print("Booking has been successfully created!"),
      )
      .catchError((onError) => print("An error was encountered: $onError"));
}

//? Returns all bookings of a given attribute
Stream<List<Booking>> getBookingsOf(
    String queryField, String queryItem) async* {
  List<Booking> bookingsOf = [];
  QuerySnapshot bookings = await FirebaseFirestore.instance
      .collection("Booking")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .catchError((onError) =>
          print("Error retrieving booking data from database: $onError"));

  if (bookings.docs.isNotEmpty) {
    bookings.docs.forEach((doc) {
      bookingsOf.add(bookingFromJson(doc.data()));
    });
  }
  yield bookingsOf;
}

Stream<List<Booking>> getBookingsWithDocIdOf(
    String queryField, String queryItem) async* {
  List<Booking> bookingsOf = [];
  List<Booking> finalBooking = [];
  List<String> bookingId = [];
  QuerySnapshot bookings = await FirebaseFirestore.instance
      .collection("Booking")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .catchError((onError) =>
          print("Error retrieving booking data from database: $onError"));

  if (bookings.docs.isNotEmpty) {
    bookings.docs.forEach((doc) {
      bookingsOf.add(bookingFromJson(doc.data()));
      bookingId.add(doc.id);
    });
  }
  for (var i = 0; i < bookingsOf.length; i++) {
    finalBooking.add(Booking(
        bookingsOf[i].bookingDate,
        bookingsOf[i].bookingEndTime,
        bookingsOf[i].bookingStartTime,
        bookingsOf[i].bookingStatus,
        bookingsOf[i].bookingType,
        bookingsOf[i].roomOrTableNum,
        bookingsOf[i].userId,
        bookingId[i]));
  }

  yield finalBooking;
}

Future<void> updateBookingCompletedStatus(String docId) async {
  FirebaseFirestore.instance
      .collection("Booking")
      .doc(docId)
      .update({"BookingStatus": "Completed"})
      .then((value) =>
          print("Completed Status for Discussion Room update successfully!"))
      .catchError((onError) => print("An error has occurred: $onError"));
}

Future<void> updateBookingCancelledStatus(String docId) async {
  FirebaseFirestore.instance
      .collection("Booking")
      .doc(docId)
      .update({"BookingStatus": "Cancelled"})
      .then((value) =>
          print("Cancelled Status for Discussion Room update successfully!"))
      .catchError((onError) => print("An error has occurred: $onError"));
}

Future<void> updateBookingActiveStatus(String docId) async {
  FirebaseFirestore.instance
      .collection("Booking")
      .doc(docId)
      .update({"BookingStatus": "Active"})
      .then((value) =>
          print("Active Status for Discussion Room update successfully!"))
      .catchError((onError) => print("An error has occurred: $onError"));
}

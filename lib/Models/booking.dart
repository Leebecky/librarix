import 'package:cloud_firestore/cloud_firestore.dart';
import '../modules.dart';

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

//? Retrieves all booking records in the database
Stream<List<Booking>> getAllBookings() async* {
  List<Booking> allBookings = [];
  await FirebaseFirestore.instance
      .collection("Booking")
      .get()
      .then((value) => value.docs.forEach((doc) {
            allBookings.add(bookingFromJson(doc.data()));
          }))
      .catchError((onError) => print(onError));
  yield allBookings;
}

//? Creates new record in database
Future<String> createBooking(Booking bookingRecord) async {
  String docId;
  await FirebaseFirestore.instance
      .collection("Booking")
      .add(_bookingToJson(bookingRecord))
      .then(
        (value) => docId = value.id,
      )
      .catchError((onError) => print("An error was encountered: $onError"));
  return docId;
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

  finalBooking.sort((a, b) {
    DateTime aDate = parseStringToDate(a.bookingDate);
    DateTime bDate = parseStringToDate(b.bookingDate);
    return bDate.compareTo(aDate);
  });

  yield finalBooking;
}

Future<void> updateBookingCompletedStatus(String docId) async {
  await FirebaseFirestore.instance
      .collection("Booking")
      .doc(docId)
      .update({"BookingStatus": "Completed"})
      .then((value) =>
          print("Completed Status for Discussion Room update successfully!"))
      .catchError((onError) => print("An error has occurred: $onError"));
}

Future<void> updateBookingCancelledStatus(String docId) async {
  await FirebaseFirestore.instance
      .collection("Booking")
      .doc(docId)
      .update({"BookingStatus": "Cancelled"})
      .then((value) =>
          print("Cancelled Status for Discussion Room update successfully!"))
      .catchError((onError) => print("An error has occurred: $onError"));
}

Future<void> updateBookingActiveStatus(String docId) async {
  await FirebaseFirestore.instance
      .collection("Booking")
      .doc(docId)
      .update({"BookingStatus": "Active"})
      .then((value) =>
          print("Active Status for Discussion Room update successfully!"))
      .catchError((onError) => print("An error has occurred: $onError"));
}

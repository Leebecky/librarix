import 'package:cloud_firestore/cloud_firestore.dart';
import './book.dart';
import './user.dart';
import './notifications.dart';
import '../modules.dart';

//? Model for the BorrowedBook database records
class Borrow {
  //^ Attributes
  String userId,
      bookId,
      bookTitle,
      borrowedDate,
      returnedDate,
      status,
      borrowedId;
  int timesRenewed;

  //^ Constructor
  Borrow(this.userId, this.bookId, this.bookTitle, this.borrowedDate,
      this.timesRenewed, this.returnedDate, this.status,
      [this.borrowedId]);

  //? Converts the Borrow into a map of key/value pairs
  Map<String, String> toJson() => _borrowToJson(this);

  Borrow.fromSnapshot(DocumentSnapshot snapshot)
      : userId = snapshot["UserId"],
        bookId = snapshot["BookId"],
        bookTitle = snapshot["BookTitle"],
        borrowedDate = snapshot["BorrowDate"],
        returnedDate = snapshot["BorrowReturnedDate"],
        status = snapshot["BorrowStatus"],
        timesRenewed = snapshot["BorrowRenewedTimes"],
        borrowedId = snapshot.id;
}

//? Converts map of values from Firestore into Borrow object.
Borrow borrowFromJson(Map<String, dynamic> json, [SetOptions options]) {
  return Borrow(
    json["UserId"] as String,
    json["BookId"] as String,
    json["BookTitle"] as String,
    json["BorrowDate"] as String,
    json["BorrowRenewedTimes"] as int,
    json["BorrowReturnedDate"] as String,
    json["BorrowStatus"] as String,
  );
}

//? Converts the Borrow class into key/value pairs
Map<String, dynamic> _borrowToJson(Borrow instance) => <String, dynamic>{
      "UserId": instance.userId,
      "BookId": instance.bookId,
      "BookTitle": instance.bookTitle,
      "BorrowDate": instance.borrowedDate,
      "BorrowRenewedTimes": instance.timesRenewed,
      "BorrowReturnedDate": instance.returnedDate,
      "BorrowStatus": instance.status,
    };

//? Creates a borrowed book record
Future<String> createBorrowRecord(Borrow record) async {
  int stock;
  String docId;
  (record.status == "Borrowed") ? stock = -1 : stock = 0;
  await FirebaseFirestore.instance
      .collection("BorrowedBook")
      .add(_borrowToJson(record))
      .then((value) {
    docId = value.id;
    updateBookStock(record.bookId, stock);
  }).catchError((onError) => print("An error has occurred: $onError"));
  return docId;
}

//? Retrieves all Borrow Records
Stream<List<Borrow>> getAllBorrowRecords() async* {
  List<Borrow> borrowRecordList = [];
  await FirebaseFirestore.instance
      .collection("BorrowedBook")
      .get()
      .then((value) => value.docs.forEach((doc) {
            borrowRecordList.add(borrowFromJson(doc.data()));
          }))
      .catchError((onError) =>
          print("Error retrieving booking data from database: $onError"));
  yield borrowRecordList;
}

//? Retrieves all borrowed book records of a user
Future<List<Borrow>> getUserBorrowRecords(String userId) async {
  List<Borrow> userRecords = [];
  var records = await FirebaseFirestore.instance
      .collection("BorrowedBook")
      .where("UserId", isEqualTo: userId)
      .get();
  if (records.docs.isNotEmpty) {
    records.docs.forEach((doc) => userRecords.add(borrowFromJson(doc.data())));
  }
  return userRecords;
}

//? Returns all borrowed records of a given attribute
Stream<List<Borrow>> getBorrowedOf(String queryField, String queryItem) async* {
  List<Borrow> borrowedOf = [];
  QuerySnapshot borrowed = await FirebaseFirestore.instance
      .collection("BorrowedBook")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .catchError((onError) =>
          print("Error retrieving booking data from database: $onError"));

  if (borrowed.docs.isNotEmpty) {
    borrowed.docs.forEach((doc) {
      borrowedOf.add(borrowFromJson(doc.data()));
    });
  }
  yield borrowedOf;
}

//?Retrieve data from Firestore
Stream<List<Borrow>> getBorrowedWithDocIdOf(
    String queryField, String queryItem) async* {
  List<Borrow> borrowedOf = [],
      finalBorrowed = [],
      reservations = [],
      borrowRecords = [];
  List<String> borowedId = [];
  QuerySnapshot borrowed = await FirebaseFirestore.instance
      .collection("BorrowedBook")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .catchError((onError) =>
          print("Error retrieving booking data from database: $onError"));

  if (borrowed.docs.isNotEmpty) {
    borrowed.docs.forEach((doc) {
      borrowedOf.add(borrowFromJson(doc.data()));
      borowedId.add(doc.id);
    });
  }
  for (var i = 0; i < borrowedOf.length; i++) {
    finalBorrowed.add(Borrow(
        borrowedOf[i].userId,
        borrowedOf[i].bookId,
        borrowedOf[i].bookTitle,
        borrowedOf[i].borrowedDate,
        borrowedOf[i].timesRenewed,
        borrowedOf[i].returnedDate,
        borrowedOf[i].status,
        borowedId[i]));
  }

  // Separate Reserved Books from Borrowed Books
  finalBorrowed.forEach((record) => reservations.add(record));
  reservations.removeWhere((record) => record.status != "Reserved");
  reservations.join(",");

  finalBorrowed.removeWhere((record) => record.status == "Reserved");
  finalBorrowed.join(",");

  //Sort borrowed books by date
  finalBorrowed.sort((a, b) {
    DateTime aDate = parseStringToDate(a.returnedDate);
    DateTime bDate = parseStringToDate(b.returnedDate);
    return bDate.compareTo(aDate);
  });

  //Combine borrowed books and reserved books together. Reserved books at the bottom.
  finalBorrowed.forEach((record) => borrowRecords.add(record));
  reservations.forEach((record) => borrowRecords.add(record));

  yield borrowRecords;
}

//update book reservation list --- reserve => borrow
Future<void> updateBorrowStatus(String docId, String bookId) async {
  FirebaseFirestore.instance
      .collection("BorrowedBook")
      .doc(docId)
      .update({
        "BorrowStatus": "Borrowed",
        "BorrowDate": parseDate(DateTime.now().toString()),
        "BorrowReturnedDate": parseDate(calculateReturnDate())
      })
      .then((value) => {
            print("Reserved book has been borrowed!"),
            updateBookStock(bookId, -1)
          })
      .catchError((onError) => print("An error has occurred: $onError"));
}

//update book reservation list  --- reserve => borrow
Future<void> updateCancelStatus(String docId) async {
  FirebaseFirestore.instance
      .collection("BorrowedBook")
      .doc(docId)
      .update({"BorrowStatus": "Cancelled"})
      .then((value) =>
          print("Completed Status for Discussion Room update successfully!"))
      .catchError((onError) => print("An error has occurred: $onError"));
}

//update book reservation list  --- borrow => return
Future<void> updateReturnStatus(String docId, String bookId) async {
  FirebaseFirestore.instance
      .collection("BorrowedBook")
      .doc(docId)
      .update({"BorrowStatus": "Returned"})
      .then((value) => {
            updateBookStock(bookId, 1),
            print("Completed Status for Discussion Room update successfully!")
          })
      .catchError((onError) => print("An error has occurred: $onError"));
}

/* Future<void> returnBook(Borrow record) async {
  int stock;
  (record.status == "Returned") ? stock = 1 : stock = 0;
  FirebaseFirestore.instance
      .collection("BorrowedBook")
      .add(_borrowToJson(record))
      .then((value) {
    print("Book has been successfully returned!");
    updateBookStock(record.bookId, stock);
  }).catchError((onError) => print("An error has occurred: $onError")); 
}*/
//? Creates book reservation record
Future createReservationRecord(String bookId, String bookTitle) async {
  ActiveUser myUser = await myActiveUser();

  DocumentReference ref =
      await FirebaseFirestore.instance.collection("BorrowedBook").add({
    'BookId': bookId,
    'BookTitle': bookTitle,
    'BorrowDate': "Not Available",
    'BorrowRenewedTimes': 0,
    'BorrowReturnedDate': "Not Available",
    'BorrowStatus': 'Reserved',
    'UserId': myUser.userId,
  });
  print(ref.id);

  //? Creates a notification
  await saveNotification(
      userId: myUser.userId,
      saveToStaff: true,
      notificationInstance: createInstance(
          details: ref.id,
          title: "Book Reservation - ${myUser.userId}",
          content: "$bookTitle has been reserved by ${myUser.userId}",
          displayDate: parseDate(DateTime.now().toString()),
          type: "Book Reservation"));
}

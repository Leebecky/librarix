import 'package:cloud_firestore/cloud_firestore.dart';
import './book.dart';

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
        timesRenewed = snapshot["BorrowRenewedTime"],
        borrowedId = snapshot.id;
}

//? Converts map of values from Firestore into Borrow object.
Borrow borrowFromJson(Map<String, dynamic> json, [SetOptions options]) {
  return Borrow(
    json["UserId"] as String,
    json["BookId"] as String,
    json["BookTitle"] as String,
    json["BorrowDate"] as String,
    json["BorrowRenewedTime"] as int,
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
      "BorrowRenewedTime": instance.timesRenewed,
      "BorrowReturnedDate": instance.returnedDate,
      "BorrowStatus": instance.status,
    };

//? Creates a borrowed book record
Future<void> createBorrowRecord(Borrow record) async {
  int stock;
  (record.status == "Borrowed") ? stock = -1 : stock = 0;
  FirebaseFirestore.instance
      .collection("BorrowedBook")
      .add(_borrowToJson(record))
      .then((value) {
    print("Book has been successfully borrowed!");
    updateBookStock(record.bookId, stock);
  }).catchError((onError) => print("An error has occurred: $onError"));
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
  List<Borrow> borrowedOf = [];
  List<Borrow> finalBorrowed = [];
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

  yield finalBorrowed;
}

//update book reservation list --- reserve => borrow
Future<void> updateBorrowStatus(String docId) async {
  FirebaseFirestore.instance
      .collection("BorrowedBook")
      .doc(docId)
      .update({"BorrowStatus": "Borrowed"})
      .then((value) =>
          print("Completed Status for Discussion Room update successfully!"))
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

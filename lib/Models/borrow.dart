import 'package:cloud_firestore/cloud_firestore.dart';
import './book.dart';

//? Model for the BorrowedBook database records
class Borrow {
  //^ Attributes
  String userId, bookId, bookTitle, borrowedDate, returnedDate, status;
  int timesRenewed;

  //^ Constructor
  Borrow(this.userId, this.bookId, this.bookTitle, this.borrowedDate,
      this.timesRenewed, this.returnedDate, this.status);

  //? Converts the Borrow into a map of key/value pairs
  Map<String, String> toJson() => _borrowToJson(this);
}

//? Converts map of values from Firestore into Borrow object.
Borrow borrowFromJson(Map<String, dynamic> json) {
  return Borrow(
    json["UserId"] as String,
    json["BookId"] as String,
    json["BookTitle"] as String,
    json["BorrowDate"] as String,
    json["BorrowRenewalTimes"] as int,
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
      "BorrowRenewalTimes": instance.timesRenewed,
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
Stream<List<Borrow>> getBorrowedOf(
    String queryField, String queryItem) async* {
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

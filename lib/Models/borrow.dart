import 'package:cloud_firestore/cloud_firestore.dart';
import './book.dart';

//? Model for the BorrowedBook database records
class Borrow {
  //^ Attributes
  String userId, bookId, bookTitle, borrowedDate, returnedDate, status;

  //^ Constructor
  Borrow(this.userId, this.bookId, this.bookTitle, this.borrowedDate,
      this.returnedDate, this.status);

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
      "BorrowReturnedDate": instance.returnedDate,
      "BorrowStatus": instance.status,
    };

//? Creates a borrowed book record
//TODO update bookStock
Future<void> createBorrowRecord(Borrow record) async {
  FirebaseFirestore.instance
      .collection("BorrowedBook")
      .add(_borrowToJson(record))
      .then((value) {
    print("Book has been successfully borrowed!");
    updateBookStock(record.bookId, -1);
  }).catchError((onError) => print("An error has occurred: $onError"));
  }

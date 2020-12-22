import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  //^ Attributes
  String author,
      barcode,
      description,
      genre,
      isbnCode,
      image,
      publishDate,
      publisher,
      title;
  int stock;

  //^ Constructor
  Book(this.author, this.barcode, this.description, this.genre, this.isbnCode,
      this.image, this.publishDate, this.publisher, this.stock, this.title);
      
  //? Converts the Book into a map of key/value pairs
  Map<String, String> toJson() => _bookToJson(this);

}

//? Converts map of values from Firestore into Book object.
Book bookFromJson(Map<String, dynamic> json) {
  return Book(
    json["BookAuthor"] as String,
    json["BookBarcode"] as String,
    json["BookDescription"] as String,
    json["BookGenre"] as String,
    json["BookISBNCode"] as String,
    json["BookImage"] as String,
    json["BookPublishDate"] as String,
    json["BookPublisher"] as String,
    json["BookStock"] as int,
    json["BookTitle"] as String,
  );
}

//? Converts the Book class into key/value pairs
Map<String, dynamic> _bookToJson(Book instance) => <String, dynamic>{
      "BookAuthor": instance.author,
      "BookBarcode": instance.barcode,
      "BookDescription": instance.description,
      "UserIntakeCodeOrSchool": instance.genre,
      "BookISBNCode": instance.isbnCode,
      "BookImage": instance.image,
      "BookPublishDate": instance.publishDate,
      "BookPublisher": instance.publisher,
      "BookStock": instance.stock,
      "BookTitle": instance.title,
    };

//? Updates BookStock
Future<void> updateBookStock(String docId, int stockCount) async {
  FirebaseFirestore.instance
      .collection("BookCatalogue")
      .doc(docId)
      .update({"BookStock": FieldValue.increment(stockCount)})
      .then((value) => print("Book Stock has been updated!"))
      .catchError((onError) => print("An error has occurred: $onError"));
}

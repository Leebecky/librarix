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
      title,
      id;
  int stock;

  //^ Constructor
  Book(this.author, this.barcode, this.description, this.genre, this.isbnCode,
      this.image, this.publishDate, this.publisher, this.stock, this.title, this.id);
      
  //? Converts the Book into a map of key/value pairs
  Map<String, String> toJson() => _bookToJson(this);

  Book.fromSnapshot(DocumentSnapshot snapshot) :
    author = snapshot['BookAuthor'],
    barcode = snapshot['BookBarcode'],
    description = snapshot['BookDescription'],
    genre = snapshot['BookGenre'],
    isbnCode = snapshot['BookISBNCode'],
    image = snapshot['BookImage'],
    publishDate = snapshot['BookPublishDate'],
    publisher = snapshot['BookPublisher'],
    stock = snapshot['BookStock'],
    title = snapshot['BookTitle'],
    id = snapshot.id;
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
    json['BookId'] as String
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

Future<QuerySnapshot> getBook() async {
  var firestore = FirebaseFirestore.instance;

  QuerySnapshot bookDetails = await firestore.collection("BookCatalogue").get();

  return bookDetails;
}


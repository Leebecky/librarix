import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../../Custom_Widget/textfield.dart';
import '../../../Models/book.dart';

class EditBook extends StatefulWidget {
  final DocumentSnapshot bookCatalogue;
  EditBook({this.bookCatalogue});

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  bool isLoading = false;
  Book book;
  String title,
      isbnCode,
      barcode,
      genre,
      author,
      publisher,
      publishedDate,
      description,
      image;
  int stock;

  TextEditingController _titleC = TextEditingController();
  TextEditingController _isbnCodeC = TextEditingController();
  TextEditingController _barcodeC = TextEditingController();
  TextEditingController _genreC = TextEditingController();
  TextEditingController _authorC = TextEditingController();
  TextEditingController _publisherC = TextEditingController();
  TextEditingController _publishedDateC = TextEditingController();
  TextEditingController _descriptionC = TextEditingController();
  TextEditingController _stockC = TextEditingController();
  // TextEditingController _imageC = TextEditingController();
  @override
  void initState() {
    super.initState();
    getEditBook();
  }

  getEditBook() async {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance
        .collection("BookCatalogue")
        .doc(widget.bookCatalogue.id)
        .get();

    genre = widget.bookCatalogue["BookGenre"];
    title = widget.bookCatalogue["BookTitle"];
    _titleC.text = widget.bookCatalogue["BookTitle"];
    _isbnCodeC.text = widget.bookCatalogue["BookISBNCode"];
    _barcodeC.text = widget.bookCatalogue["BookBarcode"];
    _genreC.text = widget.bookCatalogue["BookGenre"];
    _authorC.text = widget.bookCatalogue["BookAuthor"];
    _publisherC.text = widget.bookCatalogue["BookPublisher"];
    _publishedDateC.text = widget.bookCatalogue["BookPublishDate"];
    _descriptionC.text = widget.bookCatalogue["BookDescription"];
    _stockC.text = widget.bookCatalogue["BookStock"].toString();
    // _imageC.text = widget.bookCatalogue["BookImage"];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            // widget.bookCatalogue.id + "\n" +
            widget.bookCatalogue["BookTitle"]),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    controller: _titleC,
                    // text: "Book Title",
                    text: title,
                    fixKeyboardToNum: false,
                    onChange: (value) => title = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    controller: _isbnCodeC,
                    text: "Book ISBN Code",
                    fixKeyboardToNum: true,
                    onChange: (value) => isbnCode = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    controller: _barcodeC,
                    text: "Book Barcode",
                    fixKeyboardToNum: true,
                    onChange: (value) => barcode = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: DropdownButtonFormField(
                    value: genre,
                    items: [
                      DropdownMenuItem(
                        value: "Fantasy",
                        child: Text("Fantasy"),
                      ),
                      DropdownMenuItem(
                        value: "Education",
                        child: Text("Education"),
                      ),
                      DropdownMenuItem(
                        value: "Drama",
                        child: Text("Drama"),
                      ),
                      DropdownMenuItem(
                        value: "Action and Adventure",
                        child: Text("Action and Adventure"),
                      ),
                      DropdownMenuItem(
                        value: "Historical Fiction",
                        child: Text("Historical Fiction"),
                      ),
                      DropdownMenuItem(
                        value: "Horror",
                        child: Text("Horror"),
                      ),
                      DropdownMenuItem(
                        value: "Romance",
                        child: Text("Romance"),
                      ),
                    ],
                    decoration: InputDecoration(
                        labelText: "Book Genre",
                        hintText: "Please select book genre",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor))),
                    onChanged: (String value) {
                      setState(() {
                        genre = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    controller: _authorC,
                    text: "Author",
                    fixKeyboardToNum: false,
                    onChange: (value) => author = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    controller: _publisherC,
                    text: "Publisher",
                    fixKeyboardToNum: false,
                    onChange: (value) => publisher = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: _publishedDateC,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                        labelText: 'Published Date',
                        hintText: "DD/MM/YYYY",
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor))),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                      LengthLimitingTextInputFormatter(10),
                      _DateFormatter(),
                    ],
                    onChanged: (value) => publishedDate = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    controller: _descriptionC,
                    text: "Book Description",
                    fixKeyboardToNum: false,
                    onChange: (value) => description = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    controller: _stockC,
                    text: 'Stock',
                    fixKeyboardToNum: true,
                    onChange: (value) => stock = int.parse(value),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                      width: 150,
                      height: 50,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: Theme.of(context).accentColor,
                          colorBrightness:
                              Theme.of(context).accentColorBrightness,
                          child: Text(
                            "Update",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () {
                            return showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Update Book Catalogue',
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              "Do you sure wanted to update this book catalogue?")
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            updateBook();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          }),
                                      TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          })),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: Colors.red,
                          child: Text(
                            "Delete",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () {
                            return showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Delete Book Catalogue',
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              "Do you sure wanted to delete this book catalogue?")
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          return showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Double Confirm',
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            "Confirm to delete this book catalogue?")
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text("Yes"),
                                                      onPressed: () async {
                                                        deleteBook(widget
                                                            .bookCatalogue.id);
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text("No"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          })),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future updateBook() async {
    await FirebaseFirestore.instance
        .collection("BookCatalogue")
        .doc(widget.bookCatalogue.id)
        .set({
      'BookTitle': _titleC.text,
      'BookISBNCode': _isbnCodeC.text,
      'BookBarcode': _barcodeC.text,
      'BookGenre': genre,
      'BookAuthor': _authorC.text,
      'BookPublisher': _publisherC.text,
      'BookPublishDate': _publishedDateC.text,
      'BookDescription': _descriptionC.text,
      'BookImage':
          "https://images-na.ssl-images-amazon.com/images/I/61bKTJvsWGL._SX334_BO1,204,203,200_.jpg",
      'BookStock': int.parse(_stockC.text),
    });
  }
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

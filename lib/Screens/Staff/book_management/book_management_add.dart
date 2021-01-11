import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Custom_Widget/buttons.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import '../../../Custom_Widget/textfield.dart';
// import 'dart:math';
// import 'book_management_select_image.dart';

class AddNewBook extends StatefulWidget {
  @override
  _AddNewBookState createState() => _AddNewBookState();
}

class _AddNewBookState extends State<AddNewBook> {
  String title,
      isbnCode,
      barcode,
      genre,
      author,
      publisher,
      publishedDate,
      description,
      stock,
      image;

  File bookImage;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    PickedFile image = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        bookImage = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getFromGallery() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        bookImage = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Book"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(
              children: <Widget>[
                bookImage == null
                    ? Text('')
                    : Image.file(bookImage,
                        width: 300, height: 200, fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomOutlineButton(
                    buttonText: "Select Book Image",
                    roundBorder: false,
                    onClick: () => _showImagePicker(context),
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return AddBookImage();
                    // }));
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextField(
                    text: "Book Title",
                    fixKeyboardToNum: false,
                    onChange: (value) => title = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextField(
                    text: "Book ISBN Code",
                    fixKeyboardToNum: true,
                    onChange: (value) => isbnCode = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextField(
                    text: "Book Barcode",
                    fixKeyboardToNum: true,
                    onChange: (value) => barcode = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: DropdownButtonFormField(
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
                    // onChange: (value) => bookGenre = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextField(
                    text: "Author",
                    fixKeyboardToNum: false,
                    onChange: (value) => author = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextField(
                    text: "Publisher",
                    fixKeyboardToNum: false,
                    onChange: (value) => publisher = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    // maxLength: 10,
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
                  child: CustomTextField(
                    text: "Book Description",
                    fixKeyboardToNum: false,
                    onChange: (value) => description = value,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: CustomTextField(
                      text: 'Stock',
                      fixKeyboardToNum: true,
                      onChange: (value) => stock = value,
                    )),
                CustomFlatButton(
                  roundBorder: true,
                  buttonText: "Add",
                  onClick: () async {
                    createBookCatalogue();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //add bookImage and bookStock
  Future createBookCatalogue() async {
    try {
      // DocumentReference ref =
      await FirebaseFirestore.instance.collection("BookCatalogue").add({
        'BookTitle': title,
        'BookISBNCode': isbnCode,
        'BookBarcode': barcode,
        'BookGenre': genre,
        'BookAuthor': author,
        'BookPublisher': publisher,
        'BookPublishDate': publishedDate,
        'BookDescription': description,
        'BookImage':
            "https://images-na.ssl-images-amazon.com/images/I/61bKTJvsWGL._SX334_BO1,204,203,200_.jpg", //temp
        'BookStock': stock,
      });
    } catch (e) {
      print(e.message);
    }
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

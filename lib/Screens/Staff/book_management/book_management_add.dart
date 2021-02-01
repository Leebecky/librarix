import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Custom_Widget/buttons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../../../Custom_Widget/custom_alert_dialog.dart';
import 'dart:async';
import 'dart:io';
import '../../../Custom_Widget/textfield.dart';

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
      imgURL;
  int stock;
  File image;

  @override
  void initState() {
    title = "";
    isbnCode = "";
    barcode = "";
    genre = "Education";
    author = "";
    publisher = "";
    publishedDate = "";
    description = "";
    super.initState();
  }

  File bookImage;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
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
            key: _formKey,
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
                  child: CustomValidTextField(
                    text: "Book Title",
                    fixKeyboardToNum: false,
                    onChange: (value) => title = value,
                    validate: (title) =>
                        title.isEmpty ? "This Field is required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomValidTextField(
                    text: "Book ISBN Code",
                    fixKeyboardToNum: true,
                    onChange: (value) => isbnCode = value,
                    validate: (isbnCode) =>
                        isbnCode.isEmpty ? "This Field is required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomValidTextField(
                    text: "Book Barcode",
                    fixKeyboardToNum: true,
                    onChange: (value) => barcode = value,
                    validate: (barcode) =>
                        barcode.isEmpty ? "This Field is required" : null,
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
                  child: CustomValidTextField(
                    text: "Author",
                    fixKeyboardToNum: false,
                    onChange: (value) => author = value,
                    validate: (author) =>
                        author.isEmpty ? "This Field is required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomValidTextField(
                    text: "Publisher",
                    fixKeyboardToNum: false,
                    onChange: (value) => publisher = value,
                    validate: (publisher) =>
                        publisher.isEmpty ? "This Field is required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
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
                    validator: (publishedDate) =>
                        publishedDate.isEmpty ? "This Field is required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomValidTextField(
                    text: "Book Description",
                    fixKeyboardToNum: false,
                    onChange: (value) => description = value,
                    validate: (description) =>
                        description.isEmpty ? "This Field is required" : null,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: CustomValidTextField(
                      text: 'Stock',
                      fixKeyboardToNum: true,
                      onChange: (value) => {
                        stock = int.parse(value),
                      },
                      validate: (stock) =>
                          stock.isEmpty ? "This Field is required" : null,
                    )),
                CustomFlatButton(
                  roundBorder: true,
                  buttonText: "Add",
                  onClick: () async {
                    if (_formKey.currentState.validate()) {
                      createBookCatalogue();
                      uploadImgToStorage(context);
                      Navigator.of(context).pop();
                      customAlertDialog(
                        context,
                        title: "Book Management",
                        content:
                            "New book successfully added to the Catalogue!",
                      );
                    } else {
                      customAlertDialog(
                        context,
                        title: "Empty textfield",
                        content: "Please fill up any empty fields!",
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future uploadImgToStorage(BuildContext context) async {
    String fileName = basename(bookImage.path);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('BookCatalogue/$fileName');
    UploadTask uploadTask = storageRef.putFile(bookImage);
    uploadTask.whenComplete(() async {
      imgURL = await storageRef.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
  }

  //add bookImage and bookStock
  Future createBookCatalogue() async {
    try {
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
            "https://firebasestorage.googleapis.com/v0/b/librarix.appspot.com/o/BookCatalogue%2Fimage_picker1243998155796938203.jpg?alt=media&token=c4e102f0-ab00-40bf-a50d-aac16fd97971", //temp
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

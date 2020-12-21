import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:librarix/Screens/scanned_book_details.dart';
import '../Models/user.dart';
import '../Models/borrow.dart';
import '../Custom_Widget/general_alert_dialog.dart';

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  //^ Text Controller for retrieving the ISBN code
  String codeType, bookCode, userId;
  var unreturnedBooks;
  @override
  void initState() {
    bookCode = "Waiting for input . . . ";
    codeType = "BookISBNCode";
    userId = "";
    printBookCodeType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Book Borrower"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.qr_code_scanner_rounded),
                onPressed: () => scanBarcode()),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //~ UserId display field
              Padding(
                padding: EdgeInsets.all(20),
                child: FutureBuilder<bool>(
                  future: isStaff(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    //^ if User is Staff, create a textfield
                    if (snapshot.data == true) {
                      return TextField(
                        onChanged: (text) {
                          setState(() {
                            userId = text.toUpperCase();
                            return userId.toUpperCase();
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "Please enter the Student/Lecturer's ID",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ))),
                      );
                    } else {
                      //^ If User is not Staff, return UserId in Text()
                      return FutureBuilder<ActiveUser>(
                        future: myActiveUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<ActiveUser> user) {
                          if (user.hasData) {
                            userId = user.data.userId;
                            return Text("User ID: ${user.data.userId}");
                          }
                          return LinearProgressIndicator();
                        },
                      );
                    }
                  },
                ),
              ),
              //~ Barcode/ISBN display field
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  //~ locks the keyboard to numerical only
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      labelText: "Enter ISBN Code or Scan book barcode",
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).accentColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).accentColor))),
                  onChanged: (newText) {
                    setState(() {
                      bookCode = newText;
                      codeType = "BookISBNCode";
                    });
                  },
                ),
              ),
              Padding(
                //~ Displays the code type entered
                padding: EdgeInsets.all(20),
                child: Text("${printBookCodeType()} = $bookCode"),
              ),
              FlatButton(
                //~ The Confirmation button
                color: Theme.of(context).accentColor,
                colorBrightness: Theme.of(context).accentColorBrightness,
                onPressed: () async => {
                  if (await validUser(userId))
                    {
                      //~ If user id is valid, check if they have exceeded the borrow book limit
                      unreturnedBooks = await activeBorrows(),
                      if (unreturnedBooks.length == 3)
                        {
                          showDialog(
                              context: context,
                              child: generalAlertDialog(context,
                                  title: "Book Borrow Limit Reached",
                                  content:
                                      "No more than three books can be borrowed at a time. Please return the books that are currently borrowed!"))
                        }
                      else
                        //~ if the user has not exceeded the limit, proceed
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScannedBookDetails(
                                      bookCode, codeType, userId)))
                        }
                    }
                  else
                    {
                      //~ Invalid User ID entered
                      showDialog(
                          context: context,
                          child: generalAlertDialog(context,
                              title: "Invalid User",
                              content: "No user with this ID has been found!"))
                    }
                },
                child: Text("Confirm"),
              ),
            ],
          ),
        ));
  }

//? Barcode scanning
  Future<void> scanBarcode() async {
    String bookBarcode = "";

    try {
      bookBarcode = await FlutterBarcodeScanner.scanBarcode(
          "#0859C6", "Manual Entry", true, ScanMode.BARCODE);
    } catch (e) {
      print("An unexpected error has occurred: $e");
    }

    setState(() {
      bookCode = bookBarcode;
      codeType = "BookBarcode";
    });
  }

  //? Checks if the User is a library staff member
  Future<bool> isStaff() async {
    bool isStaff;
    String currentUser = FirebaseAuth.instance.currentUser.uid;
    bool isAdmin = await checkRole(currentUser, "Admin");
    bool isLibrarian = await checkRole(currentUser, "Librarian");
    (isLibrarian || isAdmin) ? isStaff = true : isStaff = false;
    return isStaff;
  }

  //? Checks if the entered UserId belongs to a valid user
  Future<bool> validUser(String userId) async {
    var validUser = await FirebaseFirestore.instance
        .collection("User")
        .where("UserId", isEqualTo: userId)
        .get();
    return validUser.docs.isNotEmpty;
  }

  //? Separates the codeType for printing
  String printBookCodeType() {
    String printCodeType;
    (codeType == "BookISBNCode")
        ? printCodeType = "Book ISBN Code"
        : printCodeType = "Book Barcode";
    return printCodeType;
  }

  //? Checks if you are still allowed to borrow books
  Future<List<Borrow>> activeBorrows() async {
    List<Borrow> currentBorrows = await getUserBorrowRecords(userId);
    if (currentBorrows.isNotEmpty) {
      return currentBorrows
          .where((record) => record.status == "Borrowed")
          .toList();
    }
    return currentBorrows = [];
  }
}

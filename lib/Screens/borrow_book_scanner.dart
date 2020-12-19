import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librarix/Screens/scanned_book_details.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../Models/user.dart';

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  //^ Text Controller for retrieving the ISBN code
  String codeType, bookCode, userId;

  @override
  void initState() {
    bookCode = "Waiting for input . . . ";
    codeType = "BookISBNCode";
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
                    if (snapshot.data) {
                      return TextField(
                        onChanged: (text) => userId = text,
                        decoration: InputDecoration(
                            labelText: "Please enter the Student/Lecturer's ID",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ))),
                      );
                    } else {
                      //^ If User is not Staff, return UserId in Text()
                      return FutureBuilder<ActiveUser>(
                        future: myActiveUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<ActiveUser> snapshot) {
                          userId = snapshot.data.userId;
                          return Text("User ID: ${snapshot.data.userId}");
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
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
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
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).accentColor,
                onPressed: () async => {
                  (await validUser(userId))
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScannedBookDetails(
                                  bookCode, codeType, userId.toUpperCase())))
                      : showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text("Invalid User"),
                            content:
                                Text("No user with this ID has been found!"),
                            actions: [
                              FlatButton(
                                child: Text("Close"),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ))
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
    print(validUser.docs.isNotEmpty);
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
}

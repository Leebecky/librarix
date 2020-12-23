import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:librarix/Screens/scanned_book_details.dart';
// import '../Models/user.dart';
import '../Models/borrow.dart';
import '../Custom_Widget/general_alert_dialog.dart';
import '../Custom_Widget/user_id_field.dart';
import '../modules.dart';

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  //^ Text Controller for retrieving the ISBN code
  String codeType, bookCode;
  var unreturnedBooks;
  ValueNotifier<String> userId = ValueNotifier("");

  @override
  void initState() {
    bookCode = "Waiting for input . . . ";
    codeType = "BookISBNCode";
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
                child: userIdField(userId),
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
                child: Text("${printBookCodeType()} = $bookCode",
                    style: TextStyle(fontSize: 18.0)),
              ),
              FlatButton(
                //~ The Confirmation button
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                colorBrightness: Theme.of(context).accentColorBrightness,
                onPressed: () async => {
                  if (await validUser(userId.value))
                    {
                      //~ If user id is valid, check if they have exceeded the borrow book limit
                      unreturnedBooks = await activeBorrows(),
                      if (unreturnedBooks.length == 3)
                        {
                         generalAlertDialog(context,
                                  title: "Book Borrow Limit Reached",
                                  content:
                                      "No more than three books can be borrowed at a time. Please return the books that are currently borrowed!")
                        }
                      else
                        //~ if the user has not exceeded the limit, proceed
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScannedBookDetails(
                                      bookCode, codeType, userId.value)))
                        }
                    }
                  else
                    {
                      //~ Invalid User ID entered
                     generalAlertDialog(context,
                              title: "Invalid User",
                              content: "No user with this ID has been found!")
                    }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                  child: Text("Confirm",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w400)),
                ),
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
    List<Borrow> currentBorrows = await getUserBorrowRecords(userId.value);
    if (currentBorrows.isNotEmpty) {
      return currentBorrows
          .where((record) => record.status == "Borrowed")
          .toList();
    }
    return currentBorrows = [];
  }
}

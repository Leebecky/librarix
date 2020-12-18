import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:librarix/Screens/scanned_book_details.dart';

//TODO implement textfield for user id
class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  //^ Text Controller for retrieving the ISBN code
  final bookCodeCtrl = TextEditingController();
  String bookCode;
  String codeType;

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
        body: Center(
          child: Column(
            children: [
              //~ Barcode/ISBN display field
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  //~ locks the keyboard to numerical only
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: bookCodeCtrl,
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
                padding: EdgeInsets.all(20),
                child: Text("Bookcode = $bookCode"),
              ),
              FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).accentColor,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ScannedBookDetails(bookCode, codeType))),
                child: Text("Click Me!"),
              )
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
    // bookCodeCtrl.text = bookBarcode;
    // return bookBarcode;
    // return bookCodeCtrl.text;
    /*  if (bookBarcode != "") {
      return bookCodeCtrl.text;
    } else {
      return false;
    } */
  }

  @override
  void dispose() {
    bookCodeCtrl.dispose();
    super.dispose();
  }
}

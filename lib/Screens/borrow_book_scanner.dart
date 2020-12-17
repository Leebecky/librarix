import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:librarix/Screens/scanned_book_details.dart';

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
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text("Book Borrower"),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code_scanner_rounded),
              onPressed: () => scanBarcode(),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              //~ Barcode/ISBN display field
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: bookCodeCtrl,
                  decoration: InputDecoration(
                      labelText: "Enter ISBN Code or Scan book barcode",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).accentColor))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("Bookcode = $bookCode"),
              ),
              FlatButton(
                color: Theme.of(context).accentColor,
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
  Future<bool> scanBarcode() async {
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
    if (bookBarcode != "") {
      return true;
    } else {
      return false;
    }
  }
}

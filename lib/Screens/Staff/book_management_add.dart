import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 3.0),
  ),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 3.0)),
);

class AddNewBook extends StatelessWidget {
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
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(labelText: "Book Title"),
                // validator: (val) => val.isEmpty ? 'Please enter Book Title' : null, onChanged: (val) {
                //   setState(()=>)
                // },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(labelText: "Book ISBN Code"),
                // validator: (val) => val.isEmpty ? 'Please enter Book Title' : null, onChanged: (val) {
                //   setState(()=>)
                // },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(labelText: "Description"),
                // validator: (val) => val.isEmpty ? 'Please enter Book Title' : null, onChanged: (val) {
                //   setState(()=>)
                // },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(labelText: "Book Author"),
                // validator: (val) => val.isEmpty ? 'Please enter Book Title' : null, onChanged: (val) {
                //   setState(()=>)
                // },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(labelText: "Book Publisher"),
                // validator: (val) => val.isEmpty ? 'Please enter Book Title' : null, onChanged: (val) {
                //   setState(()=>)
                // },
              ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // TextFormField(
              //   decoration:
              //       textInputDecoration.copyWith(labelText: "Publish Date"),
              //   // validator: (val) => val.isEmpty ? 'Please enter Book Title' : null, onChanged: (val) {
              //   //   setState(()=>)
              //   // },
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // TextFormField(
              //   decoration: textInputDecoration.copyWith(labelText: "Book Image"),
              //   // validator: (val) => val.isEmpty ? 'Please enter Book Title' : null, onChanged: (val) {
              //   //   setState(()=>)
              //   // },
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // TextFormField(
              //   decoration: textInputDecoration.copyWith(labelText: "Barcode"),
              //   // validator: (val) => val.isEmpty ? 'Please enter Book Title' : null, onChanged: (val) {
              //   //   setState(()=>)
              //   // },
              // ),
            ],
          )),
        ),
      ),
    );
  }
}

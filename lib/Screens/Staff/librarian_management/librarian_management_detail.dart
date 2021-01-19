import 'package:flutter/material.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Custom_Widget/textfield.dart';
import '../../../Models/librarian.dart';

class LibrarianManagementDetail extends StatefulWidget {
  final String dlibrarian;
  final Librarian data;
  LibrarianManagementDetail({this.dlibrarian, this.data});

  @override
  _LibrarianManagementDetailState createState() =>
      _LibrarianManagementDetailState();
}

class _LibrarianManagementDetailState extends State<LibrarianManagementDetail> {
  bool isLoading = false;
  Librarian librarian;
  String userID, phoneNo, status;

  TextEditingController _name = TextEditingController();
  TextEditingController _phoneno = TextEditingController();

  @override
  void initState() {
    super.initState();
    getEditLibrarian();
  }

  getEditLibrarian() async {
    setState(() {
      isLoading = true;
    });

    _name.text = widget.data.name;
    _phoneno.text = widget.data.phoneNum;
    status = widget.data.status;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.data.avatar),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    widget.data.userId,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    widget.data.name,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomDisplayTextField(
                    controller: _phoneno,
                    text: "Phone Number",
                    fixKeyboardToNum: false,
                    onChange: (value) => phoneNo = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: DropdownButtonFormField(
                    value: status,
                    items: [
                      DropdownMenuItem(
                        value: "Trainee",
                        child: Text("Trainee"),
                      ),
                      DropdownMenuItem(
                        value: "Librarian",
                        child: Text("Librarian"),
                      ),
                    ],
                    decoration: InputDecoration(
                        labelText: "Librarian Status",
                        hintText: "Please select librarian status",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor))),
                    onChanged: (String value) {
                      setState(() {
                        status = value;
                      });
                    },
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
                                      'Update Librarian Details',
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text("Update librarian detail?")
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            // updateBook(); update function
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            // customAlertDialog(context,
                                            //     title:
                                            //         "Update Librarian Detail",
                                            //     content:
                                            //         "Update librarian details sucessfully");
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
                                      'Resign Librarian Position',
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              "Sure to Resign Librarian Position?")
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
                                                            "Confirm to resign this librarian?")
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text("Yes"),
                                                      onPressed: () async {
                                                        // deleteBook(widget
                                                        //     .bookCatalogue.id); delete function
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        customAlertDialog(
                                                            context,
                                                            title:
                                                                "Resign Librarian",
                                                            content:
                                                                "Resign librarian sucessfully");
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
}

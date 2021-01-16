import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

class FirstView extends StatelessWidget {
  final primaryColor = const Color(0xFF7fbfe9);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: primaryColor,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.15),
              AutoSizeText("Welcome to LibrariX",
                  maxLines: 1,
                  style: TextStyle(fontSize: 44, color: Colors.white)),
              SizedBox(height: _height * 0.10),
              AutoSizeText("Life Is A Book, \nLet's Start Reading",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, color: Colors.white)),
              SizedBox(height: _height * 0.15),
              RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  onPressed: () {
                    Get.offAllNamed("/login");
                  }),
            ],
          ),
        )),
      ),
    );
  }
}

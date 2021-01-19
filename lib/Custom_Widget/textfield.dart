import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final bool fixKeyboardToNum;
  final Function onChange;
  final Color borderColor;
  CustomTextField(
      {this.text,
      this.onChange,
      this.fixKeyboardToNum = false,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> formatList = [];
    TextInputFormatter digits = FilteringTextInputFormatter.digitsOnly;
    TextInputType keyboardType;
    Color textFieldBorderColor;

    (borderColor == null)
        ? textFieldBorderColor = Theme.of(context).accentColor
        : textFieldBorderColor = borderColor;

    if (fixKeyboardToNum) {
      keyboardType = TextInputType.number;
      formatList.add(digits);
    } else {
      keyboardType = TextInputType.text;
      digits = null;
    }

    return TextField(
      //~ locks the keyboard to numerical only
      keyboardType: keyboardType,
      inputFormatters: formatList,
      decoration: InputDecoration(
          labelText: text,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldBorderColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldBorderColor))),
      onChanged: (newText) => onChange(newText),
    );
  }
}

class CustomDisplayTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool fixKeyboardToNum;
  final Function onChange;
  final Color borderColor;

  CustomDisplayTextField({
    this.text,
    this.controller,
    this.onChange,
    this.fixKeyboardToNum = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> formatList = [];
    TextInputFormatter digits = FilteringTextInputFormatter.digitsOnly;
    TextInputType keyboardType;
    Color textFieldBorderColor;

    (borderColor == null)
        ? textFieldBorderColor = Theme.of(context).accentColor
        : textFieldBorderColor = borderColor;

    if (fixKeyboardToNum) {
      keyboardType = TextInputType.number;
      formatList.add(digits);
    } else {
      keyboardType = TextInputType.text;
      digits = null;
    }

    return TextField(
      //~ locks the keyboard to numerical only
      keyboardType: keyboardType,
      inputFormatters: formatList,
      controller: controller,
      decoration: InputDecoration(
          labelText: text,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldBorderColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldBorderColor))),
      onChanged: (newText) => onChange(newText),
    );
  }
}

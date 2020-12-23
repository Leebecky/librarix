import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final bool fixKeyboardToNum;
  final Function onChange;
  final Color borderColor;
  CustomTextField(
      {this.text, this.onChange, this.fixKeyboardToNum, this.borderColor});

  @override
  Widget build(BuildContext context) {
    TextInputFormatter digits;
    Color textFieldBorderColor;

    (borderColor == null)
        ? textFieldBorderColor = Theme.of(context).accentColor
        : textFieldBorderColor = borderColor;

    (fixKeyboardToNum)
        ? digits = FilteringTextInputFormatter.digitsOnly
        : digits = null;

    return TextField(
      //~ locks the keyboard to numerical only
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[digits],
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

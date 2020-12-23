import 'package:flutter/material.dart';

//? Outline Button (button with border)
class CustomOutlineButton extends StatelessWidget {
  final String buttonText;
  final double buttonWidth;
  final Function onClick;
  final bool roundBorder;
  final BuildContext context;
  final Color borderColor;

  CustomOutlineButton(
      {this.context,
      this.buttonText,
      this.buttonWidth = 1.5,
      this.roundBorder = false,
      this.onClick,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    ShapeBorder borderShape;
    Color buttonBorderColor;

    //^ If borderColor is not specified, use the default color
    (borderColor == null)
        ? buttonBorderColor = Theme.of(context).accentColor
        : buttonBorderColor = borderColor;

    //^ Sets the border shape
    (roundBorder)
        ? borderShape =
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
        : borderShape =
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5.0));

    return SizedBox(
        width: MediaQuery.of(context).size.width / buttonWidth,
        child: OutlineButton(
          shape: borderShape,
          borderSide: BorderSide(color: buttonBorderColor),
          child: Text(buttonText),
          onPressed: () => onClick(),
        ));
  }
}

class CustomFlatButton extends StatelessWidget {
  final double buttonWidth;
  final Function onClick;
  final bool roundBorder;
  final String buttonText;
  final Color darkColor;
  final Brightness lightColor;

  CustomFlatButton(
      {this.buttonText,
      this.buttonWidth,
      this.onClick,
      this.roundBorder,
      this.lightColor,
      this.darkColor});

  @override
  Widget build(BuildContext context) {
    Color buttonColorDark;
    Brightness buttonColorLight;
    ShapeBorder borderShape;

    (buttonColorDark == null)
        ? buttonColorDark = Theme.of(context).accentColor
        : buttonColorDark = darkColor;

    (buttonColorLight == null)
        ? buttonColorLight = Theme.of(context).accentColorBrightness
        : buttonColorLight = lightColor;

    (roundBorder)
        ? borderShape =
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
        : borderShape =
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5.0));

    return SizedBox(
        width: buttonWidth,
        child: FlatButton(
            shape: borderShape,
            color: buttonColorDark,
            colorBrightness: buttonColorLight,
            child: Text(buttonText),
            onPressed: () => onClick()));
  }
}

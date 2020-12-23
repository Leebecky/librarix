import 'package:flutter/material.dart';

Widget bookingListWheelScrollView(BuildContext context,
    {List<Text> listChildren, Function itemChanged}) {
  return Expanded(
      //~ minutes
      child: ListWheelScrollView(
          itemExtent: 30,
          useMagnifier: true,
          magnification: 2.0,
          diameterRatio: 1.0,
          overAndUnderCenterOpacity: 0.3,
          children: listChildren,
          onSelectedItemChanged: (index) => itemChanged(index)));
}

//? Row of buttons under ListWheelScrollView
Widget listScrollButtons(BuildContext context, {Function checkButtonClicked}) {
  return Row(
    children: [
      Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.clear),
            )),
      ),
      Expanded(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Icon(Icons.check),
                  onPressed: () => {
                        checkButtonClicked(),
                        Navigator.of(context).pop(),
                      }))),
    ],
  );
}

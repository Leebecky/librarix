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
          children: listChildren,
          onSelectedItemChanged:
              itemChanged() /* (index) {
              selectedMin = minutes[index].data;
              setTimeStrings(timeType, selectedHour, selectedMin);
            } */
          ));
}

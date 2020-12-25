import 'package:flutter/material.dart';
import 'package:librarix/Screens/Booking/study_table_floor_plan.dart';
import '../../Custom_Widget/buttons.dart';

class BookingStudyTable extends StatefulWidget {
  @override
  _BookingStudyTableState createState() => _BookingStudyTableState();
}

class _BookingStudyTableState extends State<BookingStudyTable> {
  String selectedStudyTable;

  @override
  void initState() {
    selectedStudyTable = "Select a table";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomOutlineButton(
          buttonText: "Study Table: $selectedStudyTable",
          onClick: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => FloorPlan())),
        )
      ],
    );
  }
}

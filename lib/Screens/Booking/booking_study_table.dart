import 'package:flutter/material.dart';
import 'package:librarix/Models/study_table.dart';
import 'package:librarix/Screens/Booking/study_table_floor_plan.dart';
import '../../Custom_Widget/buttons.dart';
import '../../Models/booking.dart';

class BookingStudyTable extends StatefulWidget {
  final String startTime, endTime, date;
  final ValueNotifier<String> userId;
  BookingStudyTable(this.userId, this.date, this.startTime, this.endTime);
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

  //? Queries bookings, compares with rooms and returns list of available rooms
  Future<List<String>> getTablesAvailable(String date) async {
    String startTime = (widget.startTime.split(":").join("")),
        endTime = (widget.endTime.split(":").join(""));
    List<String> tablesAvailable = [];
    List<String> listOfBookedTables = [];

    //^ list of all study tables
    List<StudyTable> allTables = await getStudyTables();

    //^  list of all bookings on a given date
    List<Booking> allBookings = await getBookingsOf("BookingDate", date);

    //^ list of active/ongoing bookings on a given date
    List<Booking> clashingBookings = allBookings
        .where((booking) =>
            booking.bookingStatus != "Cancelled" &&
            booking.bookingType == "Study Table")
        .toList();

//? checks for any clashing bookings at the (user) selected time
    clashingBookings.removeWhere((booking) =>
        int.parse(startTime) >=
            int.parse(booking.bookingEndTime.split(":").join("")) ||
        int.parse(endTime) <=
            int.parse(booking.bookingStartTime.split(":").join("")));
    clashingBookings.join(",");
    //^ if clashingBookings.isEmpty = true, no clashing bookings exist
    if (clashingBookings.isEmpty) {
      //~ return the list of available rooms
      for (var room in allTables) {
        tablesAvailable.add(room.tableNum);
      }
    } else {
      //^ process allTables and remove rooms that are booked
      //~ add to a list, the rooms that are in use
      for (var booking in clashingBookings) {
        listOfBookedTables.add(booking.roomOrTableNum);
      }
      //~ remove from (all) table list, tables that are in use
      for (var tableInUse in listOfBookedTables) {
        allTables.removeWhere((room) => room.tableNum == tableInUse.toString());
        allTables.join(",");
      }
      //~ return list of available tables
      for (var room in allTables) {
        tablesAvailable.add(room.tableNum);
      }

      //~ if therea are no tables available at all
      (tablesAvailable.length == 0)
          ? tablesAvailable
              .add("Sorry, there are no available tables available right now")
          : tablesAvailable = tablesAvailable;
    }
    return tablesAvailable;
  }
}

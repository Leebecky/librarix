import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/study_table.dart';
import 'package:librarix/Screens/Booking/study_table_floor_plan.dart';
import '../../Custom_Widget/buttons.dart';
import '../../Models/booking.dart';
import '../../Custom_Widget/general_alert_dialog.dart';
import '../../modules.dart';

//TODO check floor plan sizing
//TODO prevent selection of booked tables
class BookingStudyTable extends StatefulWidget {
  final String startTime, endTime, date;
  final ValueNotifier<String> userId;
  BookingStudyTable(this.userId, this.date, this.startTime, this.endTime);
  @override
  _BookingStudyTableState createState() => _BookingStudyTableState();
}

class _BookingStudyTableState extends State<BookingStudyTable> {
  ValueNotifier<String> selectedStudyTable;
  ValueNotifier<bool> tablesFound;
  @override
  void initState() {
    tablesFound = ValueNotifier(true);
    selectedStudyTable = ValueNotifier<String>("Select a table");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<String>>(
            future: getTablesAvailable(widget.date),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                return ValueListenableBuilder<String>(
                    valueListenable: selectedStudyTable,
                    builder:
                        (BuildContext context, String value, Widget child) {
                      return CustomOutlineButton(
                          buttonText:
                              "Study Table: ${selectedStudyTable.value}",
                          onClick: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FloorPlan(
                                      tablesAvailable: snapshot.data,
                                      selectedStudyTable:
                                          selectedStudyTable))));
                    });
              }
              return SpinKitWave(
                color: Theme.of(context).accentColor,
              );
            }),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: CustomFlatButton(
                roundBorder: true,
                buttonText: "Confirm Booking",
                onClick: () async {
                  if (await validUser(widget.userId.value)) {
                    //~ User Id is Valid
                    if (await getUserBookings(widget.userId))
                    //~ Check if User has active bookings
                    {
                      if (completeBookingDetails(tablesFound.value)) {
                        createBooking(createMyBooking(widget.userId));
                        generalAlertDialog(context,
                            title: "Booking",
                            content: "Booking successfully created!");
                      } else {
                        generalAlertDialog(context,
                            title: "Booking",
                            content:
                                "Please fill in all booking details first!");
                      }
                    } else {
                      generalAlertDialog(context,
                          title: "Active Booking Found",
                          content:
                              "Please clear your current booking before making another one!");
                    }
                  } else {
                    //~ UserId is invalid
                    generalAlertDialog(context,
                        title: "Invalid User",
                        content: "No user with this ID has been found!");
                  }
                }))
      ],
    );
  }

  //? Queries bookings if the user has any active bookings
  Future<bool> getUserBookings(ValueNotifier userId) async {
    String uid = userId.value;
    List<Booking> userBookings = await getBookingsOf("UserId", uid);
    var existingBooking = userBookings.where((details) =>
        details.bookingStatus == "Active" &&
        details.bookingType == "Study Table");
    return existingBooking.isEmpty;
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
      for (var tables in allTables) {
        tablesAvailable.add(tables.tableNum);
      }
    } else {
      //^ process allTables and remove rooms that are booked
      //~ add to a list, the rooms that are in use
      for (var booking in clashingBookings) {
        listOfBookedTables.add(booking.roomOrTableNum);
      }
      //~ remove from (all) table list, tables that are in use
      for (var tableInUse in listOfBookedTables) {
        allTables
            .removeWhere((table) => table.tableNum == tableInUse.toString());
        allTables.join(",");
      }
      //~ return list of available tables
      for (var table in allTables) {
        tablesAvailable.add(table.tableNum);
      }
    }
    //~ if therea are no tables available at all
    (tablesAvailable.length == 0)
        ? tablesAvailable
            .add("Sorry, there are no available tables available right now")
        : tablesAvailable = tablesAvailable;

    return tablesAvailable;
  }

//? Creates the Booking object for study table bookings
  Booking createMyBooking(ValueNotifier userId) {
    String bookingDate = widget.date,
        bookingEndTime = widget.endTime,
        bookingStartTime = widget.startTime,
        bookingType = "Study Table",
        uid = userId.value,
        roomOrTableNum = selectedStudyTable.value;

    Booking myBooking = Booking(bookingDate, bookingEndTime, bookingStartTime,
        "Active", bookingType, roomOrTableNum, uid);

    return myBooking;
  }

  //? Checks if all booking details have been filled
  bool completeBookingDetails(bool tablesFound) {
    String bookingStartTime = widget.startTime,
        bookingEndTime = widget.endTime,
        roomOrTableNum = selectedStudyTable.value;

    return (bookingStartTime == "Select a start time" ||
            bookingEndTime == "Select an end time" ||
            roomOrTableNum == "Select a table" ||
            tablesFound == false)
        ? false
        : true;
  }
}

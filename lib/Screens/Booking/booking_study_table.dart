import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Screens/Booking/study_table_floor_plan.dart';
import '../../Custom_Widget/buttons.dart';
import '../../Models/booking.dart';
import '../../Custom_Widget/custom_alert_dialog.dart';
import '../../modules.dart';

class BookingStudyTable extends StatefulWidget {
  final String startTime, endTime, date;
  final ValueNotifier<String> userId;
  BookingStudyTable(this.userId, this.date, this.startTime, this.endTime);

  @override
  _BookingStudyTableState createState() => _BookingStudyTableState();
}

class _BookingStudyTableState extends State<BookingStudyTable> {
  String initialStartTime, initialEndTime, initialDate;
  ValueNotifier<String> selectedStudyTable;
  ValueNotifier<bool> detailsChange;

  @override
  void initState() {
    initialDate = widget.date;
    initialEndTime = widget.endTime;
    initialStartTime = widget.startTime;
    detailsChange = ValueNotifier(false);
    selectedStudyTable = ValueNotifier<String>("Select a table");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: detailsChange,
            builder: (BuildContext context, bool value, Widget child) {
              //Validation Check: resets selected table value when date/time changes
              if (widget.startTime != initialStartTime ||
                  widget.endTime != initialEndTime) {
                value = !value;
                selectedStudyTable.value = "Select a table";
                initialStartTime = widget.startTime;
                initialEndTime = widget.endTime;
              }
              if (widget.date != initialDate) {
                value = !value;
                initialDate = widget.date;
                selectedStudyTable.value = "Select a table";
              }
              //~ All Validation checks are passed: build the floor plan widget
              return ValueListenableBuilder<String>(
                  valueListenable: selectedStudyTable,
                  builder: (BuildContext context, String value, Widget child) {
                    return CustomOutlineButton(
                        buttonText: "Study Table: ${selectedStudyTable.value}",
                        onClick: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return StreamBuilder<List<String>>(
                                  stream: getBookedTables(widget.date),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<String>> snapshot) {
                                    if (snapshot.hasData) {
                                      return FloorPlan(
                                          bookedTables: snapshot.data,
                                          selectedStudyTable:
                                              selectedStudyTable);
                                    }
                                    return SpinKitWave(
                                      color: Theme.of(context).accentColor,
                                    );
                                  });
                            })));
                  });
            }),
        Padding(
            //~ Confirm Booking button
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
                      if (completeBookingDetails()) {
                        createBooking(createMyBooking(widget.userId));
                        // All validation checks are passed: create the booking
                        customAlertDialog(context,
                            navigateHome: true,
                            title: "Booking",
                            content: "Booking successfully created!");
                      } else {
                        //Incomplete booking details
                        customAlertDialog(context,
                            title: "Booking",
                            content:
                                "Please fill in all booking details first!");
                      }
                    } else {
                      //User has already booked a study table
                      customAlertDialog(context,
                          title: "Active Booking Found",
                          content:
                              "Please clear your current booking before making another one!");
                    }
                  } else {
                    //~ UserId is invalid
                    customAlertDialog(context,
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
    List<Booking> userBookings = [];

    //^ Retrieve all bookings belonging to the user
    await for (var booking in getBookingsOf("UserId", uid)) {
      userBookings = booking;
    }

    //^ Process the user's bookings to filter out the active study table bookings
    var existingBooking = userBookings.where((details) =>
        (details.bookingStatus == "Active" ||
            details.bookingStatus == "Booked") &&
        details.bookingType == "Study Table");
    return existingBooking.isEmpty;
  }

//? Queries bookings, compares with rooms and returns list of available rooms
  Stream<List<String>> getBookedTables(String date) async* {
    String startTime = (widget.startTime.split(":").join("")),
        endTime = (widget.endTime.split(":").join(""));
    List<String> listOfBookedTables = [];
    List<Booking> allBookings = [];

    //^  list of all bookings on a given date
    await for (var booking in getBookingsOf("BookingDate", date)) {
      allBookings = booking;
    }

    //^ Filters for a list of active/ongoing bookings on a given date
    List<Booking> clashingBookings = allBookings
        .where((booking) =>
            (booking.bookingStatus != "Cancel") &&
            booking.bookingType == "Study Table")
        .toList();

    //^ checks for any clashing bookings at the (user) selected time
    clashingBookings.removeWhere((booking) =>
        int.parse(startTime) >=
            int.parse(booking.bookingEndTime.split(":").join("")) ||
        int.parse(endTime) <=
            int.parse(booking.bookingStartTime.split(":").join("")));
    clashingBookings.join(",");

    if (clashingBookings.isNotEmpty) {
      //~ add to a list, the tables that are in use
      for (var booking in clashingBookings) {
        listOfBookedTables.add(booking.roomOrTableNum);
      }
    }
    yield listOfBookedTables;
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
        "Booked", bookingType, roomOrTableNum, uid);

    return myBooking;
  }

  //? Checks if all booking details have been filled
  bool completeBookingDetails() {
    String roomOrTableNum = selectedStudyTable.value;

    return (roomOrTableNum == "Select a table") ? false : true;
  }
}

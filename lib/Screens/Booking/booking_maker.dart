import 'package:flutter/material.dart';
import 'package:librarix/Screens/Booking/booking_discussion_room.dart';
import 'package:librarix/modules.dart';
import '../../Custom_Widget/booking_list_wheel_scroll_view.dart';
import '../../Custom_Widget/user_id_field.dart';
import '../../Custom_Widget/buttons.dart';
import './booking_study_table.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class BookingMaker extends StatefulWidget {
  @override
  _BookingMakerState createState() => _BookingMakerState();
}

//? For selecting the type of widget to display
enum BookingType { discussionRoom, studyTable }

class _BookingMakerState extends State<BookingMaker> {
  ValueNotifier<String> userId = ValueNotifier("");
  List<Text> minutes, hours;
  BookingType type;
  String dateSelected,
      selectedHour,
      selectedMin,
      endTimeString,
      startTimeString,
      startHour,
      startMin,
      endHour,
      endMin;

  @override
  void initState() {
    type = BookingType.discussionRoom;
    dateSelected = parseDate(DateTime.now().toString());
    minutes = [Text("Minutes:"), Text("00"), Text("30")];
    hours = [Text("Hour:")];
    startHour = setStartHour().toString();
    startMin = "00";
    selectedHour = setStartHour().toString();
    selectedMin = "00";
    startTimeString = "${setStartHour()}:$selectedMin";
    endTimeString = "${setStartHour() + 1}:00";
    super.initState();
  }

  //^ Main build method
  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              //~ Select Booking Type
              padding: EdgeInsets.all(20),
              child: DropdownButton<BookingType>(
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                      value: BookingType.discussionRoom,
                      child: Text("Discussion Room")),
                  DropdownMenuItem(
                      value: BookingType.studyTable,
                      child: Text("Study Table")),
                ],
                value: type,
                onChanged: (value) => selectBookingType(value),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: userIdField(userId),
            ),
            //~ Shared Booking Details
            CustomOutlineButton(
              buttonText: "Date: $dateSelected",
              onClick: () async => showDatePicker(
                      context: context,
                      initialDate: (TimeOfDay.now().hour > 19)
                          ? DateTime.now().add(Duration(days: 1))
                          : DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 6)))
                  .then((date) => setState(() {
                        dateSelected = parseDate(date.toString());
                        startTimeString = "${setStartHour()}:$selectedMin";
                        endTimeString = "${setStartHour() + 1}:00";
                      })),
            ),
            CustomOutlineButton(
              buttonText: "Start Time: $startTimeString",
              onClick: () => timePicker(
                "start",
                earliestTime: setStartHour(),
                latestTime: 20,
                maxHours: 11,
              ),
            ),
            CustomOutlineButton(
              buttonText: "End Time: $endTimeString",
              onClick: () => timePicker(
                "end",
                earliestTime: (int.parse(startHour) + 1),
                latestTime: 21,
                maxHours: 4,
              ),
            ),
            //~ Specific Booking Type Details
            bookingMakerType(),
          ],
        )));
  }

  //? Start/End Time Picker
  timePicker(String timeType,
      {int earliestTime, int latestTime, int maxHours}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(children: [
                Expanded(
                    child: Row(children: <Widget>[
                  //~ hours
                  bookingListWheelScrollView(context,
                      listChildren:
                          setTime(timeType, earliestTime, latestTime, maxHours),
                      itemChanged: (index) => {
                            selectedHour = hours[index].data,
                          }),
                  //~ minutes
                  bookingListWheelScrollView(context,
                      listChildren: minutes,
                      itemChanged: (index) => {
                            selectedMin = minutes[index].data,
                          }),
                ])),
                //~ Buttons at the bottom of the scrollView
                confirmationButtons(context, checkButtonClicked: () {
                  setTimeStrings(timeType, selectedHour, selectedMin);
                  Navigator.of(context).pop();
                }),
              ]));
        });
  }

  Widget bookingMakerType() {
    //~ Build Method for Discussion Room Booking
    if (type == BookingType.discussionRoom) {
      return BookingDiscussionRoom(
          userId, dateSelected, startTimeString, endTimeString);
    } else {
      //~ Build Method for Study Table Booking
      return BookingStudyTable(
          userId, dateSelected, startTimeString, endTimeString);
    }
  }

//? Used to change the widget displaying the booking type
  void selectBookingType(BookingType dropDownValue) {
    setState(() {
      (dropDownValue == BookingType.discussionRoom)
          ? type = BookingType.discussionRoom
          : type = BookingType.studyTable;
    });
  }

  //? Processes the value from the ListWheelScrollView and displays the time
  void setTimeStrings(
      String timeType, String selectedHour, String selectedMin) {
    //^ Check Initial Values
    if (selectedHour == "" || selectedHour == "Hour:") {
      selectedHour = hours[1].data;
      endHour = (int.parse(selectedHour) + 1).toString();
    }
    if (selectedMin == "" || selectedMin == "Minutes:") {
      selectedMin = minutes[1].data;
      endMin = minutes[1].data;
    }

    //^ Upon selecting time
    if (timeType == "start") {
      startHour = selectedHour;
      startMin = selectedMin;
      endMin = selectedMin;
      endHour = (int.parse(selectedHour) + 1).toString();
    } else {
      endHour = selectedHour;
      endMin = selectedMin;
      if (endHour == startHour) {
        endHour = (int.parse(startHour) + 1).toString();
      }
    }

    //^ Validation check to prevent startHour from exceeding 19
    if (startHour == "20") {
      startHour = "19";
      endHour = "20";
    }

    setState(() {
      //^ Refreshes the display
      startTimeString = "$startHour:$startMin";
      endTimeString = "$endHour:$endMin";
    });
  }

  //? sets the hours for the Time picker
  List<Text> setTime(String timeType, int earliest, int latest, int maxHours) {
    List<String> hourList = [];
    List<Text> h = [Text("Hour:")];
    int hour = earliest;
    int i = 0;

    while (i < maxHours && hour < latest) {
      hourList.add(hour.toString());
      hour++;
      i++;
    }

    for (var item in hourList) {
      h.add(Text(item));
    }

    if (h.isEmpty) {
      h.add(Text("20"));
    }
    return hours = h;
  }

  int setStartHour() {
    String currentDate = parseDate(DateTime.now().toString());
    int minStartHour = 9;

    if (currentDate == dateSelected) {
      minStartHour = (TimeOfDay.now().hour + 1);
      if (minStartHour < 9) {
        minStartHour = 9;
      } else if (minStartHour > 19) {
        setState(() {
          var date = DateTime.now();
          date = date.add(Duration(days: 1));
          print(date.toString());
          dateSelected = parseDate(date.toString());
        });
        minStartHour = 9;
      }
    } else {
      minStartHour = minStartHour;
    }
    return minStartHour;
  }
}

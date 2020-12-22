import 'package:flutter/material.dart';
import 'package:librarix/Screens/booking_discussion_room.dart';
import 'package:librarix/modules.dart';
import '../Custom_Widget/booking_list_wheel_scroll_view.dart';
import '../Custom_Widget/user_id_field.dart';

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
    selectedHour = "9";
    selectedMin = "00";
    startTimeString = "Select a start time";
    endTimeString = "Select an end time";
    super.initState();
  }

  //^ Main build method
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        userIdField(userId),
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
                  value: BookingType.studyTable, child: Text("Study Table")),
            ],
            value: type,
            onChanged: (value) => selectBookingType(value),
          ),
        ),
        //~ Shared Booking Details
        TextButton(
          //~ Date picker
          onPressed: () async => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 6)))
              .then((date) => setState(() {
                    dateSelected = parseDate(date.toString());
                  })),
          child: Text("Select a date: $dateSelected"),
        ),
        SizedBox(
            //~ Start Time Picker
            width: MediaQuery.of(context).size.width / 1.5,
            child: FlatButton(
                color: Theme.of(context).accentColor,
                colorBrightness: Theme.of(context).accentColorBrightness,
                onPressed: () => timePicker("start", 9, 20, 11),
                child: Text("Start Time: $startTimeString"))),
        SizedBox(
            //~ End Time picker
            width: MediaQuery.of(context).size.width / 1.5,
            child: FlatButton(
                color: Theme.of(context).accentColor,
                colorBrightness: Theme.of(context).accentColorBrightness,
                onPressed: () =>
                    timePicker("end", (int.parse(startHour) + 1), 21, 4),
                child: Text("End Time: $endTimeString"))),
        //~ Specific Booking Type Details
        bookingMakerType(),
      ],
    ));
  }

  //? Start/End Time Picker
  timePicker(String timeType, int earliestTime, int latestTime, int maxHours) {
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
                listScrollButtons(context, checkButtonClicked: () {
                  setTimeStrings(timeType, selectedHour, selectedMin);
                }),
              ]));
        });
  }

  Widget bookingMakerType() {
    //~ Build Method for Discussion Room Booking
    if (type == BookingType.discussionRoom) {
      return BookingDiscussionRoom(type.toString(), userId, dateSelected,
          startTimeString, endTimeString);
    } else {
      //~ Build Method for Study Table Booking
      return Container(
        height: 50,
        color: Colors.red,
        child: Text("Study Table"),
      );
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
}

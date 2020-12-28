import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import '../../Models/discussion_room.dart';
import '../../Models/booking.dart';
import '../../Custom_Widget/booking_list_wheel_scroll_view.dart';
import '../../Custom_Widget/buttons.dart';
import '../../Custom_Widget/general_alert_dialog.dart';
import '../../modules.dart';

class BookingDiscussionRoom extends StatefulWidget {
  final ValueNotifier<String> userId;
  final String startTime, endTime, date;

  BookingDiscussionRoom(this.userId, this.date, this.startTime, this.endTime);
  @override
  _BookingDiscussionRoomState createState() => _BookingDiscussionRoomState();
}

class _BookingDiscussionRoomState extends State<BookingDiscussionRoom> {
  String selectedRoomSize, numPeople, selectedRoom, selectedDiscussionRoom;
  List<Text> roomSizes, discussionRoomsAvailable;
  ValueNotifier<bool> roomsFound;
  ValueNotifier<bool> detailsChange;
  String initialDate, initialStartTime, initialEndTime;

  @override
  void initState() {
    initialDate = widget.date;
    initialStartTime = widget.startTime;
    initialEndTime = widget.endTime;
    roomsFound = ValueNotifier<bool>(true);
    detailsChange = ValueNotifier<bool>(false);
    selectedRoomSize = "Select room size";
    selectedDiscussionRoom = "Select a room";
    numPeople = "";
    selectedRoom = "";
    roomSizes = [
      Text("Number of people:"),
      Text("3"),
      Text("4"),
      Text("6"),
      Text("8"),
    ];
    discussionRoomsAvailable = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //~ Select Room Size
      CustomOutlineButton(
        buttonText: "Room Size: $selectedRoomSize",
        onClick: () => discussionRoomSize(),
      ),
      //~ Select Room
      ValueListenableBuilder(
          valueListenable: detailsChange,
          builder: (BuildContext context, bool value, Widget child) {
            if (widget.startTime != initialStartTime ||
                widget.endTime != initialEndTime) {
              value = !value;
              selectedDiscussionRoom = "Select a room";
              initialStartTime = widget.startTime;
              initialEndTime = widget.endTime;
            }
            if (widget.date != initialDate) {
              value = !value;
              initialDate = widget.date;
              selectedDiscussionRoom = "Select a room";
            }
            return CustomOutlineButton(
              buttonText: "Discussion Room: $selectedDiscussionRoom",
              onClick: () => discussionRoomSelect(selectedRoomSize),
            );
          }),
      //~ Confirm and Create Booking
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
                    if (completeBookingDetails(roomsFound.value)) {
                      createBooking(createMyBooking(widget.userId));
                      generalAlertDialog(context,
                          title: "Booking",
                          content: "Booking successfully created!");
                    } else {
                      generalAlertDialog(context,
                          title: "Booking",
                          content: "Please fill in all booking details first!");
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
    ]);
  }

  //? Select Discussion Room size
  discussionRoomSize() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: (Column(children: [
                bookingListWheelScrollView(context,
                    listChildren: roomSizes,
                    itemChanged: (index) => numPeople = roomSizes[index].data),
                confirmationButtons(context,
                    checkButtonClicked: () => setState(() {
                          selectedDiscussionRoom = "Select a room";
                          (numPeople == "" || numPeople == "Number of people:")
                              ? selectedRoomSize = "3"
                              : selectedRoomSize = numPeople;
                        })),
              ])));
        });
  }

  //? Select a Discussion Room
  discussionRoomSelect(String selectedRoomSize) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: FutureBuilder<List<Text>>(
                  future: getRoomsAvailable(widget.date),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Text>> roomList) {
                    if (roomList.hasData) {
                      (roomList.data[0].data ==
                              "Sorry, there are no available rooms right now")
                          ? roomsFound.value = false
                          : roomsFound.value = true;

                      return Column(children: [
                        bookingListWheelScrollView(context,
                            listChildren: roomList.data,
                            itemChanged: (index) =>
                                selectedRoom = roomList.data[index].data),
                        confirmationButtons(context,
                            checkButtonClicked: () => setState(() {
                                  (selectedRoom == "")
                                      ? selectedDiscussionRoom =
                                          roomList.data[0].data
                                      : selectedDiscussionRoom = selectedRoom;
                                })),
                      ]);
                    }
                    return SpinKitWave(
                      color: Theme.of(context).accentColor,
                    );
                  }));
        });
  }

  //? Queries bookings, compares with rooms and returns list of available rooms
  Future<List<Text>> getRoomsAvailable(String date) async {
    String startTime = (widget.startTime.split(":").join("")),
        endTime = (widget.endTime.split(":").join(""));
    List<Text> rooms = [];
    List<String> listOfRoomsInUse = [];

    //^  list of all bookings on a given date
    List<Booking> allBookings = await getBookingsOf("BookingDate", date);

    //^ list of discussion rooms of selected size
    var roomsOfSize = await getRoomsOfSize(int.parse(selectedRoomSize));

    //^ list of active/ongoing discussion room bookings on a given date
    List<Booking> clashingBookings = allBookings
        .where((booking) =>
            booking.bookingStatus != "Cancelled" &&
            booking.bookingType == "Discussion Room")
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
      for (var room in roomsOfSize) {
        rooms.add(Text(room.roomNum));
      }
    } else {
      //^ process roomsOfSize and remove rooms that are booked
      //~ add to a list, the rooms that are in use
      for (var booking in clashingBookings) {
        listOfRoomsInUse.add(booking.roomOrTableNum);
      }
      //~ remove from (all) room list, rooms that are in use
      for (var roomInUse in listOfRoomsInUse) {
        roomsOfSize.removeWhere((room) => room.roomNum == roomInUse.toString());
        roomsOfSize.join(",");
      }
      //~ return list of available rooms
      for (var room in roomsOfSize) {
        rooms.add(Text(room.roomNum));
      }

      //~ if therea are no rooms available at all
      (rooms.length == 0)
          ? rooms.add(Text("Sorry, there are no available rooms right now"))
          : rooms = rooms;
    }
    return rooms;
  }

  //? Queries bookings if the user has any active bookings
  Future<bool> getUserBookings(ValueNotifier userId) async {
    String uid = userId.value;
    List<Booking> userBookings = await getBookingsOf("UserId", uid);
    var existingBooking = userBookings.where((details) =>
        details.bookingStatus == "Active" &&
        details.bookingType == "Discussion Room");
    return existingBooking.isEmpty;
  }

  //? Creates a Booking object based on entered details
  Booking createMyBooking(ValueNotifier userId) {
    String bookingDate = widget.date,
        bookingEndTime = widget.endTime,
        bookingStartTime = widget.startTime,
        bookingType = "Discussion Room",
        uid = userId.value,
        roomOrTableNum = selectedDiscussionRoom;

    Booking myBooking = Booking(bookingDate, bookingEndTime, bookingStartTime,
        "Active", bookingType, roomOrTableNum, uid);

    return myBooking;
  }

//? Checks if all booking details have been filled
  bool completeBookingDetails(bool roomsFound) {
    String bookingStartTime = widget.startTime,
        bookingEndTime = widget.endTime,
        roomOrTableNum = selectedDiscussionRoom;

    return (bookingStartTime == "Select a start time" ||
            bookingEndTime == "Select an end time" ||
            roomOrTableNum == "Select a room" ||
            roomsFound == false)
        ? false
        : true;
  }
}

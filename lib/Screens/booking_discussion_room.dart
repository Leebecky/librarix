import 'package:flutter/material.dart';
import 'package:librarix/loader.dart';
import '../Models/discussion_room.dart';
import '../Models/booking.dart';
import '../Custom_Widget/booking_list_wheel_scroll_view.dart';
import '../Custom_Widget/buttons.dart';
import '../Custom_Widget/general_alert_dialog.dart';
import '../modules.dart';

//TODO Booking query, return only available rooms
//TODO no bookings allowed when active bookings exist
//TODO lock discussion room/endtime buttons when no data
//TODO ban incomplete booking creation (disable button until all fields are filled)

class BookingDiscussionRoom extends StatefulWidget {
  final ValueNotifier<String> userId;
  final String startTime, endTime, date, bookingType;

  BookingDiscussionRoom(
      this.bookingType, this.userId, this.date, this.startTime, this.endTime);
  @override
  _BookingDiscussionRoomState createState() => _BookingDiscussionRoomState();
}

class _BookingDiscussionRoomState extends State<BookingDiscussionRoom> {
  String selectedRoomSize, numPeople, selectedRoom, selectedDiscussionRoom;
  List<Text> roomSizes, discussionRoomsAvailable;

  @override
  void initState() {
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
      CustomOutlineButton(
        buttonText: "Discussion Room: $selectedDiscussionRoom",
        onClick: () => discussionRoomSelect(selectedRoomSize),
      ),
      //~ Confirm and Create Booking
      CustomFlatButton(
          roundBorder: true,
          buttonText: "Confirm Booking",
          onClick: () async {
            if (await validUser(widget.userId.value)) {
              //~ User Id is Valid
              if (await getUserBookings(widget.userId))
              //~ Check if User has active bookings
              {
                createBooking(createMyBooking(widget.userId));
                showDialog(
                    context: context,
                    child: generalAlertDialog(context,
                        title: "Booking",
                        content: "Booking successfully created!"));
              } else {
                showDialog(
                    context: context,
                    child: generalAlertDialog(context,
                        title: "Active Booking Found",
                        content:
                            "Please clear your current booking before making another one!"));
              }
            } else {
              //~ UserId is invalid
              showDialog(
                  context: context,
                  child: generalAlertDialog(context,
                      title: "Invalid User",
                      content: "No user with this ID has been found!"));
            }
          })
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
                listScrollButtons(context,
                    checkButtonClicked: () => setState(() {
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
        builder: (BuildContext contetx) {
          return FutureBuilder<List<Text>>(
              future: findDiscussionRoom(int.parse(selectedRoomSize)),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Text>> roomList) {
                if (roomList.hasData) {
                  return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: (Column(children: [
                        bookingListWheelScrollView(context,
                            listChildren: roomList.data,
                            itemChanged: (index) =>
                                selectedRoom = roomList.data[index].data),
                        listScrollButtons(context,
                            checkButtonClicked: () => setState(() {
                                  (selectedRoom == "")
                                      ? selectedDiscussionRoom =
                                          roomList.data[0].data
                                      : selectedDiscussionRoom = selectedRoom;
                                })),
                      ])));
                }
                return Loader();
              });
        });
  }

  //? Returns available discussion rooms that fits the requested criteria
  Future<List<Text>> findDiscussionRoom(int size) async {
    List<Text> rooms = [];
    var allRoomsOfSize = await getRoomsOfSize(size);

    if (allRoomsOfSize.isNotEmpty) {
      for (var room in allRoomsOfSize) {
        rooms.add(Text(room.roomNum));
      }
    } else {
      rooms.add(Text("Sorry, there are no rooms available at this time."));
    }
    print(rooms[0].data);
    return rooms;
  }

  //? Queries bookings made on the selected date
  Future getDatedBookings(String date) async {
    List<Booking> allBookings = await getBookingsOf("BookingDate", date);
  }

  //? Queries bookings if the user has any active bookings
  Future<bool> getUserBookings(ValueNotifier userId) async {
    String uid = userId.value;
    List<Booking> userBookings = await getBookingsOf("UserId", uid);
    var existingBooking =
        userBookings.where((details) => details.bookingStatus == "Active");
    return existingBooking.isEmpty;
  }

  //? Creates a Booking object based on entered details
  Booking createMyBooking(ValueNotifier userId) {
    String bookingDate = widget.date,
        bookingEndTime = widget.endTime,
        bookingStartTime = widget.startTime,
        bookingType,
        uid = userId.value,
        roomOrTableNum = selectedDiscussionRoom;

    (widget.bookingType == "0")
        ? bookingType = "Discussion Room"
        : bookingType = "Study Table";

    Booking myBooking = Booking(bookingDate, bookingEndTime, bookingStartTime,
        "Active", bookingType, roomOrTableNum, uid);

    return myBooking;
  }
}

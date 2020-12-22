import 'package:flutter/material.dart';
import 'package:librarix/loader.dart';
import '../Models/discussion_room.dart';
import '../Models/booking.dart';
import '../Custom_Widget/booking_list_wheel_scroll_view.dart';

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
    selectedRoomSize = "Select Room Size";
    selectedDiscussionRoom = "Select a discussion room";
    numPeople = "";
    roomSizes = [
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
    return Column(
      children: [
        //~ Select Room Size
        Padding(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text("Room Size:")),
              FlatButton(
                color: Theme.of(context).accentColor,
                colorBrightness: Theme.of(context).accentColorBrightness,
                child: Text(selectedRoomSize),
                onPressed: () => discussionRoomSize(),
              ),
            ])),
        //~ Select Room
        Row(children: [
          Text("Discussion Room:"),
          FlatButton(
            color: Theme.of(context).accentColor,
            colorBrightness: Theme.of(context).accentColorBrightness,
            child: Text("Discussion Room: $selectedDiscussionRoom"),
            onPressed: () => discussionRoomSelect(selectedRoomSize),
          ),
        ]),
        //~ Confirm and Create Booking
        FlatButton(
          color: Theme.of(context).accentColor,
          colorBrightness: Theme.of(context).accentColorBrightness,
          child: Text("Confirm Booking"),
          onPressed: () => createBooking(createMyBooking(widget.userId)),
        )
      ],
    );
  }

  //? Select Discussion Room size
  discussionRoomSize() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: (Column(
              children: [
                bookingListWheelScrollView(context,
                    listChildren: roomSizes,
                    itemChanged: (index) => numPeople = roomSizes[index].data),
                listScrollButtons(context,
                    checkButtonClicked: () => setState(() {
                          (numPeople == "")
                              ? selectedRoomSize = "3"
                              : selectedRoomSize = numPeople;
                        })),
              ],
            )),
          );
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
                                  selectedDiscussionRoom = selectedRoom;
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

  //? Creates a Booking object based on entered details
  Booking createMyBooking(ValueNotifier userId) {
    String bookingDate = widget.date;
    String bookingEndTime = widget.endTime;
    String bookingStartTime = widget.startTime;
    String bookingType = widget.bookingType;
    String uid = userId.value;
    String roomOrTableNum = selectedDiscussionRoom;

    Booking myBooking = Booking(bookingDate, bookingEndTime, bookingStartTime,
        "Active", bookingType, roomOrTableNum, uid);

    return myBooking;
  }
}

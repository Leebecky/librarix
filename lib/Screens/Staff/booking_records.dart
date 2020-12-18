import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:librarix/Models/booking.dart';

class BookingRecords extends StatelessWidget {
  List<DiscussionRoomBooking> myDiscussionRoomBooking = [];
  List<StudyTableBooking> myStudyTableBooking = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Record"),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
            future: getDiscussionRoomBooking(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null) {
                return Center(child: Text("Loading ... "));
              } else {
                snapshot.data.docs.forEach((doc) {
                  myDiscussionRoomBooking
                      .add(discussionRoomBookingFromJson(doc.data()));
                });
                return ListView.builder(
                  itemCount: myDiscussionRoomBooking.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(Icons.meeting_room),
                      title: Text(myDiscussionRoomBooking[index].roomNum),
                      subtitle: Text(myDiscussionRoomBooking[index].userId),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

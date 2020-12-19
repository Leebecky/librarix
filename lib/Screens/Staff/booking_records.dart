import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Models/booking.dart';

class BookingRecords extends StatelessWidget {
  List<Booking> myBooking = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Record"),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
            future: getBooking(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null) {
                return Center(child: Text("Loading ... "));
              } else {
                snapshot.data.docs.forEach((doc) {
                  myBooking.add(bookingFromJson(doc.data()));
                });
                return ListView.builder(
                  itemCount: myBooking.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(Icons.meeting_room),
                      title: Text(myBooking[index].roomOrTableNum),
                      subtitle: Text(myBooking[index].userId),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

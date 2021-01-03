import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../Models/notifications.dart';
import 'package:librarix/modules.dart';

//TODO sort by date / unread
class NotificationsDisplay extends StatefulWidget {
  @override
  _NotificationsDisplayState createState() => _NotificationsDisplayState();
}

class _NotificationsDisplayState extends State<NotificationsDisplay> {
  Stream<QuerySnapshot> database;
  CollectionReference notificationDb = FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Notifications");
  CollectionReference staffNotificationDb =
      FirebaseFirestore.instance.collection("StaffNotifications");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: FutureBuilder(
          future: getDbType(),
          builder: (BuildContext context, AsyncSnapshot dbType) {
            if (dbType.hasData) {
              return StreamBuilder<QuerySnapshot>(
                stream: database,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<Notifications> notificationsList = [];
                    snapshot.data.docs.forEach((notif) {
                      notificationsList
                          .add(notificationsFromJson(notif.data()));
                    });
                    notificationsList.removeWhere((notif) =>
                        parseStringToDate(notif.displayDate)
                            .isAfter(DateTime.now()));
                    notificationsList.join(",");

                    if (notificationsList.isNotEmpty) {
                      return ListView.builder(
                        itemCount: notificationsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: setIcon(notificationsList[index].type),
                            title: Text(notificationsList[index].title),
                            subtitle: Text(notificationsList[index].content),
                          );
                        },
                      );
                    } else if (notificationsList.isEmpty) {
                      return Center(child: Text("No notifications found"));
                    }
                  }
                  return SpinKitWave(color: Theme.of(context).accentColor);
                },
              );
            }
            return LinearProgressIndicator();
          }),
    );
  }

//? Sets the icon to be displayed depending on the notification category
  Widget setIcon(String type) {
    Widget icon;
    switch (type) {
      case "Discussion Room":
        icon = Icon(Icons.meeting_room);
        break;
      case "Study Table":
        icon = Icon(Icons.self_improvement);
        break;
      case "Book Return":
      case "Book Reservation":
        icon = Icon(Icons.auto_stories);
        break;
      case "Fines":
        icon = Icon(Icons.monetization_on_rounded);
        break;
      default:
    }
    return icon;
  }

  Future getDbType() async {
    bool staff = await isStaff();

    return (staff)
        ? database = staffNotificationDb.snapshots()
        : database = notificationDb.snapshots();
  }
}

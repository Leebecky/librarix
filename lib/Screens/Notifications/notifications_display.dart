import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Screens/Notifications/notifications_build.dart';
import 'package:librarix/modules.dart';
import '../../Models/notifications.dart';

//TODO book return notifications needs to be saved => test if staff receives notifications
//TODO test notification scheduling/cancelling for return book and bookings
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
        actions: [
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () async => {
                    // cancelNotification(1),
                    checkPendingNotificationRequests(context),
                  })
        ],
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
                    //^  Processing notifications to only display those that have been deployed
                    List<Notifications> allNotifications = [],
                        notificationsList = [];
                    List<String> notificationId = [];
                    snapshot.data.docs.forEach((notif) {
                      allNotifications.add(notificationsFromJson(notif.data()));
                      notificationId.add(notif.id);
                    });

                    for (var i = 0; i < allNotifications.length; i++) {
                      notificationsList.add(Notifications(
                          allNotifications[i].addtionalDetail,
                          allNotifications[i].content,
                          allNotifications[i].displayDate,
                          allNotifications[i].read,
                          allNotifications[i].title,
                          allNotifications[i].type,
                          notificationId[i]));
                    }

                    notificationsList.removeWhere((notif) =>
                        parseStringToDate(notif.displayDate)
                            .isAfter(DateTime.now()));
                    notificationsList.join(",");
                    notificationsList.sort((a, b) {
                      DateTime aDate = parseStringToDate(a.displayDate);
                      DateTime bDate = parseStringToDate(b.displayDate);
                      return aDate.compareTo(bDate);
                    });

                    //^ Notifications Display List
                    if (notificationsList.isNotEmpty) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        itemCount: notificationsList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: (notificationsList[index].read)
                                        ? Theme.of(context).highlightColor
                                        : Theme.of(context).accentColor)),
                            child: ListTile(
                                leading: setIcon(notificationsList[index].type),
                                title: Text(notificationsList[index].title),
                                subtitle:
                                    Text(notificationsList[index].content),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20,
                                  ),
                                  alignment: Alignment.bottomRight,
                                  onPressed: () async => deleteNotification(
                                      docId: notificationsList[index].id),
                                ),
                                onTap: () async => await updateNotification(
                                      docId: notificationsList[index].id,
                                      updateAttribute: "NotificationRead",
                                      updateItem: true,
                                    )),
                          );
                        },
                      );
                      //~ User has no notifications
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

//? Determines which notification list to display from
  Future getDbType() async {
    bool staff = await isStaff();

    return (staff)
        ? database = staffNotificationDb.snapshots()
        : database = notificationDb.snapshots();
  }
}

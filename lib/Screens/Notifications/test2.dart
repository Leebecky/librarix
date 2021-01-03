// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:librarix/Custom_Widget/buttons.dart';
import 'package:librarix/Screens/Notifications/local_notifications_initializer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//? Testing for Book return due notifications
class BookReturnNotification extends StatefulWidget {
  final String payload;
  BookReturnNotification({this.payload = "Placeholder"});
  @override
  _BookReturnNotificationState createState() => _BookReturnNotificationState();
}

class _BookReturnNotificationState extends State<BookReturnNotification> {
  String token;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    token = "";
    getToken();
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        });
    basicNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing Notifications"),
      ),
      body: Column(
        children: [
          CustomFlatButton(
            buttonText: "Basic Notification",
            onClick: () => basicNotification(),
          ),
          ListTile(
            leading: Icon(Icons.my_library_books),
            title: Text("Book Due!"),
            subtitle: Text(widget.payload),
          )
        ],
      ),
    );
  }

  void getToken() async {
    token = await firebaseMessaging.getToken();
    print(token);
  }

  Future basicNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            "CHANNEL_ID", "CHANNEL_NAME", "CHANNEL_DESCRIPTION",
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, "title", "body", platformChannelSpecifics, payload: "Payload");
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }
}

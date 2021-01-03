import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:librarix/Screens/Notifications/notifications_build.dart';
import 'package:librarix/Screens/Notifications/test2.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

//? Initializes local_notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
initializePlatformSpecifics() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/launcher_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

//? Response to be taken when local_notification is clicked
Future selectNotification(String payload) async {
  if (payload != null) {
    print('notification payload: $payload');
  }
  await Get.off(BookReturnNotification(payload: payload));
}

//? Intialize local timezone used for scheduling notifications
initialiseTimeZones() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(
      tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
}

//? Obtains the unique device token and saves as subcollection under User.
//? Used for sending push notifications to specific devices
saveDeviceToken() async {
  String userId = FirebaseAuth.instance.currentUser.uid,
      deviceToken = await FirebaseMessaging().getToken();

  if (deviceToken != null) {
    var tokens = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Tokens")
        .doc(deviceToken);

    await tokens.set({"Token": deviceToken});
  }
  print("Token set: $deviceToken");
}

//? Automatcally subscribes all library staff to the following topics for push notifications
//TODO enable manual/unsubscribe in notification settings
staffTopicSubscription() {
  FirebaseMessaging().subscribeToTopic("Fines");
  FirebaseMessaging().subscribeToTopic("Booking");
  FirebaseMessaging().subscribeToTopic("BookReservation");
  print("Topics successfully subscribed");
}

fcmConfiguration() {
  FirebaseMessaging().configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // await standardNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // await standardNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // await standardNotification(message);
      });
}

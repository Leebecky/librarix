import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:librarix/Screens/Notifications/notifications_display.dart';

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
  Get.off(NotificationsDisplay());
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

//?// Configuration for FCM messages
/* fcmConfiguration() {
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
} */

//? Handles incoming notifications when application is open
/* Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
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
 */

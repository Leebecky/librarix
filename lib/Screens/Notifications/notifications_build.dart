import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:librarix/Screens/Notifications/local_notifications_initializer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//TODO respond to incoming notifications when app is open

//~ Notification id : 1 - Booking on Day

//? Schedule Notification for bookings (on day of booking)
bookingNotificationOnDay(
    String tableRoomNumber, String startTime, String endTime) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Booking Today',
      '$tableRoomNumber has been booked from $startTime - $endTime today.',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails('Booking Channel Id',
              'Booking Channel', 'Booking Channel Notifications')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

Future standardNotification(Map<String, dynamic> message) async {
  String title = message["notification"]["title"];
  String body = message["notification"]["body"];

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails("Misc Id", "Misc", "Miscellaneous",
          importance: Importance.max, priority: Priority.max, showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: "payload");
}

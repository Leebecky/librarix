import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:librarix/Screens/Notifications/local_notifications_initializer.dart';
import 'package:librarix/modules.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//~ Notification id : 1 - Booking on Day - Discussion Room
//~ Notification id : 2 - Booking 15 minutes - Discussion Room
//~ Notification id : 3 - Booking on Day - Study Table
//~ Notification id : 4 - Booking 15 minutes - Study Table
//~ Notification id : (bookingId) - Book Return on day

//? Schedule Notification for bookings (on day of booking)
bookingNotificationOnDay({
  String bookingType,
  String tableRoomNumber,
  String startTime,
  String endTime,
  String bookingDate,
}) async {
  DateTime scheduledDate = parseStringToDate(bookingDate);
  int _notificationId;
  (bookingType == "Discussion Room")
      ? _notificationId = 1
      : _notificationId = 3;

  await flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationId,
      'Booking Today',
      '$tableRoomNumber has been booked from $startTime - $endTime on $bookingDate.',
      tz.TZDateTime.local(
          scheduledDate.year, scheduledDate.month, scheduledDate.day, 8),
      const NotificationDetails(
          android: AndroidNotificationDetails('Booking Channel Id',
              'Booking Channel', 'Booking Channel Notifications')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

//? Schedules notification 15 minutes before booking start time
bookingNotificationBeforeStartTime({
  String bookingType,
  String tableRoomNumber,
  String startTime,
  String endTime,
  String bookingDate,
}) async {
  DateTime scheduledDate = parseStringToDate(bookingDate);
  List<String> timeBefore = startTime.split(":").toList();
  String minBefore = timeBefore[1];
  int hour, min;
  if (minBefore == "00") {
    hour = (int.parse(timeBefore[0]) - 1);
    min = (45);
  }

  int _notificationId;
  (bookingType == "Discussion Room")
      ? _notificationId = 2
      : _notificationId = 4;

  await flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationId,
      'Booking Starting in 15 Minutes',
      '$tableRoomNumber has been booked from $startTime - $endTime on $bookingDate.',
      tz.TZDateTime.local(scheduledDate.year, scheduledDate.month,
          scheduledDate.day, hour, min),
      const NotificationDetails(
          android: AndroidNotificationDetails('Booking Channel Id',
              'Booking Channel', 'Booking Channel Notifications')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

//? Deploys standard notification banner
Future standardNotification(Map<String, dynamic> message) async {
  String title = message["Title"];
  String body = message["Body"];
  String payload = message["Payload"];
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails("Misc Id", "Misc", "Miscellaneous",
          importance: Importance.max, priority: Priority.max, showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: payload);
}

//? Return Book Notification
bookReturnNotification({
  String returnDate,
  String title,
  int notificationId,
}) async {
  DateTime scheduledDate;
  scheduledDate = parseStringToDate(returnDate);

  await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Book Return',
      '$title is due to be returned on $returnDate',
      tz.TZDateTime.local(
          scheduledDate.year, scheduledDate.month, scheduledDate.day, 9),
      const NotificationDetails(
          android: AndroidNotificationDetails('Booking Channel Id',
              'Booking Channel', 'Booking Channel Notifications')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

//?Cancel selected notification
Future<void> cancelNotification(int notificationId) async {
  await flutterLocalNotificationsPlugin.cancel(notificationId);
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:librarix/Screens/Notifications/notifications_display.dart';
import '../Report_Generator/pdf_viewer_page.dart';

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
    return Get.to(PdfViewerPage(path: payload));
  }
  Get.off(NotificationsDisplay());
}

//? Intialize local timezone used for scheduling notifications
initialiseTimeZones() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(
      tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
}

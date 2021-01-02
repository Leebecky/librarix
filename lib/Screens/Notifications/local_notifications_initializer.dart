import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:librarix/Screens/Notifications/test2.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
initializePlatformSpecifics() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/launcher_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

Future selectNotification(String payload) async {
  if (payload != null) {
    print('notification payload: $payload');
  }
  await Get.off(BookReturnNotification(payload: payload));
}

/* initialiseTimeZones() {
  tz.initializeTimeZones();

  tz.setLocalLocation(tz.getLocation("Malaysia"));
} */

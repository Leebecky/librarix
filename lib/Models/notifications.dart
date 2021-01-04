import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Models/user.dart';
import 'package:librarix/modules.dart';

class Notifications {
  String content, displayDate, title, type, id, addtionalDetail;
  bool read;

  Notifications(this.addtionalDetail, this.content, this.displayDate, this.read,
      this.title, this.type,
      [this.id]);

  Map<String, String> toJson() => _notificationsToJson(this);
}

//? Converts map of values from Firestore into Notifications object.
Notifications notificationsFromJson(Map<String, dynamic> json) {
  return Notifications(
    json["NotificationAdditionalDetail"] as String,
    json["NotificationContent"] as String,
    json["NotificationDisplayDate"] as String,
    json["NotificationRead"] as bool,
    json["NotificationTitle"] as String,
    json["NotificationType"] as String,
  );
}

//? Converts the Notifications class into key/value pairs
Map<String, dynamic> _notificationsToJson(Notifications instance) =>
    <String, dynamic>{
      "NotificationAdditionalDetail": instance.addtionalDetail,
      "NotificationContent": instance.content,
      "NotificationDisplayDate": instance.displayDate,
      "NotificationRead": instance.read,
      "NotificationTitle": instance.title,
      "NotificationType": instance.type,
    };

Notifications createInstance(
    {String details,
    String content,
    String displayDate,
    String title,
    String type}) {
  return Notifications(details, content, displayDate, false, title, type);
}

Future saveNotification(Notifications notificationInstance) async {
  await FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Notifications")
      .add(_notificationsToJson(notificationInstance));
}

//? Updates notification
Future<void> updateNotification(
    {String docId,
    String userId,
    dynamic updateItem,
    String updateAttribute}) async {
  (userId == null)
      ? userId = FirebaseAuth.instance.currentUser.uid
      : userId = await findUser("UserId", userId);

  (await isStaff())
      ? await FirebaseFirestore.instance
          .collection("StaffNotifications")
          .doc(docId)
          .update({updateAttribute: updateItem})
      : await FirebaseFirestore.instance
          .collection("User")
          .doc(userId)
          .collection("Notifications")
          .doc(docId)
          .update({updateAttribute: updateItem});
}

Future<List<Notifications>> searchNotification(
    String userId, String queryField, String queryItem) async {
  String uid = await findUser("UserId", userId);
  List<Notifications> allNotifications = [], notificationsList = [];
  List<String> notificationId = [];

  await FirebaseFirestore.instance
      .collection("User")
      .doc(uid)
      .collection("Notifications")
      .where(queryField, isEqualTo: queryItem)
      .get()
      .then((value) => value.docs.forEach((doc) {
            allNotifications.add(notificationsFromJson(doc.data()));
            notificationId.add(doc.id);
          }));

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
  return notificationsList;
}

Future<void> updateBookReturnNotification({
  String userId,
  String bookId,
  String newDate,
}) async {
  List<Notifications> notificationsList =
      await searchNotification(userId, "NotificationAdditionalDetail", bookId);

  await updateNotification(
      docId: notificationsList[0].id,
      userId: userId,
      updateItem: newDate,
      updateAttribute: "NotificationDisplayDate");
}

//? For deleting notifications when requested by user/when bookings are cancelled/books are returned early
Future deleteNotification({
  BuildContext context,
  String userId,
  String docId,
  bool hasId = true,
  String queryItem,
}) async {
  List<Notifications> notifications = [];

  //^ Looks for docId of specfic User
  (userId == null)
      ? userId = FirebaseAuth.instance.currentUser.uid
      : userId = await findUser("UserId", userId);

//^ Looks for the notification docId if not provided
  if (hasId == false) {
    notifications = await searchNotification(
        userId, "NotificationAdditionalDetail", queryItem);
    docId = notifications[0].id;
  }

  //^ Checks user role for authorization of deleting notifications
  String currentRole;
  await FirebaseFirestore.instance
      .collection("User")
      .doc(userId)
      .collection("Login")
      .doc("LoginRole")
      .get()
      .then((value) => currentRole = value.data()["LoggedInAs"]);

//^ Delete Request
  if (currentRole == "Admin") {
    await FirebaseFirestore.instance
        .collection("StaffNotifications")
        .doc(docId)
        .delete();
  } else if (currentRole == "Librarian") {
    return customAlertDialog(context,
        title: "Unauthorized Action",
        content: "Sorry, you are not authorized to delete notifications");
  } else {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Notifications")
        .doc(docId)
        .delete();
  }
}

//TODO booking cancelled, delete notification
// TODO// book returned before notifications started

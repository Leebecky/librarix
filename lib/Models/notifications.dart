//TODO differentiate between read/unread notifications
class Notifications {
  String content, displayDate, title, type;
  bool read;

  Notifications(
      this.content, this.displayDate, this.read, this.title, this.type);

  Map<String, String> toJson() => _notificationsToJson(this);
}

//? Converts map of values from Firestore into Notifications object.
Notifications notificationsFromJson(Map<String, dynamic> json) {
  return Notifications(
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
      "NotificationContent": instance.content,
      "NotificationDisplayDate": instance.displayDate,
      "NotificationRead": instance.read,
      "NotificationTitle": instance.title,
      "NotificationType": instance.type,
    };

Notifications createInstance(
    {String content, String displayDate, String title, String type}) {
  return Notifications(content, displayDate, false, title, type);
}

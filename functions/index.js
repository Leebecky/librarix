//? Import Cloud Functions SDK to create Cloud Functions and create triggers
const functions = require('firebase-functions');
//? Import the Firebase Admin SDK to access Cloud Firestore, FCM and Auth
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const fcm = admin.messaging();
const db = admin.firestore();
//TODO getDate return value is off by 1 day

//? Notify staff when new booking is made
exports.senddevices = functions.firestore
    .document("Booking/{id}")
    .onCreate((snapshot) => {
        const bookingUserId = snapshot.get("UserId");
        const bookingType = snapshot.get("BookingType");
        const bookingDate = snapsshot.get("BookingDate");
        const bookingStartTime = snapshot.get("BookingStartTime");
        const bookingEndTime = snapshot.get("BookingEndTime");
        const bookingNumber = snapshot.get("Room/TableNum");

        const bookingPayload = {
            notification: {
                title: bookingUserId + " booked " + bookingNumber,
                body: bookingDate + ": " + bookingStartTime + "-" + bookingEndTime,
                click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
        };
        return fcm.sendToTopic("Booking", bookingPayload);
    });

//? Notify staff/user when new fine is incurred
exports.sendTopicFines = functions
    .region("asia-southeast2")
    .firestore
    .document("Fines/{id}")
    .onCreate(async (snapshot) => {
        //^ Fines Notification for Staff
        const finesUserId = snapshot.get("UserId");
        const total = snapshot.get("FinesTotal");
        const dueDate = snapshot.get("FinesDue");
        const reason = snapshot.get("FinesReason");

        const staffPayload = {
            notification: {
                title: finesUserId + " has been fined for " + reason,
                body: "RM" + total + ", to be paid by " + dueDate,
                click_action : "FLUTTER_NOTIFICATION_CLICK",
            }
        };
        const userPayload = {
            notification: {
                title: "You has been fined for " + reason,
                body: "RM" + total + ", to be paid by " + dueDate,
                click_action : "FLUTTER_NOTIFICATION_CLICK"
            }
        };
        //^ Writes to the User's notification database
        var promises = [];
        var myUser;
        var myToken;
        var date = new Date();
        var day = date.getDate().toString();
        var month = (date.getMonth() + 1).toString();
        var year = date.getFullYear().toString();
        var dateString = day + "/" + month + "/" + year

        //^  Notification entry for database
        notificationData = {
            NotificationContent: "RM" + total + ", to be paid by " + dueDate,
            NotificationDisplayDate: dateString,
            NotificationRead: false,
            NotificationTitle: "Fines Incurred (" + reason + ")",
            NotificationType: "Fines"
        };
        staffNotificationData = {
            NotificationContent: "RM" + total + ", to be paid by " + dueDate + " for " + reason,
            NotificationDisplayDate: dateString,
            NotificationRead: false,
            NotificationTitle: finesUserId + " has been fined",
            NotificationType: "Fines",
        };

        //? Looks for docId of the User based on UserId given in Fines
        return db.collection("User").where("UserId", "==", finesUserId).get().then((snap) => {
            (snap.docs.forEach((doc) => {
                myUser = doc.id;
            }))
            //? Retrieves token for sending notification to the user
            return db.collection("User").doc(myUser).collection("Tokens").get().then((docs) => {
                docs.docs.forEach((doc) => myToken = doc.data());
                //? Adds a new entry to the notification database for user
                // return db.collection("User").doc(myUser).collection("Notifications").add(notificationData).then(() => {
                //^ Compiles the push notifications and sends them out
          //TODO test writing to staffNotifications      
                promises.push(db.collection("User").doc(myUser).collection("Notifications").add(notificationData));
                promises.push(db.collection("StaffNotifications").add(staffNotificationData));
                promises.push(fcm.sendToTopic("Fines", staffPayload));
                promises.push(fcm.sendToDevice(myToken.Token, userPayload));
                return Promise.all(promises).catch((onerror) => console.log(onerror));
            })
        })
    })

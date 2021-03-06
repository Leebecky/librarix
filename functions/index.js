//? Import Cloud Functions SDK to create Cloud Functions and create triggers
const functions = require('firebase-functions');
//? Import the Firebase Admin SDK to access Cloud Firestore, FCM and Auth
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const fcm = admin.messaging();
const db = admin.firestore();
//TODO getDate return value is off by 1 day
var date = new Date();
var day = date.getDate().toString();
var month = (date.getMonth() + 1).toString();
var year = date.getFullYear().toString();
var dateString = day + "/" + month + "/" + year

//? Notify staff when new booking is made
exports.sendTopicBookings = functions
    .region("asia-southeast2")
    .firestore
    .document("Booking/{id}")
    .onCreate((snapshot) => {
        const bookingId = snapshot.id;
        const bookingUserId = snapshot.get("UserId");
        const bookingType = snapshot.get("BookingType");
        const bookingDate = snapshot.get("BookingDate");
        const bookingStartTime = snapshot.get("BookingStartTime");
        const bookingEndTime = snapshot.get("BookingEndTime");
        const bookingNumber = snapshot.get("RoomOrTableNum");
        const notificationContent = "Date: " + bookingDate + " - " + bookingStartTime + " - " + bookingEndTime;
        var myUser = "";
        var promises = [];
        const bookingPayload = {
            notification: {
                title: bookingUserId + " booked " + bookingNumber,
                body: notificationContent,
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                data:{
                    title: bookingUserId + " booked " + bookingNumber,
                    body: notificationContent,
                    type: "Staff Notification"
                }
            },
        };

        const staffBookingNotificationData = {
            NotificationContent: bookingDate + " (" + bookingStartTime + "-" + bookingEndTime + ")",
            NotificationDisplayDate: dateString,
            NotificationRead: false,
            NotificationTitle: bookingUserId + " booked " + bookingNumber,
            NotificationType: bookingType
        }

        const bookingNotificationData = {
            NotificationAdditionalDetail : bookingId,
            NotificationContent: "Booking for " + bookingNumber + " at " + bookingStartTime + " today!",
            NotificationDisplayDate: bookingDate,
            NotificationRead: false,
            NotificationTitle: "Booking Reminder",
            NotificationType: bookingType
        }

        return db.collection("User").where("UserId", "==", bookingUserId).get().then((snap) => {
            (snap.docs.forEach((doc) => {
                myUser = doc.id; }))

            promises.push(db.collection("User").doc(myUser).collection("Notifications").add(bookingNotificationData));
            promises.push(db.collection("StaffNotifications").add(staffBookingNotificationData));
            promises.push(fcm.sendToTopic("Booking", bookingPayload));
            return Promise.all(promises).catch((onerror) => console.log(onerror));
        });
    })

//? Notify staff/user when new fine is incurred
exports.sendTopicFines = functions
    .region("asia-southeast2")
    .firestore
    .document("Fines/{id}")
    .onCreate(async (snapshot) => {
        //^ Fines Notification for Staff
        const finesId = snapshot.id;
        const finesUserId = snapshot.get("UserId");
        const total = snapshot.get("FinesTotal");
        const issueDate = snapshot.get("FinesIssueDate");
        const reason = snapshot.get("FinesReason");
        const notificationContent = "RM" + total + ", to be paid by " + issueDate;

        const staffFinesPayload = {
            notification: {
                title: finesUserId + " has been fined for " + reason,
                body: notificationContent,
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                data:{
                    title: finesUserId + " has been fined for " + reason,
                    body: notificationContent,
                    type: "Staff Notification"
                }
            }
        };
        const userFinesPayload = {
            notification: {
                title: "You has been fined for " + reason,
                body: notificationContent,
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                data:{
                    title: "You has been fined for " + reason,
                    body: notificationContent,
                    type: "User Notification"
                }
            }
        };
        //^ Writes to the User's notification database
        var promises = [];
        var myUser;
        var myToken;

        //^  Notification entry for database
        finesNotificationData = {
            NotificationAdditionalDetail: finesId,
            NotificationContent: "RM" + total + ", to be paid by " + issueDate,
            NotificationDisplayDate: dateString,
            NotificationRead: false,
            NotificationTitle: "Fines Incurred (" + reason + ")",
            NotificationType: "Fines"
        };
        staffFinesNotificationData = {
            NotificationContent: "RM" + total + ", to be paid by " + issueDate + " for " + reason,
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
                //^ Compiles the push notifications and sends them out
                promises.push(db.collection("User").doc(myUser).collection("Notifications").add(finesNotificationData));
                promises.push(db.collection("StaffNotifications").add(staffFinesNotificationData));
                promises.push(fcm.sendToTopic("Fines", staffFinesPayload));
                promises.push(fcm.sendToDevice(myToken.Token, userFinesPayload));
                return Promise.all(promises).catch((onerror) => console.log(onerror));
            })
        })
    })

//? Notify Staff when new book reservation is created
exports.sendTopicBookReservation = functions
    .region("asia-southeast2")
    .firestore
    .document("BorrowedBook/{id}")
    .onCreate((snapshot) => {
        const bookId = snapshot.get("BookId");
        const borrowUserId = snapshot.get("UserId");
        const borrowStatus = snapshot.get("BorrowStatus");
        const borrowBookTitle = snapshot.get("BookTitle");
        const notificationContent = borrowUserId + " reserved " + borrowBookTitle;
        var promises = [];
        if (borrowStatus === "Reserved") {
            const reservationPayload = {
                notification: {
                    title: "Book Reservation",
                    body: notificationContent,
                    click_action: "FLUTTER_NOTIFICATION_CLICK",
                    data:{
                        title: "Book Reservation",
                        body: notificationContent,
                        type: "Staff Notification"
                    },
                },
            };

            const bookingNotificationData = {
                NotificationAdditionalDetail: bookId,
                NotificationContent: borrowUserId + " reserved " + borrowBookTitle,
                NotificationDisplayDate: dateString,
                NotificationRead: false,
                NotificationTitle: "Book Reservation",
                NotificationType: "Book Reservation"
            }
            promises.push(db.collection("StaffNotifications").add(bookingNotificationData));
            promises.push(fcm.sendToTopic("BookReservation", reservationPayload));
            return Promise.all(promises).catch((onerror) => console.log(onerror));
        }
        else { print("Nothing happened"); return null; }
    });
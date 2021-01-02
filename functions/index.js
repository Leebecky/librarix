const functions = require('firebase-functions');
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const fcm = admin.messaging();

exports.senddevices = functions.firestore
    .document("Booking/{id}")
    .onCreate((snapshot) => {
        const userId = snapshot.get("UserId");
        const type = snapshot.get("BookingType");
        const token = snapshot.get("BookingToken");

        const payload = {
            notification: {
                title: "By " + userId,
                body: type + " booking, token: ",
            },
        };
        return fcm.sendToDevice(token, payload);
    });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

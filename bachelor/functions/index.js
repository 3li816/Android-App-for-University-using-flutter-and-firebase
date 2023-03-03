const functions = require("firebase-functions");
const admin= require("firebase-admin");
admin.initializeApp();
exports.myFunction = functions.firestore
    .document("assessments/{assessments}")
    .onCreate((snapshot, context) => {
      let path="";
      const course=snapshot.data().courseName;
      path = course.replaceAll(" ", "");
      console.log(path);
      return admin.messaging().sendToTopic(path, {
        notification: {
          title: snapshot.data().courseName,
          body: snapshot.data().bodyText,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });
exports.myFunctionAnnouncement = functions.firestore
    .document("announcements/{announcement}")
    .onCreate((snapshot, context) => {
      let path = "test";
      const course = snapshot.data().courseName;
      const group = snapshot.data().group;
      if (group == "All Groups") {
        path=course;
      } else {
        path = course + group;
      }
      path = path.replaceAll(" ", "");
      console.log(path);
      return admin.messaging().sendToTopic(path, {
        notification: {
          title: snapshot.data().title,
          body: snapshot.data().body,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });

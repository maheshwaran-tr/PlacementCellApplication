import fs from "fs";
import admin from "firebase-admin";
import { User } from "../models/user_models/userModel.js";


const serviceAccount = JSON.parse(
  fs.readFileSync("./config/push-notification-key.json", "utf8")
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// var FCM = new fcmNode(serviceAccount);

export const sendPushNotification = (req, res, next) => {
  try {
    let message = {
      notification: {
        title: "Test Notification",
        body: "message body",
      },
      token: req.body.fcmToken,
    };

    admin
      .messaging()
      .send(message)
      .then((response) => {
        return res.status(200).send({ message: "Notification Sent" });
      })
      .catch((err) => {
        console.log(err);
        return res.status(500).send({ message: err });
      });
  } catch (error) {
    console.log(error);
    throw error;
  }
};

export const sendNotificationsToDept = async (req, res, next) => {
  try {
    const { title, body, allowedDepartments } = req.body;
    // List of departments to receive notifications

    // Find users who are students in the specified departments and have a non-null fcmToken
    const studentsInAllowedDepartments = await User.aggregate([
      {
        $lookup: {
          from: "students",
          localField: "roleId",
          foreignField: "_id",
          as: "studentDetails",
        },
      },
      { $match: { "studentDetails.department": { $in: allowedDepartments } } },
      { $project: { _id: 0, fcmToken: 1 } }, // Project only the fcmToken field
      { $match: { fcmToken: { $ne: null } } } // Ensure fcmToken is not null
    ]);

    if (studentsInAllowedDepartments.length === 0) {
      return res.status(404).send({
        message: "No students in the specified departments with valid fcmTokens found.",
      });
    }

    // Prepare the message payload
    const message = {
      notification: {
        title: title,
        body: body,
      },
    };

    // Send notifications to all students in the specified departments with valid fcmTokens
    const promises = studentsInAllowedDepartments.map((student) => {
      const payload = {
        token: student.fcmToken,
        ...message,
      };
      return admin.messaging().send(payload);
    });

    // Wait for all promises to resolve
    await Promise.all(promises);

    return res.status(200).send({
      message: "Notifications sent to students in the specified departments with valid fcmTokens.",
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send({ message: error.message });
  }
};

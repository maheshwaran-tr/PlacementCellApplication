import { sendPushNotification } from "../controllers/pushNotificationController.js";
import express from 'express';

const router = express.Router();

router.post("/",sendPushNotification);

export default router;

import express from 'express'
import { getUserById, updateFcmToken } from '../../controllers/userController.js';


const router = express.Router();

router.get('/:id',getUserById);
router.put('/update-fcm-token/:id',updateFcmToken);
export default router;
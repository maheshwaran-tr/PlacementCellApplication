import express from 'express';
import { signup,login,refreshTheToken } from '../controllers/authController.js';

const router = express.Router();

router.post('/signup',signup);
router.post('/login',login);
router.post('/refresh-token',refreshTheToken);

export default router;
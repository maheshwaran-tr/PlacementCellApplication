import express from 'express';
import { getAdminById, getAllAdmins, createAdmin, updateAdmin, deleteAdmin, getAdminProfile, uploadAdminProfile } from '../../controllers/adminController.js';
import multer from 'multer';

const router = express.Router();

// Configure Multer for file upload
const storage = multer.diskStorage({
    destination: 'uploads/admin_profiles',
    filename: function (req, file, cb) {
        const ext = file.originalname.split('.').pop();
        const filename = req.body.admin + '.' + ext;
        cb(null, filename);
    }
});

const upload = multer({ storage: storage });

// Get all admins
router.get('/', getAllAdmins);

// Get admin by ID
router.get('/:id', getAdminById);

// Create admin
router.post('/', createAdmin);

// Update admin
router.put('/:id', updateAdmin);

// Delete admin
router.delete('/:id', deleteAdmin);

// Serve images from MongoDB
router.get('/profile/:adminId', getAdminProfile);

// Handle image upload
router.post('/profile', upload.single('image'), uploadAdminProfile);

export default router;

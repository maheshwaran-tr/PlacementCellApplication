import express from 'express';
import multer from 'multer';
import { getAllStaffs, getStaffById, createMultipleStaff, createStaff, updateStaff, deleteStaff, getStaffProfile, uploadStaffProfile } from '../../controllers/staffController.js';

// Configure Multer for file upload
const storage = multer.diskStorage({
    destination: 'uploads/staff_profiles',
    filename: function (req, file, cb) {
        const ext = file.originalname.split('.').pop();
        const filename = req.body.staff + '.' + ext;
        cb(null, filename);
    }
});

const upload = multer({ storage: storage });


const router = express.Router();

router.post('/bulk', createMultipleStaff);

router.get('/', getAllStaffs);

router.get('/:id', getStaffById);

router.post('/', createStaff);

router.put('/:id', updateStaff);

router.delete('/:id', deleteStaff);

router.get('/profile/:staffId', getStaffProfile);

router.post('/profile', upload.single('image'), uploadStaffProfile);

export default router;
import express from 'express';
import multer from 'multer';
import { getAllStudents, getStudentById, deleteStudent, updateStudent, createStudent, createMultipleStudents, getStudentProfile, uploadStudentProfile } from '../../controllers/studentController.js';
import { restrict, verifyToken } from '../../controllers/authController.js';

const router = express.Router();

// Configure Multer for file upload
const storage = multer.diskStorage({
    destination: 'uploads/student_profiles',
    filename: function (req, file, cb) {
        const ext = file.originalname.split('.').pop();
        const filename = req.body.student + '.' + ext;
        cb(null, filename);
    }
});

const upload = multer({ storage: storage });

// router.get('/', verifyToken, restrict('Admin','Student'), getAllStudents);
router.get('/', getAllStudents);

router.get('/:id', getStudentById);

router.delete('/:id', deleteStudent);

router.put('/:id', updateStudent);

router.post('/', createStudent);

router.post('/bulk', createMultipleStudents);

router.get('/profile/:studentId', getStudentProfile);

router.post("/profile",upload.single("image"),uploadStudentProfile);


export default router;
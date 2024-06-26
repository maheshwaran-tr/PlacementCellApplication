import express from 'express';
import { getAllApplications,getApplicationById,createApplication,updateApplication,deleteApplication,multipleJobApplication } from '../../controllers/jobApplicationController.js';
import multer from 'multer';
import { getProof, uploadProof } from '../../controllers/proofController.js';
import path from 'path';
import fs from 'fs';


const router = express.Router();


// Configure Multer for file upload
const storage = multer.diskStorage({
    destination: 'uploads/application_proofs',
    filename: function (req, file, cb) {
        const ext = file.originalname.split('.').pop();
        const baseFilename = req.body.application;

        // Directory where the files are stored
        const dir = 'uploads/application_proofs';

        // Check if any file with the base name exists (regardless of extension)
        fs.readdir(dir, (err, files) => {
            if (err) {
                return cb(err);
            }

            files.forEach((existingFile) => {
                if (existingFile.startsWith(baseFilename)) {
                    // Delete existing file with the same base name but any extension
                    fs.unlink(path.join(dir, existingFile), (err) => {
                        if (err) {
                            console.log(`Failed to delete ${existingFile}:`, err);
                        }
                    });
                }
            });

            // Set the new file name
            const filename = `${baseFilename}.${ext}`;
            cb(null, filename);
        });
    }
});

const upload = multer({ storage: storage });

// Get all jobApplications
router.get('/', getAllApplications);

// Get jobApplication by ID
router.get('/:id', getApplicationById);

// Create jobApplication
router.post('/', createApplication);

// Create multiple jobApplications route
router.post('/bulk', multipleJobApplication);

// Update jobApplication
router.put('/:id', updateApplication);

// Delete jobApplication
router.delete('/:id', deleteApplication);

router.get('/proof/:applicationId',getProof);

router.post("/proof",upload.single("proofImage"),uploadProof);


export default router;
import express from 'express';
import { getAllJobs, getJobById, createJob, uploadJob, deleteJob } from '../../controllers/jobController.js';


const router = express.Router();


// Get all jobs
router.get('/', getAllJobs);


// Get Job By Id
router.get('/:id', getJobById);


// Create Job
router.post('/', createJob);


// Update Job
router.put('/:id', uploadJob);


// Delete Job
router.delete('/:id', deleteJob);

export default router;
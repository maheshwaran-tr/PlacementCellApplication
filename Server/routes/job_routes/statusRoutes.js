import express from 'express';
import { getAllStatus,getStatusById,createStatus,updateStatus,deleteStatus } from '../../controllers/statusController.js';

const router = express.Router();

// Get all statuses
router.get('/', getAllStatus);

// Get status by ID
router.get('/:id', getStatusById);

// Create status
router.post('/', createStatus);

// Update status
router.put('/:id', updateStatus);

// Delete status
router.delete('/:id', deleteStatus);

export default router;

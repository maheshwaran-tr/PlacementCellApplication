import { Status } from "../models/job_models/statusModel.js";

export const getAllStatus = async (req, res) => {
    try {
        const excludeFields = ['sort', 'page', 'limit', 'fields'];
        const queryObj = { ...req.query };

        excludeFields.forEach((el) => {
            delete queryObj[el]
        });

        let queryStr = JSON.stringify(queryObj);
        queryStr = queryStr.replace(/\b(gte|gt|lte|lt)\b/g, (match) => `$${match}`);
        const newQueryObj = JSON.parse(queryStr);

        const allStatuses = await Status.find(newQueryObj);
        return res.status(200).json({ size: allStatuses.length, data: allStatuses });
    } catch (error) {
        return res.status(500).send({ message: error.message });
    }
}
export const getStatusById = async (req, res) => {
    try {
        const { id } = req.params;
        const status = await Status.findById(id);
        if (!status) {
            return res.status(404).send('Status not found');
        }
        return res.status(200).json(status);
    } catch (error) {
        return res.status(500).send({ message: error.message });
    }
}

export const createStatus = async (req, res) => {
    try {
        const newStatus = new Status(req.body);
        const savedStatus = await newStatus.save();
        return res.status(201).json(savedStatus);
    } catch (error) {
        return res.status(500).send({ message: error.message });
    }
}
export const updateStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await Status.findByIdAndUpdate(id, req.body);
        if (!result) {
            return res.status(404).send('Status not found');
        }
        return res.status(200).send('Status successfully updated');
    } catch (error) {
        return res.status(500).send({ message: error.message });
    }
}
export const deleteStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await Status.findByIdAndDelete(id);
        if (!result) {
            return res.status(404).send('Status not found');
        }
        return res.status(200).send('Status successfully deleted');
    } catch (error) {
        return res.status(500).send({ message: error.message });
    }
}
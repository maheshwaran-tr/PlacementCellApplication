import { Job } from "../models/job_models/jobModel.js";

export const getAllJobs = async (req, res) => {
  try {
    const excludeFields = ["sort", "page", "limit", "fields"];
    const queryObj = { ...req.query };

    excludeFields.forEach((el) => {
      delete queryObj[el];
    });

    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(/\b(gte|gt|lte|lt)\b/g, (match) => `$${match}`);
    const newQueryObj = JSON.parse(queryStr);

    let query = Job.find(newQueryObj);

    // SORTING
    if (req.query.sort) {
      const sortBy = req.query.sort.split(",").join(" ");
      query = query.sort(sortBy);
    } else {
      query = query.sort("-cgpa");
    }

    // LIMITING FIELDS
    if (req.query.fields) {
      const selectedFields = req.query.fields.split(",").join(" ");
      query = query.select(selectedFields);
    } else {
      query = query.select("-__v"); // Exclude particular field
    }

    // PAGINATION
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 10;
    const skip = (page - 1) * limit;

    query = query.skip(skip).limit(limit);

    const allJobs = await query;

    return res.status(200).json({
      page: page,
      size: allJobs.length,
      data: allJobs,
    });
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const getJobById = async (req, res) => {
  try {
    const { id } = req.params;
    const job = await Job.findById(id);
    return res.status(200).json(job);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const createJob = async (req, res) => {
  try {
    if (req.body.hasOwnProperty("_id")) {
      delete req.body._id;
    }
    const newJob = new Job(req.body);
    const savedJob = await newJob.save();
    return res.status(201).json(savedJob);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const uploadJob = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Job.findByIdAndUpdate(id, req.body);
    if (!result) {
      return ReadableStream.status(404).send("Job Not Found");
    }
    return res.status(200).send("Job Successfully Updated");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const deleteJob = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Job.findByIdAndDelete(id);
    if (!result) {
      return ReadableStream.status(404).send("Job Not Found");
    }
    return res.status(200).send("Job Successfully Deleted");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

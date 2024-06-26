import { JobApplication } from "../models/job_models/jobApplicationModel.js";
import { Job } from "../models/job_models/jobModel.js";
import { Student } from "../models/student_models/studentModel.js";

export const getAllApplications = async (req, res) => {
  try {
    const excludeFields = ["sort", "page", "limit", "fields"];
    const queryObj = { ...req.query };

    excludeFields.forEach((el) => {
      delete queryObj[el];
    });

    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(/\b(gte|gt|lte|lt)\b/g, (match) => `$${match}`);
    const newQueryObj = JSON.parse(queryStr);

    let query = JobApplication.find(newQueryObj);

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

    // Unboxing query object
    const allJobApplications = await query;

    return res.status(200).json({
      page: page,
      size: allJobApplications.length,
      data: allJobApplications,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send({ message: error.message });
  }
};

export const getApplicationById = async (req, res) => {
  try {
    const { id } = req.params;
    const jobApplication = await JobApplication.findById(id);
    if (!jobApplication) {
      return res.status(404).send("Job application not found");
    }
    return res.status(200).json(jobApplication);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const createApplication = async (req, res) => {
  try {
    const newJobApplication = new JobApplication(req.body);

    const exisitApp = await JobApplication.find({
      student: newJobApplication.student,
      job: newJobApplication.job,
    });
    
    if (exisitApp.length > 0) {
      return res.status(409).json({ message: "Application already exists" });
    }

    // adding application to job model
    const job = await Job.findById(req.body.job);

    if (!job) {
      return res.status(404).send("Job not found");
    }
    const savedJobApplication = await newJobApplication.save();

    job.jobApplications.push(savedJobApplication._id);

    await job.save();

    // adding application to student
    let student = await Student.findById(req.body.student);

    if (!student) {
      return res.status(404).send("Student not found");
    }

    if (!student.jobApplications) {
      student.jobApplications = []; // Initialize if undefined
    }

    student.jobApplications.push(savedJobApplication._id);
    await student.save();

    return res.status(201).json(savedJobApplication);
  } catch (error) {
    console.log(error);
    return res.status(500).send({ message: error.message });
  }
};

export const updateApplication = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await JobApplication.findByIdAndUpdate(id, req.body);
    if (!result) {
      return res.status(404).send("Job application not found");
    }
    return res.status(200).send("Job application successfully updated");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const deleteApplication = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await JobApplication.findByIdAndDelete(id);
    if (!result) {
      return res.status(404).send("Job application not found");
    }

    // Remove the job application ID from the job's jobApplications array
    const job = await Job.findById(jobApplication.job);
    if (job) {
      job.jobApplications = job.jobApplications.filter(
        (appId) => appId.toString() !== id
      );
      await job.save();
    }

    // Remove the job application ID from the student's jobApplications array
    const student = await Student.findById(jobApplication.student);
    if (student) {
      student.jobApplications = student.jobApplications.filter(
        (appId) => appId.toString() !== id
      );
      await student.save();
    }
    
    return res.status(200).send("Job application successfully deleted");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const multipleJobApplication = async (req, res) => {
  try {
    const jobApplicationsList = req.body; // Array of job application objects from request body
    const createdJobApplications = await JobApplication.insertMany(
      jobApplicationsList
    );
    return res.status(201).json(createdJobApplications);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

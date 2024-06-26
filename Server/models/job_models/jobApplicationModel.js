import mongoose from "mongoose";

const jobApplicationSchema = new mongoose.Schema(
  {
    student: { type: mongoose.Schema.Types.ObjectId, ref: "Student" },
    job: { type: mongoose.Schema.Types.ObjectId, ref: "Job" },
    status: { type: String },
    isStaffApproved : { type : Boolean }
  },
  {
    timestamps: true,
  }
);

export const JobApplication = mongoose.model(
  "JobApplication",
  jobApplicationSchema
);
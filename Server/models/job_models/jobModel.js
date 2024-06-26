import mongoose from 'mongoose';


const jobSchema = new mongoose.Schema(
    {
        companyName : String,
        company_location : String,
        venue : String,
        jobName : String,
        description : String,
        campusMode : String,
        eligible10thMark : Number,
        eligible12thMark : Number,
        eligibleCGPA : Number,
        interviewDate : String,
        interviewTime : String,
        historyOfArrears : Number,
        skills : Array,
        jobApplications : [ { type : mongoose.Schema.Types.ObjectId, ref : 'JobApplication'} ]
    },
    {
        timestamps : true
    }
);


export const Job = mongoose.model('Job',jobSchema);
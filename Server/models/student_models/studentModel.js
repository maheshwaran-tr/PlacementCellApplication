import mongoose from 'mongoose';

const studentSchema = new mongoose.Schema({
    rollNo: { type: String, unique: true },
    regNo: { type: String, unique: true },
    studentName: String,
    department: String,
    cgpa: Number,
    score10th: Number,
    score12th: Number,
    placementWilling: Boolean,
    community: String,
    gender: String,
    section: String,
    fatherName: String,
    fatherOccupation: String,
    motherName: String,
    motherOccupation: String,
    placeOfBirth: String,
    dateOfBirth: String,
    board10th: String,
    yearOfPassing10th: String,
    board12th: String,
    yearOfPassing12th: String,
    scoreDiploma: String,
    branchDiploma: String,
    yearOfPassingDiploma: String,
    permanentAddress: String,
    presentAddress: String,
    phoneNumber: String,
    parentPhoneNumber: String,
    email: String,
    aadhar: String,
    batch: Number,
    currentSem: Number,
    standingArrears: Number,
    historyOfArrears: Number,
    jobApplications : [ { type : mongoose.Schema.Types.ObjectId, ref : 'JobApplication'} ]
}, {
    timestamps: true
});


export const Student = mongoose.model('Student', studentSchema);
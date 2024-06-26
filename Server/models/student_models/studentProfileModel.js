import mongoose from 'mongoose';


const studentProfileSchema = new mongoose.Schema(
    {
        student : { type : mongoose.Schema.Types.ObjectId , ref : 'Student' },
        image: { type: String }
    },
    {timestamps: true}
);

export const StudentProfile = mongoose.model('studentProfile',studentProfileSchema);
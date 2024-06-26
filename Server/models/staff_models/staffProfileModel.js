import mongoose from 'mongoose';


const staffProfileSchema = new mongoose.Schema(
    {
        staff : { type : mongoose.Schema.Types.ObjectId , ref : 'Staff' },
        image: { type: String }
    },
    {timestamps: true}
);

export const StaffProfile = mongoose.model('staffProfile',staffProfileSchema);
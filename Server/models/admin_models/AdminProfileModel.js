import mongoose from 'mongoose';


const adminProfileSchema = new mongoose.Schema(
    {
        admin : { type : mongoose.Schema.Types.ObjectId , ref : 'Admin' },
        image: { type: String }
    },
    {timestamps: true}
);

export const AdminProfile = mongoose.model('adminProfile',adminProfileSchema);
import mongoose from 'mongoose';


const staffSchema = new mongoose.Schema(
    {
        staffId: { type: String, unique: true },
        staffName: String,
        department: String,
        email: String,
        phoneNumber: String
    }
    ,
    {
        timestamps: true
    }
);

export const Staff = mongoose.model('Staff', staffSchema);
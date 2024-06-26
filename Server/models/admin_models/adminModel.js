import mongoose from 'mongoose';

const adminSchema = new mongoose.Schema(
    {
        adminId: { type: String, unique: true },
        adminName: String,
        email: String,
        phoneNumber: String
    },
    {
        timestamps: true
    }
);

export const Admin = mongoose.model('Admin', adminSchema);
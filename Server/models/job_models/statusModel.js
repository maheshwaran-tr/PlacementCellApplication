import mongoose from 'mongoose';

const statusSchema = new mongoose.Schema(
    {
        statusCode : String,
        statusName : String
    },
    {
        timestamps : true
    }
);


export const Status = mongoose.model('Status',statusSchema);
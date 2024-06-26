import mongoose from 'mongoose';


const proofSchema = new mongoose.Schema(
    {
        application : { type : mongoose.Schema.Types.ObjectId, ref : 'JobApplication'},
        proofImage : {type : String}
    },
    {timestamps: true}
);

export const Proofs = mongoose.model('proofs',proofSchema);
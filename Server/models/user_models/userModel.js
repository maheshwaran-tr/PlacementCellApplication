import validator from 'validator';
import mongoose from 'mongoose';



const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: [true, 'Please enter your name.']
    },
    email: {
        type: String,
        required: [true, 'Please enter an email.'],
        unique: true,
        lowercase: true,
        validate: [validator.isEmail, 'Please enter a valid email.']
    },
    role: {
        type: String,
        enum: ['Admin', 'Staff', 'Student'],
        default: 'Student'
    },
    password: {
        type: String,
        required: [true, 'Please enter a password.'],
        minlength: 8,
        // select : false
    },
    fcmToken: {
        type: String,
        default: null // Optional: You might want to handle this differently based on your requirements
    },
    roleId: {
        type: mongoose.Schema.Types.ObjectId,
        refPath: 'role'
    }
}, { timestamps: true });

export const User = mongoose.model('User',userSchema);
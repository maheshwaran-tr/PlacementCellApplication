import { Admin } from "../models/admin_models/adminModel.js";
import { AdminProfile } from "../models/admin_models/AdminProfileModel.js";
import { User } from "../models/user_models/userModel.js";
import bcrypt from "bcrypt";

export const getAdminByAdminId = async (username) => {
  try {
    const admin = await Admin.findOne({ adminId: username });
    return admin;
  } catch (error) {
    return error;
  }
};

export const getAllAdmins = async (req, res) => {
  try {
    const excludeFields = ["sort", "page", "limit", "fields"];
    const queryObj = { ...req.query };

    excludeFields.forEach((el) => {
      delete queryObj[el];
    });

    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(/\b(gte|gt|lte|lt)\b/g, (match) => `$${match}`);
    const newQueryObj = JSON.parse(queryStr);

    let query = Admin.find(newQueryObj);

    // SORTING
    if (req.query.sort) {
      const sortBy = req.query.sort.split(",").join(" ");
      query = query.sort(sortBy);
    } else {
      query = query.sort("-cgpa");
    }

    // LIMITING FIELDS
    if (req.query.fields) {
      const selectedFields = req.query.fields.split(",").join(" ");
      query = query.select(selectedFields);
    } else {
      query = query.select("-_v"); // Exclude particular field
    }

    // PAGINATION
    const page = req.query.page * 1 || 1;
    const limit = req.query.limit * 1 || 10;
    const skip = (page - 1) * limit;

    query = query.skip(skip).limit(limit);

    const allAdmins = await query;

    return res
      .status(200)
      .json({ page: page, size: allAdmins.length, data: allAdmins });
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const getAdminById = async (req, res) => {
  try {
    const { id } = req.params;
    const admin = await Admin.findById(id);
    if (!admin) {
      return res.status(404).send("Admin not found");
    }
    return res.status(200).json(admin);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};
export const createAdmin = async (req, res) => {
  try {
    const newAdmin = new Admin(req.body);
    const savedAdmin = await newAdmin.save();

    // Extracting necessary details for the user registration
    const username = savedAdmin.adminId;
    const email = savedAdmin.email;
    const password = savedAdmin.adminId; // Assuming dateOfBirth is in a format that can be used as a password
    const role = "Admin";
    const roleId = savedAdmin._id.toString(); // Convert ObjectId to string

    const existingUser = await User.findOne({ username });

    if (existingUser) {
      return res.status(400).send("Username already exists.");
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      username,
      email,
      role: role || "Student",
      password: hashedPassword,
      roleId: roleId,
    });

    await newUser.save();

    return res.status(201).json(savedAdmin);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};
export const updateAdmin = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Admin.findByIdAndUpdate(id, req.body);
    if (!result) {
      return res.status(404).send("Admin not found");
    }
    return res.status(200).send("Admin successfully updated");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};
export const deleteAdmin = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Admin.findByIdAndDelete(id);
    if (!result) {
      return res.status(404).send("Admin not found");
    }
    return res.status(200).send("Admin successfully deleted");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};
export const getAdminProfile = async (req, res) => {
  try {
    const { adminId } = req.params;
    // Find the Profile document based on the adminId
    const profile = await AdminProfile.findOne({ admin: adminId });

    if (!profile || !profile.image) {
      return res.status(404).send("Image not found");
    }

    res.set("Content-Type", "image/jpeg");
    // Serve the image file
    res.sendFile(profile.image, { root: "uploads/admin_profiles" });
  } catch (error) {
    console.error("Error fetching image:", error);
    res.status(500).send("Failed to fetch image");
  }
};

export const uploadAdminProfile = async (req, res) => {
  try {
    // Create a new profile document
    const newProfile = new AdminProfile({
      admin: req.body.admin, // Assuming admin ID is sent in the request body
      image: req.file.filename, // Save the filename of the uploaded image
    });

    // Save the profile document to MongoDB
    const savedProfile = await newProfile.save();

    res.status(200).send("Profile created successfully");
  } catch (error) {
    console.error("Error creating profile:", error);
    res.status(500).send("Failed to create profile");
  }
};

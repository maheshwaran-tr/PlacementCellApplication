import { Staff } from "../models/staff_models/staffModel.js";
import { StaffProfile } from "../models/staff_models/staffProfileModel.js";
import { User } from "../models/user_models/userModel.js";
import bcrypt from "bcrypt";


export const getStaffByStaffId = async (username) => {
  try {
    const staff = await Staff.findOne({ staffId: username });
    return staff;
  } catch (error) {
    return error;
  }
};

export const getAllStaffs = async (req, res) => {
  try {
    // const excludeFields = ["sort", "page", "limit", "fields"];
    // const queryObj = { ...req.query };

    // excludeFields.forEach((el) => {
    //   delete queryObj[el];
    // });

    // let queryStr = JSON.stringify(queryObj);
    // queryStr = queryStr.replace(/\b(gte|gt|lte|lt)\b/g, (match) => `$${match}`);
    // const newQueryObj = JSON.parse(queryStr);

    // let query = Staff.find(newQueryObj);

    // // SORTING
    // if (req.query.sort) {
    //   const sortBy = req.query.sort.split(",").join(" ");
    //   query = query.sort(sortBy);
    // } else {
    //   query = query.sort("-cgpa");
    // }

    // // LIMITING FIELDS
    // if (req.query.fields) {
    //   const selectedFields = req.query.fields.split(",").join(" ");
    //   query = query.select(selectedFields);
    // } else {
    //   query = query.select("-__v"); // Exclude particular field
    // }

    // // PAGINATION
    // const page = req.query.page * 1 || 1;
    // const limit = req.query.limit * 1 || 10;
    // const skip = (page - 1) * limit;

    // query = query.skip(skip).limit(limit);

    const allStaffs = await Staff.find();
    return res.status(200).json({
      size: allStaffs.length,
      data: allStaffs,
    });
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const getStaffById = async (req, res) => {
  try {
    const { id } = req.params;
    const staff = await Staff.findById(id);
    if (!staff) {
      return res.status(404).send("Staff not found");
    }
    return res.status(200).json(staff);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const createStaff = async (req, res) => {
  try {

    if (req.body.hasOwnProperty("_id")) {
      delete req.body._id;
    }
    
    const newStaff = new Staff(req.body);
    const savedStaff = await newStaff.save();

    // Extracting necessary details for the user registration
    const username = savedStaff.staffId;
    const email = savedStaff.email;
    const password = savedStaff.staffId; // Assuming dateOfBirth is in a format that can be used as a password
    const role = "Staff";
    const roleId = savedStaff._id.toString(); // Convert ObjectId to string

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

    return res.status(201).json(savedStaff);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const updateStaff = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await Staff.findByIdAndUpdate(id, req.body);
    if (!result) {
      return res.status(404).send("Staff not found");
    }
    return res.status(200).send("Staff successfully updated");
  } catch (error) {
    console.log(error.message);
    return res.status(500).send({ message: error.message });

  }
};

export const deleteStaff = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Staff.findByIdAndDelete(id);
    if (!result) {
      return res.status(404).send("Staff not found");
    }
    return res.status(200).send("Staff successfully deleted");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const createMultipleStaff = async (req, res) => {
  try {
    const staffList = req.body; // Array of staff objects from request body
    const createdStaffs = await Staff.insertMany(staffList);
    return res.status(201).json(createdStaffs);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const getStaffProfile = async (req, res) => {
  try {
    const { staffId } = req.params;
    // Find the Profile document based on the staffId
    const profile = await StaffProfile.findOne({ staff: staffId });

    if (!profile || !profile.image) {
      return res.status(404).send("Image not found");
    }

    res.set("Content-Type", "image/jpeg");
    // Serve the image file
    res.sendFile(profile.image, { root: "uploads/staff_profiles" });
  } catch (error) {
    console.error("Error fetching image:", error);
    res.status(500).send("Failed to fetch image");
  }
};

export const uploadStaffProfile = async (req, res) => {
  try {
    // Create a new profile document
    const newProfile = new StaffProfile({
      staff: req.body.staff, // Assuming staff ID is sent in the request body
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
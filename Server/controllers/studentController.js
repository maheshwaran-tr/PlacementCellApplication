import { Student } from "../models/student_models/studentModel.js";
import { StudentProfile } from "../models/student_models/studentProfileModel.js";
import { User } from "../models/user_models/userModel.js";
import bcrypt from "bcrypt";

export const getAllStudents = async (req, res) => {
  try {
    const excludeFields = ["sort", "page", "limit", "fields"];
    const queryObj = { ...req.query };

    excludeFields.forEach((el) => {
      delete queryObj[el];
    });

    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(/\b(gte|gt|lte|lt)\b/g, (match) => `$${match}`); // FILTERING
    const newQueryObj = JSON.parse(queryStr);

    let query = Student.find(newQueryObj);
    
    // Check if uniqueByDepartment is true
    if (req.query.allDepartment === 'true') {
      
      const studentsByDepartment = await Student.aggregate([
        {
          $group: {
            _id: "$department",
            student: { $first: "$$ROOT" }
          }
        },
        {
          $replaceRoot: { newRoot: "$student" }
        }
      ]);
      
      return res.status(200).json({
        size: studentsByDepartment.length,
        data: studentsByDepartment,
      });
    }

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

    // EXECUTE QUERY
    const allStudents = await query;

    return res.status(200).json({
      page: page,
      size: allStudents.length,
      data: allStudents,
    });
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const getStudentById = async (req, res) => {
  try {
    const { id } = req.params;
    const student = await Student.findById(id);
    return res.status(200).json(student);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const getStudentByRollno = async (username) => {
  try {
    const student = await Student.findOne({ rollNo: username });
    return student;
  } catch (error) {
    return error;
  }
};

export const deleteStudent = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Student.findByIdAndDelete(id);
    if (!result) {
      return res.status(404).send("Student Not Found");
    }
    return res.status(200).send("Student Successfully Deleted");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const updateStudent = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Student.findByIdAndUpdate(id, req.body);
    if (!result) {
      return res.status(404).send("Student Not Found");
    }
    return res.status(200).send("Student Successfully Updated");
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const createStudent = async (req, res) => {
  try {
    // Remove id from the request body if it exists
    if (req.body.hasOwnProperty("_id")) {
      delete req.body._id;
    }

    // Create a new student from the request body
    let newStudent = new Student(req.body);

    // Save the student to the database
    const savedStudent = await newStudent.save();

    // Extracting necessary details for the user registration
    const username = savedStudent.rollNo;
    const email = savedStudent.email;
    const password = savedStudent.dateOfBirth; // Assuming dateOfBirth is in a format that can be used as a password
    const role = "Student";
    const roleId = savedStudent._id.toString(); // Convert ObjectId to string

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

    // Respond with the saved student details
    return res.status(201).json(savedStudent);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const createMultipleStudents = async (req, res) => {
  try {
    const studentList = req.body; // Array of staff objects from req body
    const createdStudents = await Student.insertMany(studentList);
    return res.status(201).json(createdStudents);
  } catch (error) {
    return res.status(500).send({ message: error.message });
  }
};

export const getStudentProfile = async (req, res) => {
  try {
    const { studentId } = req.params;

    // Find the Profile document based on the studentId
    const profile = await StudentProfile.findOne({ student: studentId });

    if (!profile || !profile.image) {
      return res.status(404).send("Image not found");
    }

    res.set("Content-Type", "image/jpeg");
    // Serve the image file
    res.sendFile(profile.image, { root: "uploads/student_profiles" });
  } catch (error) {
    console.error("Error fetching image:", error);
    res.status(500).send("Failed to fetch image");
  }
};

export const uploadStudentProfile = async (req, res) => {
  try {
    // Create a new profile document
    const newProfile = new StudentProfile({
      student: req.body.student, // Assuming student ID is sent in the request body
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


export const getAllStudentsDepartment = async (req,res) => {
  try {
   
  } catch (error) {
    console.error("Error fetching department:", error);
    res.status(500).send("Failed to fetch departments");
  }
};

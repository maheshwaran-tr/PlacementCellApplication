import bcrypt from "bcrypt";
import { User } from "../models/user_models/userModel.js";
import jwt from "jsonwebtoken";
import { getStudentByRollno } from "./studentController.js";
import { getAdminByAdminId } from "./adminController.js";
import { getStaffByStaffId } from "./staffController.js";


const generateAccessToken = (userId) => {
  // Payload now includes id, username, and roles
  const payload = {
    id: userId,
  };

  // Options for the token, including the expiration time
  const options = {
    expiresIn: process.env.TOKENEXPIRES,
  };

  // Generate the token by signing the payload with the secret key and options
  return jwt.sign(payload, process.env.SECRETKEY, options);
};

// const generateRefreshToken = (userId) => {
//   return jwt.sign({ id: userId }, process.env.REFRESHKEY, {
//     expiresIn: process.env.TOKENEXPIRES,
//   });
// };
const generateRefreshToken = (userId) => {
  // Payload now includes id, username, and roles
  const payload = {
    id: userId,
  };

  // Options for the token, including the expiration time
  const options = {
    expiresIn: process.env.TOKENEXPIRES,
  };

  // Generate the token by signing the payload with the secret key and options
  return jwt.sign(payload, process.env.REFRESHKEY, options);
};


// export const register = async (
//   username,
//   email,
//   password,
//   confirmPassword,
//   role,
//   roleId
// ) => {

//   // Check if passwords match
//   if (password !== confirmPassword) {
//     return 400;
//   }

//   // Check if the user already exists
//   const existingUser = await User.findOne({ username });

//   if (existingUser) {
//     return 400;
//   }

//   // Hash the password
//   const hashedPassword = await bcrypt.hash(password, 10);

//   // Create a new user
//   const newUser = new User({
//     username,
//     email,
//     role: role || "Student",
//     password: hashedPassword,
//     roleId: roleId
//   });

//   await newUser.save();

//   return 201;
// };

export const signup = async (req, res) => {

  // parsing req body
  const { username, email, password, confirmPassword, role, roleId } = req.body;
  
  // Check if passwords match
  if (password !== confirmPassword) {
    return res.status(400).send("Passwords do not match.");
  }

  // Check if the user already exists
  const existingUser = await User.findOne({ username });

  if (existingUser) {
    return res.status(400).send("Username already exists.");
  }

  // Hash the password
  const hashedPassword = await bcrypt.hash(password, 10);

  // Create a new user
  const newUser = new User({
    username,
    email,
    role: role || "Student",
    password: hashedPassword,
    roleId: roleId
  });

  await newUser.save();

  res.status(201).send("User created successfully.");
};

export const login = async (req, res) => {
  // parsing req body
  const { username, password } = req.body;

  // Check if the user  exists
  const user = await User.findOne({ username });

  if (!user) {
    return res.status(404).send("User not found.");
  }

  let userData;

  if (user["role"] == "Student") {
    userData = await getStudentByRollno(username);
  } else if (user["role"] == "Staff") {
    userData = await getStaffByStaffId(username);
  } else if (user["role"] == "Admin") {
    userData = await getAdminByAdminId(username);
  } else {
    return res.status(404).send("User Role not found.");
  }

  // verify password
  const validPassword = await bcrypt.compare(password, user.password);

  if (!validPassword) {
    return res.status(401).send("Invalid password.");
  }

  // generating token
  const accessToken = generateAccessToken(user._id);
  const refreshToken = generateRefreshToken(user._id);

  res.status(200).send({
    access_token: accessToken,
    refresh_token: refreshToken,
    role: user["role"],
    user_data: userData,
    user_id : user.id
  });
};

export const verifyToken = (req, res, next) => {
  // getting token
  const token = req.headers["authorization"];

  if (!token) {
    return res.status(403).send({ auth: false, message: "No token provided." });
  }

  // verify token
  jwt.verify(token, process.env.SECRETKEY, (err, decoded) => {
    if (err) {
      return res
        .status(500)
        .send({ auth: false, message: "Failed to authenticate token." });
    }
    req.userId = decoded.id;
    next();
  });
};

export const refreshTheToken = async (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(403).send("Refresh token not provided.");
  }

  const decoded = jwt.verify(refreshToken, process.env.REFRESHKEY);
  // Extract the payload
  const userId = decoded.id;

  const user = await User.findById(userId);

  if (!user) {
    return res.status(404).send("User not found.");
  }

  let userData;

  if (user["role"] == "Student") {
    userData = await getStudentByRollno(user["username"]);
  } else if (user["role"] == "Staff") {
    userData = await getStaffByStaffId(user["username"]);
  } else if (user["role"] == "Admin") {
    userData = await getAdminByAdminId(user["username"]);
  } else {
    return res.status(404).send("User Role not found.");
  }

  jwt.verify(refreshToken, process.env.REFRESHKEY, (err, decoded) => {
    if (err) {
      return res.status(401).send("Invalid refresh token.");
    }

    const accessToken = generateAccessToken(decoded.id);
    const newRefreshToken = generateRefreshToken(decoded.id);

    res.status(200).send({
      access_token: accessToken,
      refresh_token: refreshToken,
      role: user["role"],
      user_data: userData,
    });
  });
};

export const restrict = (...requiredRoles) => {
  return async (req, res, next) => {
    try {
      const user = await User.findById(req.userId);
      if (!user) {
        return res.status(404).send("User not Found");
      }
      if (!requiredRoles.includes(user.role)) {
        return res.status(403).send("Access denied.");
      }
      next();
    } catch (error) {
      console.error(error);
      return res.status(500).send("Internal Server Error");
    }
  };
};

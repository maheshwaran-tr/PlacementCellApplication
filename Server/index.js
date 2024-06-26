import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import { configDotenv } from "dotenv";
import catalyst from "zcatalyst-sdk-node";

import studentRouter from "./routes/student_routes/studentRoutes.js";
import jobRouter from "./routes/job_routes/jobRoutes.js";
import jobApplicationRouter from "./routes/job_routes/jobApplicationRoutes.js";
import statusRouter from "./routes/job_routes/statusRoutes.js";
import staffRouter from "./routes/staff_routes/staffRoutes.js";
import adminRouter from "./routes/admin_routes/adminRoutes.js";
import authRouter from "./routes/authRoutes.js";
import userRouter from "./routes/user_routes/userRoutes.js";
import notiRouter from "./routes/pushNotificationRoutes.js";




const app = express();
app.use(express.json());
app.use(cors());
configDotenv();
// app = catalyst.initialize(req); 


// Routes
app.use("/students", studentRouter);
app.use("/jobs", jobRouter);
app.use("/staffs", staffRouter);
app.use("/admin", adminRouter);
app.use("/status", statusRouter);
app.use("/jobapplication", jobApplicationRouter);
app.use("/auth", authRouter);
app.use("/users", userRouter);
app.use("/send-noti",notiRouter);

// MongoDB Connection
mongoose
  .connect(process.env.MONGOURL)
  .then(() => {
    console.log(`App is connected to the mongodb`);
    app.listen(process.env.X_ZOHO_CATALYST_LISTEN_PORT, () => {
      console.log(`App Listening on Port ${process.env.X_ZOHO_CATALYST_LISTEN_PORT}`);
    });
  })
  .catch((error) => {
    console.log(error);
  });

import express from "express";

import gradeRoutes from "./grade.js";
import registrationRoutes from "./registration.js";

const router = express.Router();

router.use("/grades", gradeRoutes);

router.use("/course-registration", registrationRoutes);

export default router;

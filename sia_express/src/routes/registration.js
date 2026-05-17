import express from "express";
import pool from "../config/db.js";

const router = express.Router();

const MAX_CREDITS = 24;

router.post("/submit", async (req, res) => {
  const connection = await pool.getConnection();

  try {
    const { student_id, academic_term, course_ids } = req.body;

    // basic payload validation

    if (
      !student_id ||
      !academic_term ||
      !Array.isArray(course_ids) ||
      course_ids.length === 0
    ) {
      return res.status(400).json({
        success: false,
        message: "Invalid request payload",
      });
    }

    // duplicate course validation

    const uniqueCourses = [...new Set(course_ids)];

    if (uniqueCourses.length !== course_ids.length) {
      return res.status(400).json({
        success: false,
        message: "Duplicate course detected",
      });
    }

    await connection.beginTransaction();

    // validate student existence

    const [students] = await connection.query(
      `
      SELECT id
      FROM students
      WHERE id = ?
      `,
      [student_id],
    );

    if (students.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Student not found",
      });
    }

    // get course information

    const placeholders = course_ids.map(() => "?").join(",");

    const [courses] = await connection.query(
      `
      SELECT id, credits
      FROM courses
      WHERE id IN (${placeholders})
      `,
      course_ids,
    );

    // validate all courses exist

    if (courses.length !== course_ids.length) {
      return res.status(400).json({
        success: false,
        message: "Invalid course data",
      });
    }

    // calculate total credits

    const totalCredits = courses.reduce(
      (sum, course) => sum + course.credits,
      0,
    );

    // max credits validation

    if (totalCredits > MAX_CREDITS) {
      return res.status(400).json({
        success: false,
        message: "Maximum credits exceeded",
      });
    }

    // insert registration header

    const [registrationResult] = await connection.query(
      `
        INSERT INTO course_registrations (
          student_id,
          academic_term,
          total_credits
        )
        VALUES (?, ?, ?)
        `,
      [student_id, academic_term, totalCredits],
    );

    const registrationId = registrationResult.insertId;

    // insert registration details

    const detailData = course_ids.map((courseId) => [registrationId, courseId]);

    await connection.query(
      `
      INSERT INTO course_registration_details (
        registration_id,
        course_id
      )
      VALUES ?
      `,
      [detailData],
    );

    await connection.commit();

    res.json({
      success: true,
      registration_id: registrationId,
      total_credits: totalCredits,
    });
  } catch (error) {
    await connection.rollback();

    console.error(error);

    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  } finally {
    connection.release();
  }
});

export default router;

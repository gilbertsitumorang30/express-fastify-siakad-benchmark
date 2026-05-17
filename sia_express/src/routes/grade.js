import express from "express";
import pool from "../config/db.js";

const router = express.Router();

router.get("/:studentId", async (req, res) => {
  try {
    const { studentId } = req.params;

    const [rows] = await pool.query(
      `
      SELECT
          c.course_code,
          c.course_name,
          g.letter_grade,
          g.numeric_grade
      FROM grades g
      JOIN courses c
          ON g.course_id = c.id
      WHERE g.student_id = ?
      `,
      [studentId],
    );

    res.json({
      success: true,
      total: rows.length,
      data: rows,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

export default router;

import pool from "../config/db.js";

async function gradeRoutes(app) {
  app.get("/grades/:studentId", async (request, reply) => {
    try {
      const { studentId } = request.params;

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

      return {
        success: true,
        total: rows.length,
        data: rows,
      };
    } catch (error) {
      console.error(error);

      reply.status(500);

      return {
        success: false,
        message: "Internal server error",
      };
    }
  });
}

export default gradeRoutes;

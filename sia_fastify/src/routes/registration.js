import pool from "../config/db.js";

const MAX_CREDITS = 24;

async function registrationRoutes(app) {
  app.post("/course-registration/submit", async (request, reply) => {
    const connection = await pool.getConnection();

    try {
      const { student_id, academic_term, course_ids } = request.body;

      // basic validation

      if (
        !student_id ||
        !academic_term ||
        !Array.isArray(course_ids) ||
        course_ids.length === 0
      ) {
        reply.status(400);

        return {
          success: false,
          message: "Invalid request payload",
        };
      }

      // duplicate validation

      const uniqueCourses = [...new Set(course_ids)];

      if (uniqueCourses.length !== course_ids.length) {
        reply.status(400);

        return {
          success: false,
          message: "Duplicate course detected",
        };
      }

      await connection.beginTransaction();

      // validate student

      const [students] = await connection.query(
        `
            SELECT id
            FROM students
            WHERE id = ?
            `,
        [student_id],
      );

      if (students.length === 0) {
        reply.status(404);

        return {
          success: false,
          message: "Student not found",
        };
      }

      // get courses

      const placeholders = course_ids.map(() => "?").join(",");

      const [courses] = await connection.query(
        `
            SELECT id, credits
            FROM courses
            WHERE id IN (${placeholders})
            `,
        course_ids,
      );

      // validate course count

      if (courses.length !== course_ids.length) {
        reply.status(400);

        return {
          success: false,
          message: "Invalid course data",
        };
      }

      // calculate credits

      const totalCredits = courses.reduce(
        (sum, course) => sum + course.credits,
        0,
      );

      // max credits validation

      if (totalCredits > MAX_CREDITS) {
        reply.status(400);

        return {
          success: false,
          message: "Maximum credits exceeded",
        };
      }

      // insert registration

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

      // insert details

      const detailData = course_ids.map((courseId) => [
        registrationId,
        courseId,
      ]);

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

      return {
        success: true,
        registration_id: registrationId,
        total_credits: totalCredits,
      };
    } catch (error) {
      await connection.rollback();

      console.error(error);

      reply.status(500);

      return {
        success: false,
        message: "Internal server error",
      };
    } finally {
      connection.release();
    }
  });
}

export default registrationRoutes;

import mysql from "mysql2/promise";
import dotenv from "dotenv";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config();

console.log(process.env.DB_HOST);
console.log(process.env.DB_USER);
console.log(process.env.DB_PASSWORD);

let pool;

const TOTAL_STUDENTS = 5000;
const TOTAL_COURSES = 50;

const COURSES_PER_STUDENT = 5;

async function executeSchema() {
  console.log("Execute database schema...");

  const schemaPath = path.join(__dirname, "database_schema.sql");

  const schema = fs.readFileSync(schemaPath, "utf-8");

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    multipleStatements: true,
  });

  await connection.query(schema);

  await connection.end();

  console.log("Database schema executed");
}

function randomLetterGrade() {
  const grades = ["A", "AB", "B", "BC", "C", "D"];

  return grades[Math.floor(Math.random() * grades.length)];
}

function randomNumericGrade() {
  return (Math.random() * 40 + 60).toFixed(2);
}

async function generateStudents() {
  console.log("Generate students...");

  const data = [];

  for (let i = 1; i <= TOTAL_STUDENTS; i++) {
    data.push([
      `2026${String(i).padStart(5, "0")}`,
      `Student ${i}`,
      `student${i}@campus.ac.id`,
    ]);
  }

  await pool.query(
    `
    INSERT INTO students (
      student_number,
      full_name,
      email
    )
    VALUES ?
    `,
    [data],
  );

  console.log("Students generated");
}

async function generateCourses() {
  console.log("Generate courses...");

  const data = [];

  for (let i = 1; i <= TOTAL_COURSES; i++) {
    data.push([
      `CS${String(i).padStart(3, "0")}`,
      `Course ${i}`,
      3,
      Math.ceil(i / 6),
    ]);
  }

  await pool.query(
    `
    INSERT INTO courses (
      course_code,
      course_name,
      credits,
      semester
    )
    VALUES ?
    `,
    [data],
  );

  console.log("Courses generated");
}

async function generateGrades() {
  console.log("Generate grades...");

  const data = [];

  for (let studentId = 1; studentId <= TOTAL_STUDENTS; studentId++) {
    const usedCourses = new Set();

    while (usedCourses.size < COURSES_PER_STUDENT) {
      const courseId = Math.floor(Math.random() * TOTAL_COURSES) + 1;

      if (!usedCourses.has(courseId)) {
        usedCourses.add(courseId);

        data.push([
          studentId,
          courseId,
          randomLetterGrade(),
          randomNumericGrade(),
        ]);
      }
    }
  }

  await pool.query(
    `
    INSERT INTO grades (
      student_id,
      course_id,
      letter_grade,
      numeric_grade
    )
    VALUES ?
    `,
    [data],
  );

  console.log("Grades generated");
}

async function generateCourseRegistrations() {
  console.log("Generate course registrations...");

  const registrationData = [];

  for (let studentId = 1; studentId <= TOTAL_STUDENTS; studentId++) {
    registrationData.push([studentId, "2025-1", COURSES_PER_STUDENT * 3]);
  }

  await pool.query(
    `
    INSERT INTO course_registrations (
      student_id,
      academic_term,
      total_credits
    )
    VALUES ?
    `,
    [registrationData],
  );

  console.log("Course registrations generated");

  console.log("Generate course registration details...");

  const detailData = [];

  for (
    let registrationId = 1;
    registrationId <= TOTAL_STUDENTS;
    registrationId++
  ) {
    const usedCourses = new Set();

    while (usedCourses.size < COURSES_PER_STUDENT) {
      const courseId = Math.floor(Math.random() * TOTAL_COURSES) + 1;

      if (!usedCourses.has(courseId)) {
        usedCourses.add(courseId);

        detailData.push([registrationId, courseId]);
      }
    }
  }

  await pool.query(
    `
    INSERT INTO course_registration_details (
      registration_id,
      course_id
    )
    VALUES ?
    `,
    [detailData],
  );

  console.log("Course registration details generated");
}

async function main() {
  try {
    console.log("Start generating dummy academic data...\n");

    await executeSchema();

    pool = mysql.createPool({
      host: process.env.DB_HOST,
      port: process.env.DB_PORT,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,

      waitForConnections: true,
      connectionLimit: 20,
    });

    await generateStudents();

    await generateCourses();

    await generateGrades();

    await generateCourseRegistrations();

    console.log("\nAll dummy data generated successfully");

    await pool.end();

    process.exit();
  } catch (error) {
    console.error(error);

    process.exit(1);
  }
}

main();

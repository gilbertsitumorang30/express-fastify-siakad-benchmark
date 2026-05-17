DROP DATABASE IF EXISTS sia_db;
CREATE DATABASE sia_db;
USE sia_db;

CREATE TABLE students (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    student_number VARCHAR(20) NOT NULL UNIQUE,

    full_name VARCHAR(100) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    course_code VARCHAR(20) NOT NULL UNIQUE,

    course_name VARCHAR(100) NOT NULL,

    credits INT NOT NULL,

    semester INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE grades (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    student_id BIGINT NOT NULL,

    course_id BIGINT NOT NULL,

    letter_grade CHAR(2) NOT NULL,

    numeric_grade DECIMAL(5,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_grades_student
        FOREIGN KEY (student_id)
        REFERENCES students(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_grades_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_student_course_grade
        UNIQUE (student_id, course_id)
);

-- COURSE REGISTRATION HEADER

CREATE TABLE course_registrations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    student_id BIGINT NOT NULL,

    academic_term VARCHAR(20) NOT NULL,

    total_credits INT NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_course_registrations_student
        FOREIGN KEY (student_id)
        REFERENCES students(id)
        ON DELETE CASCADE
);

-- COURSE REGISTRATION DETAILS

CREATE TABLE course_registration_details (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    registration_id BIGINT NOT NULL,

    course_id BIGINT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_registration_details_registration
        FOREIGN KEY (registration_id)
        REFERENCES course_registrations(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_registration_details_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_registration_course
        UNIQUE (registration_id, course_id)
);
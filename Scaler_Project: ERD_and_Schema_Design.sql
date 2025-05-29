-- Table: Roles
CREATE TABLE Roles (
    role_id BIGSERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table: Users
CREATE TABLE Users (
    user_id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(255)
);

-- Table: User_Roles
CREATE TABLE User_Roles (
    user_role_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    role_id BIGINT NOT NULL REFERENCES Roles(role_id) ON DELETE CASCADE,
    UNIQUE (user_id, role_id)
);

-- Table: Courses
CREATE TABLE Courses (
    course_id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    instructor_id BIGINT REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Table: Modules
CREATE TABLE Modules (
    module_id BIGSERIAL PRIMARY KEY,
    course_id BIGINT NOT NULL REFERENCES Courses(course_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL
);

-- Table: Lessons
CREATE TABLE Lessons (
    lesson_id BIGSERIAL PRIMARY KEY,
    module_id BIGINT NOT NULL REFERENCES Modules(module_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL
);

-- Table: Enrollments
CREATE TABLE Enrollments (
    enrollment_id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    course_id BIGINT NOT NULL REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE (student_id, course_id)
);

-- Table: Lesson_Progress
CREATE TABLE Lesson_Progress (
    progress_id BIGSERIAL PRIMARY KEY,
    enrollment_id BIGINT NOT NULL REFERENCES Enrollments(enrollment_id) ON DELETE CASCADE,
    lesson_id BIGINT NOT NULL REFERENCES Lessons(lesson_id) ON DELETE CASCADE,
    UNIQUE (enrollment_id, lesson_id)
);

-- Table: Assignments
CREATE TABLE Assignments (
    assignment_id BIGSERIAL PRIMARY KEY,
    lesson_id BIGINT NOT NULL REFERENCES Lessons(lesson_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT
);

-- Table: Assignment_Submissions
CREATE TABLE Assignment_Submissions (
    submission_id BIGSERIAL PRIMARY KEY,
    assignment_id BIGINT NOT NULL REFERENCES Assignments(assignment_id) ON DELETE CASCADE,
    student_id BIGINT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    attempt_number INTEGER DEFAULT 1,
    UNIQUE (assignment_id, student_id, attempt_number)
);

-- Sample Data for Roles
INSERT INTO Roles (role_name) VALUES
('admin'),
('instructor'),
('student'),
('staff'),
('mentor');

-- Sample Data for Users
-- We'll create a mix of users who can act as instructors and students.
INSERT INTO Users (username, email, full_name) VALUES
('akash_i', 'akash.i@example.com', 'Akash Sharma'),        -- Instructor 1
('priya_i', 'priya.i@example.com', 'Priya Singh'),        -- Instructor 2
('rohan_s', 'rohan.s@example.com', 'Rohan Verma'),        -- Student 1
('isha_s', 'isha.s@example.com', 'Isha Gupta'),          -- Student 2
('kiran_s', 'kiran.s@example.com', 'Kiran Kumar');        -- Student 3

-- Sample Data for User_Roles
-- Assign roles to the users we just created.
INSERT INTO User_Roles (user_id, role_id) VALUES
((SELECT user_id FROM Users WHERE username = 'akash_i'), (SELECT role_id FROM Roles WHERE role_name = 'instructor')),
((SELECT user_id FROM Users WHERE username = 'priya_i'), (SELECT role_id FROM Roles WHERE role_name = 'instructor')),
((SELECT user_id FROM Users WHERE username = 'rohan_s'), (SELECT role_id FROM Roles WHERE role_name = 'student')),
((SELECT user_id FROM Users WHERE username = 'isha_s'), (SELECT role_id FROM Roles WHERE role_name = 'student')),
((SELECT user_id FROM Users WHERE username = 'kiran_s'), (SELECT role_id FROM Roles WHERE role_name = 'student'));

-- Sample Data for Courses
-- Assign instructors to these courses.
INSERT INTO Courses (title, description, instructor_id) VALUES
('Backend Dev with Node.js', 'Build robust APIs and server-side applications.', (SELECT user_id FROM Users WHERE username = 'akash_i')),
('Data Science Fundamentals', 'Introduction to data analysis, machine learning basics.', (SELECT user_id FROM Users WHERE username = 'priya_i')),
('Fullstack Web Dev (MERN)', 'Learn MongoDB, Express, React, Node.js.', (SELECT user_id FROM Users WHERE username = 'akash_i')),
('Competitive Programming Basics', 'Improve problem-solving skills for coding contests.', (SELECT user_id FROM Users WHERE username = 'priya_i')),
('Cloud Computing with AWS', 'Explore fundamental AWS services and concepts.', (SELECT user_id FROM Users WHERE username = 'akash_i'));

-- Sample Data for Modules
-- Modules are linked to specific courses.
INSERT INTO Modules (course_id, title) VALUES
((SELECT course_id FROM Courses WHERE title = 'Backend Dev with Node.js'), 'Module 1: Node.js Core Concepts'),
((SELECT course_id FROM Courses WHERE title = 'Backend Dev with Node.js'), 'Module 2: Express.js Framework'),
((SELECT course_id FROM Courses WHERE title = 'Data Science Fundamentals'), 'Module 1: Python for Data Science'),
((SELECT course_id FROM Courses WHERE title = 'Fullstack Web Dev (MERN)'), 'Module 1: React Basics'),
((SELECT course_id FROM Courses WHERE title = 'Competitive Programming Basics'), 'Module 1: Time & Space Complexity');

-- Sample Data for Lessons
-- Lessons are linked to specific modules.
INSERT INTO Lessons (module_id, title) VALUES
((SELECT module_id FROM Modules WHERE title = 'Module 1: Node.js Core Concepts'), 'Lesson 1.1: Asynchronous JavaScript'),
((SELECT module_id FROM Modules WHERE title = 'Module 1: Node.js Core Concepts'), 'Lesson 1.2: Node.js File System'),
((SELECT module_id FROM Modules WHERE title = 'Module 2: Express.js Framework'), 'Lesson 2.1: Routes and Middleware'),
((SELECT module_id FROM Modules WHERE title = 'Module 1: Python for Data Science'), 'Lesson 1.1: NumPy and Pandas'),
((SELECT module_id FROM Modules WHERE title = 'Module 1: React Basics'), 'Lesson 1.1: Components and Props');

-- Sample Data for Enrollments
-- Enroll students in courses.
INSERT INTO Enrollments (student_id, course_id) VALUES
((SELECT user_id FROM Users WHERE username = 'rohan_s'), (SELECT course_id FROM Courses WHERE title = 'Backend Dev with Node.js')),
((SELECT user_id FROM Users WHERE username = 'isha_s'), (SELECT course_id FROM Courses WHERE title = 'Data Science Fundamentals')),
((SELECT user_id FROM Users WHERE username = 'rohan_s'), (SELECT course_id FROM Courses WHERE title = 'Fullstack Web Dev (MERN)')),
((SELECT user_id FROM Users WHERE username = 'kiran_s'), (SELECT course_id FROM Courses WHERE title = 'Backend Dev with Node.js')),
((SELECT user_id FROM Users WHERE username = 'isha_s'), (SELECT course_id FROM Courses WHERE title = 'Competitive Programming Basics'));

-- Sample Data for Lesson_Progress
-- Track lesson progress for enrolled students.
INSERT INTO Lesson_Progress (enrollment_id, lesson_id) VALUES
((SELECT enrollment_id FROM Enrollments WHERE student_id = (SELECT user_id FROM Users WHERE username = 'rohan_s') AND course_id = (SELECT course_id FROM Courses WHERE title = 'Backend Dev with Node.js')), (SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.1: Asynchronous JavaScript')),
((SELECT enrollment_id FROM Enrollments WHERE student_id = (SELECT user_id FROM Users WHERE username = 'rohan_s') AND course_id = (SELECT course_id FROM Courses WHERE title = 'Backend Dev with Node.js')), (SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.2: Node.js File System')),
((SELECT enrollment_id FROM Enrollments WHERE student_id = (SELECT user_id FROM Users WHERE username = 'isha_s') AND course_id = (SELECT course_id FROM Courses WHERE title = 'Data Science Fundamentals')), (SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.1: NumPy and Pandas')),
((SELECT enrollment_id FROM Enrollments WHERE student_id = (SELECT user_id FROM Users WHERE username = 'kiran_s') AND course_id = (SELECT course_id FROM Courses WHERE title = 'Backend Dev with Node.js')), (SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.1: Asynchronous JavaScript')),
((SELECT enrollment_id FROM Enrollments WHERE student_id = (SELECT user_id FROM Users WHERE username = 'rohan_s') AND course_id = (SELECT course_id FROM Courses WHERE title = 'Fullstack Web Dev (MERN)')), (SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.1: Components and Props'));

-- Sample Data for Assignments
-- Assignments linked to specific lessons.
INSERT INTO Assignments (lesson_id, title, description) VALUES
((SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.1: Asynchronous JavaScript'), 'Callback Hell Refactor', 'Refactor nested callbacks into Promises.'),
((SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.2: Node.js File System'), 'File System Operations', 'Create a script to read and write files.'),
((SELECT lesson_id FROM Lessons WHERE title = 'Lesson 2.1: Routes and Middleware'), 'Basic Express API', 'Build a simple API with a few routes.'),
((SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.1: NumPy and Pandas'), 'Data Filtering Exercise', 'Filter and manipulate a dataset using Pandas.'),
((SELECT lesson_id FROM Lessons WHERE title = 'Lesson 1.1: Components and Props'), 'User Profile Card Component', 'Build a React component for a user profile.');

-- Sample Data for Assignment_Submissions
-- Student submissions for assignments, including multiple attempts.
INSERT INTO Assignment_Submissions (assignment_id, student_id, attempt_number) VALUES
((SELECT assignment_id FROM Assignments WHERE title = 'Callback Hell Refactor'), (SELECT user_id FROM Users WHERE username = 'rohan_s'), 1),
((SELECT assignment_id FROM Assignments WHERE title = 'File System Operations'), (SELECT user_id FROM Users WHERE username = 'rohan_s'), 1),
((SELECT assignment_id FROM Assignments WHERE title = 'File System Operations'), (SELECT user_id FROM Users WHERE username = 'rohan_s'), 2), -- Rohan's second attempt
((SELECT assignment_id FROM Assignments WHERE title = 'Data Filtering Exercise'), (SELECT user_id FROM Users WHERE username = 'isha_s'), 1),
((SELECT assignment_id FROM Assignments WHERE title = 'Callback Hell Refactor'), (SELECT user_id FROM Users WHERE username = 'kiran_s'), 1);

-- TRUNCATE TABLES TO CLEAR EXISTING DATA AND RESET SERIAL IDs
TRUNCATE TABLE Assignment_Submissions RESTART IDENTITY CASCADE;
TRUNCATE TABLE Assignments RESTART IDENTITY CASCADE;
TRUNCATE TABLE Lesson_Progress RESTART IDENTITY CASCADE;
TRUNCATE TABLE Enrollments RESTART IDENTITY CASCADE;
TRUNCATE TABLE Lessons RESTART IDENTITY CASCADE;
TRUNCATE TABLE Modules RESTART IDENTITY CASCADE;
TRUNCATE TABLE Courses RESTART IDENTITY CASCADE;
TRUNCATE TABLE User_Roles RESTART IDENTITY CASCADE;
TRUNCATE TABLE Users RESTART IDENTITY CASCADE;
TRUNCATE TABLE Roles RESTART IDENTITY CASCADE; -- Roles must be last in this cascade list or done separately if no other tables reference it directly via FKs.
-- The order above is safest, going from child tables back up to parent tables.
-- The CASCADE keyword handles dependent foreign key relationships automatically.


with CTE as

(select * from Courses as c
join Enrollments as e
on c.course_id = e.course_id)

select title,instructor_id, sum(student_id) from CTE
group by title, instructor_id

select * from Courses

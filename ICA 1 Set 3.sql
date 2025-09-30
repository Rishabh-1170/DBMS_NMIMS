-- Create Database
CREATE DATABASE UniversityManagement;
USE UniversityManagement;

-- Create Tables
CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    DOB DATE,
    Gender VARCHAR(10),
    DeptID INT,
    Email VARCHAR(100)
);

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(50),
    HOD VARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    CourseName VARCHAR(100),
    DeptID INT,
    Credits INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    DeptID INT,
    Email VARCHAR(100),
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    Semester VARCHAR(20),
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert Sample Data
INSERT INTO Departments (DeptName, HOD) VALUES
('Computer Science', 'Dr. Rajesh Kumar'),
('Physics', 'Dr. Meera Sharma'),
('Mathematics', 'Dr. Anil Patel'),
('Chemistry', 'Dr. Sunita Reddy');

INSERT INTO Students (Name, DOB, Gender, DeptID, Email) VALUES
('Aarav Sharma', '2002-03-15', 'Male', 1, 'aarav.sharma@uni.edu'),
('Priya Patel', '2001-07-20', 'Female', 1, 'priya.patel@uni.edu'),
('Rohan Kumar', '2003-01-10', 'Male', 2, 'rohan.kumar@uni.edu'),
('Sneha Gupta', '2002-11-25', 'Female', 3, 'sneha.gupta@uni.edu'),
('Ankit Singh', '2001-05-30', 'Male', 4, 'ankit.singh@uni.edu');

INSERT INTO Courses (CourseName, DeptID, Credits) VALUES
('Database Systems', 1, 4),
('Data Structures', 1, 3),
('Quantum Physics', 2, 4),
('Calculus', 3, 3),
('Organic Chemistry', 4, 4);

INSERT INTO Faculty (Name, DeptID, Email) VALUES
('Dr. Rajesh Kumar', 1, 'rajesh.kumar@uni.edu'),
('Dr. Meera Sharma', 2, 'meera.sharma@uni.edu'),
('Dr. Anil Patel', 3, 'anil.patel@uni.edu'),
('Dr. Sunita Reddy', 4, 'sunita.reddy@uni.edu');

INSERT INTO Enrollments (StudentID, CourseID, Semester, Grade) VALUES
(1, 1, 'Fall 2024', 'A'),
(1, 2, 'Fall 2024', 'B+'),
(2, 1, 'Fall 2024', 'A-'),
(3, 3, 'Fall 2024', 'B'),
(4, 4, 'Fall 2024', 'A');

-- 20 Queries
-- 1. List students in 'Computer Science' department
SELECT s.* FROM Students s
JOIN Departments d ON s.DeptID = d.DeptID
WHERE d.DeptName = 'Computer Science';

-- 2. Show courses with more than 3 credits
SELECT * FROM Courses WHERE Credits > 3;

-- 3. Find students born after 2000
SELECT * FROM Students WHERE DOB > '2000-12-31';

-- 4. Show average grade per course
SELECT c.CourseName, AVG(
    CASE Grade 
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        ELSE 2.0
    END
) as AverageGrade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName;

-- 5. List faculty members in 'Physics' department
SELECT f.* FROM Faculty f
JOIN Departments d ON f.DeptID = d.DeptID
WHERE d.DeptName = 'Physics';

-- 6. Count total students per department
SELECT d.DeptName, COUNT(s.StudentID) as TotalStudents
FROM Departments d
LEFT JOIN Students s ON d.DeptID = s.DeptID
GROUP BY d.DeptID, d.DeptName;

-- 7. Show courses taught by a given faculty
SELECT c.* FROM Courses c
JOIN Faculty f ON c.DeptID = f.DeptID
WHERE f.Name = 'Dr. Rajesh Kumar';

-- 8. List students with no enrollments
SELECT s.* FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.EnrollmentID IS NULL;

-- 9. Show top 3 scorers in a course
SELECT s.Name, e.Grade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID = 1
ORDER BY 
    CASE Grade 
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        ELSE 2.0
    END DESC
LIMIT 3;

-- 10. Display students enrolled in more than 4 courses
SELECT s.Name, COUNT(e.EnrollmentID) as CourseCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name
HAVING COUNT(e.EnrollmentID) > 4;

-- 11. Find courses with no enrollments
SELECT c.* FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.EnrollmentID IS NULL;

-- 12. Show department names with total faculty
SELECT d.DeptName, COUNT(f.FacultyID) as TotalFaculty
FROM Departments d
LEFT JOIN Faculty f ON d.DeptID = f.DeptID
GROUP BY d.DeptID, d.DeptName;

-- 13. List all courses taken by a specific student
SELECT c.CourseName, e.Semester, e.Grade
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.StudentID = 1;

-- 14. Find students whose name starts with 'S'
SELECT * FROM Students WHERE Name LIKE 'S%';

-- 15. Show the youngest student
SELECT * FROM Students ORDER BY DOB DESC LIMIT 1;

-- 16. List students and their average grade
SELECT s.Name, AVG(
    CASE Grade 
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        ELSE 2.0
    END
) as AverageGrade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name;

-- 17. Find departments without students
SELECT d.* FROM Departments d
LEFT JOIN Students s ON d.DeptID = s.DeptID
WHERE s.StudentID IS NULL;

-- 18. Show faculty email addresses
SELECT Name, Email FROM Faculty;

-- 19. List students enrolled in 'Mathematics' course
SELECT s.Name 
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName LIKE '%Mathematics%' OR c.CourseName LIKE '%Math%';

-- 20. Show total credits taken by each student
SELECT s.Name, SUM(c.Credits) as TotalCredits
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY s.StudentID, s.Name;
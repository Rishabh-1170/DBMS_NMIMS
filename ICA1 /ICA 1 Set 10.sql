-- Create Database
CREATE DATABASE ELearning;
USE ELearning;

-- Create Tables
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    DurationWeeks INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Specialty VARCHAR(50)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Assignments (
    AssignmentID INT PRIMARY KEY AUTO_INCREMENT,
    CourseID INT,
    Title VARCHAR(200),
    DueDate DATE,
    MaxMarks INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- NEW TABLE: Submissions to track assignment submissions
CREATE TABLE Submissions (
    SubmissionID INT PRIMARY KEY AUTO_INCREMENT,
    AssignmentID INT,
    StudentID INT,
    SubmissionDate DATE,
    MarksObtained INT,
    Status VARCHAR(20),
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- Insert Sample Data
INSERT INTO Courses (Title, Category, DurationWeeks, Price) VALUES
('Data Science Fundamentals', 'Data Science', 12, 12000.00),
('Python Programming', 'Programming', 8, 8000.00),
('Machine Learning', 'AI', 10, 15000.00),
('Web Development', 'Programming', 6, 6000.00),
('Business Analytics', 'Data Science', 8, 10000.00),
('Advanced AI', 'AI', 12, 18000.00);

INSERT INTO Instructors (Name, Email, Specialty) VALUES
('Dr. Rajesh Kumar', 'rajesh.kumar@edu.com', 'Data Science'),
('Prof. Priya Sharma', 'priya.sharma@edu.com', 'Python'),
('Dr. Amit Patel', 'amit.patel@edu.com', 'AI'),
('Ms. Sneha Reddy', 'sneha.reddy@edu.com', 'Web Development'),
('Mr. Rohan Singh', 'rohan.singh@edu.com', 'Analytics');

INSERT INTO Students (Name, Email, City) VALUES
('Aarav Sharma', 'aarav.sharma@email.com', 'Mumbai'),
('Priya Patel', 'priya.patel@email.com', 'Delhi'),
('Rohan Kumar', 'rohan.kumar@email.com', 'Bangalore'),
('Sneha Gupta', 'sneha.gupta@email.com', 'Mumbai'),
('Ankit Singh', 'ankit.singh@email.com', 'Chennai'),
('Neha Reddy', 'neha.reddy@email.com', 'Hyderabad');

INSERT INTO Enrollments (StudentID, CourseID, EnrollDate, Status) VALUES
(1, 1, '2024-01-15', 'Active'),
(2, 2, '2024-01-16', 'Active'),
(3, 3, '2024-01-17', 'Completed'),
(4, 1, '2024-01-18', 'Active'),
(5, 4, '2024-01-19', 'Dropped'),
(1, 2, '2024-01-20', 'Active'),
(2, 1, '2024-01-21', 'Active'),
(6, 3, '2024-01-22', 'Active');

INSERT INTO Assignments (CourseID, Title, DueDate, MaxMarks) VALUES
(1, 'Data Analysis Project', '2024-02-15', 100),
(2, 'Python Basics Quiz', '2024-02-10', 50),
(3, 'ML Model Implementation', '2024-02-20', 100),
(4, 'Website Development', '2024-02-12', 80),
(1, 'Statistics Assignment', '2024-02-08', 60),
(2, 'Advanced Python Project', '2024-02-25', 100),
(3, 'Neural Networks Assignment', '2024-02-18', 75);

-- Insert Sample Submission Data
INSERT INTO Submissions (AssignmentID, StudentID, SubmissionDate, MarksObtained, Status) VALUES
-- On-time submissions
(1, 1, '2024-02-14', 85, 'Graded'),
(1, 4, '2024-02-13', 92, 'Graded'),
(2, 2, '2024-02-09', 45, 'Graded'),
(2, 1, '2024-02-08', 48, 'Graded'),
(3, 3, '2024-02-19', 78, 'Graded'),
(3, 6, '2024-02-18', 82, 'Graded'),

-- Late submissions
(4, 5, '2024-02-15', 65, 'Graded'), -- Due date was 2024-02-12
(5, 1, '2024-02-10', 52, 'Graded'), -- Due date was 2024-02-08
(5, 4, '2024-02-09', 58, 'Graded'), -- Due date was 2024-02-08

-- Pending submissions
(6, 2, NULL, NULL, 'Pending'),
(7, 3, NULL, NULL, 'Pending'),

-- More submissions for better analysis
(1, 2, '2024-02-12', 88, 'Graded'),
(2, 6, '2024-02-07', 42, 'Graded'),
(3, 1, '2024-02-17', 75, 'Graded');

-- 20 Queries (Now with meaningful output for all queries)
-- 1. List courses in 'Data Science' category
SELECT * FROM Courses WHERE Category = 'Data Science';

-- 2. Show instructors specializing in 'Python'
SELECT * FROM Instructors WHERE Specialty LIKE '%Python%';

-- 3. Find students from 'Mumbai'
SELECT * FROM Students WHERE City = 'Mumbai';

-- 4. List enrollments in the last month
SELECT * FROM Enrollments 
WHERE EnrollDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 5. Show courses with duration more than 8 weeks
SELECT * FROM Courses WHERE DurationWeeks > 8;

-- 6. Find top 3 most expensive courses
SELECT * FROM Courses ORDER BY Price DESC LIMIT 3;

-- 7. Show students enrolled in a given course
SELECT s.Name, s.Email 
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID = 1 AND e.Status = 'Active';

-- 8. List instructors teaching multiple courses
SELECT i.Name, COUNT(DISTINCT c.CourseID) as CourseCount
FROM Instructors i
JOIN Courses c ON i.Specialty = c.Category
GROUP BY i.InstructorID, i.Name
HAVING COUNT(DISTINCT c.CourseID) > 1;

-- 9. Show assignments with due date in next week
SELECT a.*, c.Title as CourseName
FROM Assignments a
JOIN Courses c ON a.CourseID = c.CourseID
WHERE a.DueDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);

-- 10. Find students who completed all assignments in a course (NOW WORKS!)
SELECT s.StudentID, s.Name, c.CourseID, c.Title as CourseName,
       COUNT(DISTINCT a.AssignmentID) as TotalAssignments,
       COUNT(DISTINCT sub.AssignmentID) as SubmittedAssignments
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Assignments a ON c.CourseID = a.CourseID
LEFT JOIN Submissions sub ON a.AssignmentID = sub.AssignmentID AND sub.StudentID = s.StudentID
WHERE e.Status = 'Active'
GROUP BY s.StudentID, s.Name, c.CourseID, c.Title
HAVING TotalAssignments = SubmittedAssignments AND TotalAssignments > 0;

-- 11. Show average marks per course (NOW WORKS!)
SELECT c.CourseID, c.Title, 
       AVG(sub.MarksObtained) as AverageMarks,
       COUNT(sub.SubmissionID) as TotalSubmissions
FROM Courses c
JOIN Assignments a ON c.CourseID = a.CourseID
JOIN Submissions sub ON a.AssignmentID = sub.AssignmentID
WHERE sub.MarksObtained IS NOT NULL
GROUP BY c.CourseID, c.Title;

-- 12. Find students without enrollments
SELECT s.* FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.EnrollmentID IS NULL;

-- 13. Show total enrollments per course
SELECT c.Title, COUNT(e.EnrollmentID) as TotalEnrollments
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.Title;

-- 14. Display instructors with no courses assigned
SELECT i.* FROM Instructors i
LEFT JOIN Courses c ON i.Specialty = c.Category
WHERE c.CourseID IS NULL;

-- 15. Show students with more than 3 enrollments
SELECT s.Name, COUNT(e.EnrollmentID) as EnrollmentCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name
HAVING COUNT(e.EnrollmentID) > 3;

-- 16. Find courses with no students
SELECT c.* FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.EnrollmentID IS NULL;

-- 17. Show most popular course
SELECT c.Title, COUNT(e.EnrollmentID) as EnrollmentCount
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.Title
ORDER BY EnrollmentCount DESC LIMIT 1;

-- 18. List assignments per course
SELECT c.Title, a.Title as Assignment, a.DueDate, a.MaxMarks
FROM Courses c
JOIN Assignments a ON c.CourseID = a.CourseID
ORDER BY c.Title, a.DueDate;

-- 19. Show students who submitted assignments late (NOW WORKS!)
SELECT s.StudentID, s.Name, a.Title as Assignment, 
       a.DueDate, sub.SubmissionDate,
       DATEDIFF(sub.SubmissionDate, a.DueDate) as DaysLate
FROM Students s
JOIN Submissions sub ON s.StudentID = sub.StudentID
JOIN Assignments a ON sub.AssignmentID = a.AssignmentID
WHERE sub.SubmissionDate > a.DueDate
ORDER BY DaysLate DESC;

-- 20. Display courses and their instructor names
SELECT c.Title, c.Category, i.Name as Instructor
FROM Courses c
JOIN Instructors i ON c.Category = i.Specialty;

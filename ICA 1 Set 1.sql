-- Create Database
CREATE DATABASE HospitalManagement;
USE HospitalManagement;

-- Create Tables
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Specialization VARCHAR(50),
    Phone VARCHAR(15),
    JoiningDate DATE
);

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    DOB DATE,
    Gender VARCHAR(10),
    Phone VARCHAR(15)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    Date DATE,
    Time TIME,
    Status VARCHAR(20),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(50),
    Location VARCHAR(100)
);

CREATE TABLE Bills (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    Amount DECIMAL(10,2),
    BillDate DATE,
    PaymentStatus VARCHAR(20),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Insert Sample Data (5+ records each table)
INSERT INTO Doctors (Name, Specialization, Phone, JoiningDate) VALUES
('Dr. Sharma', 'Cardiology', '9876543210', '2019-03-15'),
('Dr. Patel', 'Neurology', '8765432109', '2020-07-20'),
('Dr. Kumar', 'Cardiology', '7654321098', '2018-11-10'),
('Dr. Gupta', 'Pediatrics', '6543210987', '2021-01-05'),
('Dr. Singh', 'Orthopedics', '9432109876', '2017-09-25');

INSERT INTO Patients (Name, DOB, Gender, Phone) VALUES
('Rahul Verma', '1985-05-15', 'Male', '9123456780'),
('Priya Singh', '1978-12-20', 'Female', '8234567891'),
('Amit Kumar', '1960-03-10', 'Male', '7345678902'),
('Sneha Reddy', '1955-08-25', 'Female', '6456789013'),
('Rajesh Nair', '1990-11-30', 'Male', '5567890124');

INSERT INTO Appointments (PatientID, DoctorID, Date, Time, Status) VALUES
(1, 1, '2024-01-15', '10:00:00', 'Completed'),
(2, 2, '2024-01-16', '11:30:00', 'Pending'),
(3, 1, '2024-01-17', '09:15:00', 'Completed'),
(4, 3, '2024-01-18', '14:00:00', 'Cancelled'),
(5, 4, '2024-01-19', '16:45:00', 'Completed');

INSERT INTO Departments (DeptName, Location) VALUES
('Cardiology', 'First Floor'),
('Neurology', 'Second Floor'),
('Pediatrics', 'Ground Floor'),
('Orthopedics', 'First Floor'),
('Emergency', 'Ground Floor');

INSERT INTO Bills (PatientID, Amount, BillDate, PaymentStatus) VALUES
(1, 5000.00, '2024-01-15', 'Paid'),
(2, 7500.00, '2024-01-16', 'Pending'),
(3, 3000.00, '2024-01-17', 'Paid'),
(4, 12000.00, '2024-01-18', 'Pending'),
(5, 4500.00, '2024-01-19', 'Paid');

-- 20 Queries
-- 1. List doctors with specialization 'Cardiology'
SELECT * FROM Doctors WHERE Specialization = 'Cardiology';

-- 2. Show all patients above 60 years old
SELECT * FROM Patients WHERE TIMESTAMPDIFF(YEAR, DOB, CURDATE()) > 60;

-- 3. Find appointments scheduled for today
SELECT * FROM Appointments WHERE Date = CURDATE();

-- 4. Count total patients per department
SELECT d.DeptName, COUNT(DISTINCT a.PatientID) as TotalPatients
FROM Departments d
LEFT JOIN Doctors doc ON d.DeptName = doc.Specialization
LEFT JOIN Appointments a ON doc.DoctorID = a.DoctorID
GROUP BY d.DeptName;

-- 5. Show patients assigned to a specific doctor
SELECT p.Name as PatientName, p.Phone 
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.DoctorID = 1;

-- 6. List bills with amount greater than 5000
SELECT * FROM Bills WHERE Amount > 5000;

-- 7. Display unpaid bills
SELECT * FROM Bills WHERE PaymentStatus = 'Pending';

-- 8. Show the doctor with the maximum appointments
SELECT d.Name, COUNT(a.AppointmentID) as AppointmentCount
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.Name
ORDER BY AppointmentCount DESC LIMIT 1;

-- 9. List patients without appointments
SELECT p.* FROM Patients p
LEFT JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.AppointmentID IS NULL;

-- 10. Find oldest patient
SELECT * FROM Patients ORDER BY DOB ASC LIMIT 1;

-- 11. Show average bill amount per department
SELECT doc.Specialization, AVG(b.Amount) as AverageBill
FROM Doctors doc
JOIN Appointments a ON doc.DoctorID = a.DoctorID
JOIN Bills b ON a.PatientID = b.PatientID
GROUP BY doc.Specialization;

-- 12. List doctors joined after 2020
SELECT * FROM Doctors WHERE JoiningDate > '2020-01-01';

-- 13. Find patients whose name starts with 'A'
SELECT * FROM Patients WHERE Name LIKE 'A%';

-- 14. Show all cancelled appointments
SELECT * FROM Appointments WHERE Status = 'Cancelled';

-- 15. Count appointments per day
SELECT Date, COUNT(*) as TotalAppointments
FROM Appointments
GROUP BY Date;

-- 16. Find patients who visited more than 3 times
SELECT p.Name, COUNT(a.AppointmentID) as VisitCount
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.Name
HAVING COUNT(a.AppointmentID) > 3;

-- 17. Show department names with their doctors
SELECT d.DeptName, doc.Name as DoctorName
FROM Departments d
JOIN Doctors doc ON d.DeptName = doc.Specialization;

-- 18. Find doctors working in 'Neurology'
SELECT * FROM Doctors WHERE Specialization = 'Neurology';

-- 19. Display total bills for each patient
SELECT p.Name, SUM(b.Amount) as TotalBills
FROM Patients p
JOIN Bills b ON p.PatientID = b.PatientID
GROUP BY p.PatientID, p.Name;

-- 20. Show top 5 highest billing patients
SELECT p.Name, SUM(b.Amount) as TotalBilled
FROM Patients p
JOIN Bills b ON p.PatientID = b.PatientID
GROUP BY p.PatientID, p.Name
ORDER BY TotalBilled DESC LIMIT 5;
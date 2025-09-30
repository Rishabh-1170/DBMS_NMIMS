-- Create Database
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

-- Create Tables
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Nationality VARCHAR(50)
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(200) NOT NULL,
    AuthorID INT,
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(200)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    MemberID INT,
    IssueDate DATE,
    ReturnDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE Fines (
    FineID INT PRIMARY KEY AUTO_INCREMENT,
    LoanID INT,
    Amount DECIMAL(10,2),
    PaymentStatus VARCHAR(20),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- Insert Sample Data
INSERT INTO Authors (Name, Nationality) VALUES
('Ruskin Bond', 'Indian'),
('J.K. Rowling', 'British'),
('Chetan Bhagat', 'Indian'),
('Stephen King', 'American'),
('Amish Tripathi', 'Indian');

INSERT INTO Books (Title, AuthorID, Category, Price, Stock) VALUES
('The Blue Umbrella', 1, 'Fiction', 250.00, 10),
('Harry Potter and the Philosopher''s Stone', 2, 'Fantasy', 650.00, 5),
('Five Point Someone', 3, 'Fiction', 299.00, 8),
('The Shining', 4, 'Horror', 450.00, 12),
('The Immortals of Meluha', 5, 'Mythology', 350.00, 6);

INSERT INTO Members (Name, Email, Phone, Address) VALUES
('Aarav Sharma', 'aarav.sharma@email.com', '9876543210', 'Mumbai'),
('Priya Patel', 'priya.patel@email.com', '8765432109', 'Delhi'),
('Rohan Kumar', 'rohan.kumar@email.com', '7654321098', 'Bangalore'),
('Sneha Gupta', 'sneha.gupta@email.com', '6543210987', 'Chennai'),
('Ankit Singh', 'ankit.singh@email.com', '9432109876', 'Mumbai');

INSERT INTO Loans (BookID, MemberID, IssueDate, ReturnDate, Status) VALUES
(1, 1, '2024-01-15', '2024-01-30', 'Returned'),
(2, 2, '2024-01-20', '2024-02-04', 'Overdue'),
(3, 3, '2024-01-25', '2024-02-09', 'Active'),
(4, 4, '2024-02-01', '2024-02-16', 'Active'),
(5, 5, '2024-02-05', '2024-02-20', 'Active');

INSERT INTO Fines (LoanID, Amount, PaymentStatus) VALUES
(2, 50.00, 'Unpaid'),
(1, 20.00, 'Paid'),
(3, 30.00, 'Unpaid');

-- 20 Queries
-- 1. List books in 'Science Fiction' category
SELECT * FROM Books WHERE Category = 'Science Fiction';

-- 2. Show books with stock less than 5
SELECT * FROM Books WHERE Stock < 5;

-- 3. Find members with overdue books
SELECT m.Name, l.IssueDate, l.ReturnDate 
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
WHERE l.Status = 'Overdue';

-- 4. Show top 3 most expensive books
SELECT * FROM Books ORDER BY Price DESC LIMIT 3;

-- 5. List all authors from 'India'
SELECT * FROM Authors WHERE Nationality = 'Indian';

-- 6. Show books written by a given author
SELECT b.* FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
WHERE a.Name = 'Ruskin Bond';

-- 7. Count total books per category
SELECT Category, COUNT(BookID) as TotalBooks
FROM Books
GROUP BY Category;

-- 8. Find members who borrowed more than 5 books
SELECT m.Name, COUNT(l.LoanID) as BooksBorrowed
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
GROUP BY m.MemberID, m.Name
HAVING COUNT(l.LoanID) > 5;

-- 9. Show loans with status 'Returned'
SELECT * FROM Loans WHERE Status = 'Returned';

-- 10. Display members who never borrowed any book
SELECT m.* FROM Members m
LEFT JOIN Loans l ON m.MemberID = l.MemberID
WHERE l.LoanID IS NULL;

-- 11. List all unpaid fines
SELECT f.*, m.Name as MemberName
FROM Fines f
JOIN Loans l ON f.LoanID = l.LoanID
JOIN Members m ON l.MemberID = m.MemberID
WHERE f.PaymentStatus = 'Unpaid';

-- 12. Show total fines paid per member
SELECT m.Name, SUM(f.Amount) as TotalFinesPaid
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
JOIN Fines f ON l.LoanID = f.LoanID
WHERE f.PaymentStatus = 'Paid'
GROUP BY m.MemberID, m.Name;

-- 13. Find books issued in the last month
SELECT b.Title, m.Name, l.IssueDate
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
JOIN Members m ON l.MemberID = m.MemberID
WHERE l.IssueDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 14. Show members who borrowed books in a specific category
SELECT DISTINCT m.Name
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
JOIN Books b ON l.BookID = b.BookID
WHERE b.Category = 'Fiction';

-- 15. Find authors who wrote more than 3 books
SELECT a.Name, COUNT(b.BookID) as BookCount
FROM Authors a
JOIN Books b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorID, a.Name
HAVING COUNT(b.BookID) > 3;

-- 16. List books with price between 200 and 500
SELECT * FROM Books WHERE Price BETWEEN 200 AND 500;

-- 17. Show average fine amount
SELECT AVG(Amount) as AverageFine FROM Fines;

-- 18. Find members with phone numbers starting with '9'
SELECT * FROM Members WHERE Phone LIKE '9%';

-- 19. Display all loans with book and member details
SELECT l.LoanID, b.Title, m.Name, l.IssueDate, l.ReturnDate, l.Status
FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Members m ON l.MemberID = m.MemberID;

-- 20. Show books whose title contains 'History'
SELECT * FROM Books WHERE Title LIKE '%History%';
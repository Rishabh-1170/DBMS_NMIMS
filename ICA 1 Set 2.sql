-- Create Database
CREATE DATABASE OnlineBookstore;
USE OnlineBookstore;

-- Create Tables
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(50),
    DOB DATE
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(200) NOT NULL,
    AuthorID INT,
    CategoryID INT,
    Price DECIMAL(10,2),
    Stock INT,
    PublishedYear INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(200)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert Sample Data
INSERT INTO Authors (Name, Country, DOB) VALUES
('J.K. Rowling', 'UK', '1965-07-31'),
('George R.R. Martin', 'USA', '1948-09-20'),
('Ruskin Bond', 'India', '1934-05-19'),
('Chetan Bhagat', 'India', '1974-04-22'),
('Stephen King', 'USA', '1947-09-21'),
('Amish Tripathi', 'India', '1974-10-18');

INSERT INTO Categories (CategoryName) VALUES
('Fiction'),
('Non-Fiction'),
('Science Fiction'),
('Fantasy'),
('Mystery'),
('Biography');

INSERT INTO Books (Title, AuthorID, CategoryID, Price, Stock, PublishedYear) VALUES
('Harry Potter and the Philosopher''s Stone', 1, 4, 650.00, 15, 1997),
('A Game of Thrones', 2, 4, 850.00, 8, 1996),
('The Blue Umbrella', 3, 1, 350.00, 20, 1980),
('Five Point Someone', 4, 1, 299.00, 25, 2004),
('The Shining', 5, 5, 550.00, 12, 1977),
('The Immortals of Meluha', 6, 4, 450.00, 5, 2010),
('Harry Potter and the Chamber of Secrets', 1, 4, 700.00, 10, 1998),
('A Clash of Kings', 2, 4, 900.00, 6, 1998),
('The Room on the Roof', 3, 1, 320.00, 18, 1956),
('2 States', 4, 1, 280.00, 22, 2009);

INSERT INTO Customers (Name, Email, Phone, Address) VALUES
('Aarav Sharma', 'aarav.sharma@email.com', '9876543210', 'Mumbai, Maharashtra'),
('Priya Patel', 'priya.patel@email.com', '8765432109', 'Delhi, Delhi'),
('Rohan Kumar', 'rohan.kumar@email.com', '7654321098', 'Bangalore, Karnataka'),
('Sneha Gupta', 'sneha.gupta@email.com', '6543210987', 'Mumbai, Maharashtra'),
('Ankit Singh', 'ankit.singh@email.com', '9432109876', 'Chennai, Tamil Nadu'),
('Neha Reddy', 'neha.reddy@email.com', '8321098765', 'Hyderabad, Telangana');

INSERT INTO Orders (CustomerID, OrderDate, Status) VALUES
(1, '2024-01-15', 'Delivered'),
(2, '2024-01-18', 'Pending'),
(3, '2024-01-20', 'Shipped'),
(4, '2024-01-22', 'Delivered'),
(1, '2024-01-25', 'Pending'),
(5, '2024-01-26', 'Cancelled'),
(2, '2024-01-28', 'Shipped'),
(3, '2024-01-30', 'Delivered'),
(6, '2024-02-01', 'Pending'),
(4, '2024-02-02', 'Shipped');

-- 25 Queries
-- 1. List all books with price above 500
SELECT * FROM Books WHERE Price > 500;

-- 2. Show books published after 2015
SELECT * FROM Books WHERE PublishedYear > 2015;

-- 3. Find customers from a specific city
SELECT * FROM Customers WHERE Address LIKE '%Mumbai%';

-- 4. Display books by a given author name
SELECT b.* FROM Books b 
JOIN Authors a ON b.AuthorID = a.AuthorID 
WHERE a.Name = 'J.K. Rowling';

-- 5. List top 3 most expensive books
SELECT * FROM Books ORDER BY Price DESC LIMIT 3;

-- 6. Count total number of books in each category
SELECT c.CategoryName, COUNT(b.BookID) as TotalBooks 
FROM Categories c 
LEFT JOIN Books b ON c.CategoryID = b.CategoryID 
GROUP BY c.CategoryID, c.CategoryName;

-- 7. Show orders placed in the last 30 days
SELECT * FROM Orders WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 8. Display customer name and total orders placed
SELECT c.Name, COUNT(o.OrderID) as TotalOrders 
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID, c.Name;

-- 9. List books with stock less than 10
SELECT * FROM Books WHERE Stock < 10;

-- 10. Find authors with more than 5 books
SELECT a.Name, COUNT(b.BookID) as BookCount 
FROM Authors a 
JOIN Books b ON a.AuthorID = b.AuthorID 
GROUP BY a.AuthorID, a.Name 
HAVING COUNT(b.BookID) > 5;

-- 11. Show books with category name
SELECT b.Title, c.CategoryName, a.Name as Author 
FROM Books b 
JOIN Categories c ON b.CategoryID = c.CategoryID 
JOIN Authors a ON b.AuthorID = a.AuthorID;

-- 12. Find total sales amount for a given order
SELECT o.OrderID, SUM(b.Price) as TotalAmount 
FROM Orders o 
JOIN Books b -- Note: This assumes a OrderDetails table exists
GROUP BY o.OrderID;

-- 15. Find customers who have never placed an order
SELECT c.* FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
WHERE o.OrderID IS NULL;

-- 16. Show average price of books in each category
SELECT c.CategoryName, AVG(b.Price) as AveragePrice 
FROM Categories c 
LEFT JOIN Books b ON c.CategoryID = b.CategoryID 
GROUP BY c.CategoryID, c.CategoryName;

-- 17. List all books sorted by PublishedYear descending
SELECT * FROM Books ORDER BY PublishedYear DESC;

-- 18. Show most recent order for each customer
SELECT c.Name, MAX(o.OrderDate) as MostRecentOrder 
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID, c.Name;

-- 19. Find categories with no books
SELECT c.* FROM Categories c 
LEFT JOIN Books b ON c.CategoryID = b.CategoryID 
WHERE b.BookID IS NULL;

-- 21. Show total number of customers
SELECT COUNT(*) as TotalCustomers FROM Customers;

-- 22. Display orders with customer name and order date
SELECT o.OrderID, c.Name, o.OrderDate, o.Status 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 23. Find the cheapest book in each category
SELECT c.CategoryName, b.Title, b.Price 
FROM Categories c 
JOIN Books b ON c.CategoryID = b.CategoryID 
WHERE b.Price = (SELECT MIN(Price) FROM Books WHERE CategoryID = c.CategoryID);

-- 24. List customers who ordered books by a specific author
SELECT DISTINCT c.Name 
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN Books b -- Note: This assumes a OrderDetails table exists
JOIN Authors a ON b.AuthorID = a.AuthorID 
WHERE a.Name = 'J.K. Rowling';

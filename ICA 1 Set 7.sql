-- Create Database
CREATE DATABASE InventoryManagement;
USE InventoryManagement;

-- Create Tables
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(100) NOT NULL,
    Contact VARCHAR(15),
    City VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    SupplierID INT,
    Price DECIMAL(10,2),
    Stock INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    Quantity INT,
    PurchaseDate DATE,
    SupplierID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    CustomerName VARCHAR(100),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert Sample Data
INSERT INTO Categories (CategoryName) VALUES
('Electronics'),
('Clothing'),
('Books'),
('Home Appliances'),
('Sports');

INSERT INTO Suppliers (SupplierName, Contact, City) VALUES
('Tech Supplies Ltd', '9876543210', 'Delhi'),
('Fashion Wholesale', '8765432109', 'Mumbai'),
('Book Distributors', '7654321098', 'Bangalore'),
('Home Solutions', '6543210987', 'Chennai'),
('Sports Gear Co', '9432109876', 'Delhi');

INSERT INTO Products (ProductName, CategoryID, SupplierID, Price, Stock) VALUES
('Laptop', 1, 1, 45000.00, 25),
('Smartphone', 1, 1, 25000.00, 40),
('T-Shirt', 2, 2, 899.00, 100),
('Novel', 3, 3, 299.00, 50),
('Microwave', 4, 4, 12000.00, 15);

INSERT INTO Purchases (ProductID, Quantity, PurchaseDate, SupplierID) VALUES
(1, 10, '2024-01-15', 1),
(2, 20, '2024-01-16', 1),
(3, 50, '2024-01-17', 2),
(4, 30, '2024-01-18', 3),
(5, 8, '2024-01-19', 4);

INSERT INTO Sales (ProductID, Quantity, SaleDate, CustomerName) VALUES
(1, 2, '2024-01-20', 'Rajesh Kumar'),
(2, 5, '2024-01-21', 'Priya Sharma'),
(3, 10, '2024-01-22', 'Amit Patel'),
(4, 8, '2024-01-23', 'Sneha Gupta'),
(5, 3, '2024-01-24', 'Rohan Singh');

-- 20 Queries
-- 1. List products with stock below 10
SELECT * FROM Products WHERE Stock < 10;

-- 2. Show top 5 most expensive products
SELECT * FROM Products ORDER BY Price DESC LIMIT 5;

-- 3. Find suppliers from 'Delhi'
SELECT * FROM Suppliers WHERE City = 'Delhi';

-- 4. Show products supplied by a given supplier
SELECT p.* FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName = 'Tech Supplies Ltd';

-- 5. Count products in each category
SELECT c.CategoryName, COUNT(p.ProductID) as ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 6. Find total purchases for a specific product
SELECT p.ProductName, SUM(pur.Quantity) as TotalPurchased
FROM Products p
JOIN Purchases pur ON p.ProductID = pur.ProductID
WHERE p.ProductName = 'Laptop'
GROUP BY p.ProductID, p.ProductName;

-- 7. Show products never sold
SELECT p.* FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SaleID IS NULL;

-- 8. Display sales in the last week
SELECT * FROM Sales 
WHERE SaleDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 9. Show products with sales quantity above 50
SELECT p.ProductName, SUM(s.Quantity) as TotalSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(s.Quantity) > 50;

-- 10. List suppliers who supplied more than 5 products
SELECT s.SupplierName, COUNT(p.ProductID) as ProductsSupplied
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
HAVING COUNT(p.ProductID) > 5;

-- 11. Show average price per category
SELECT c.CategoryName, AVG(p.Price) as AveragePrice
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 12. Find top selling product
SELECT p.ProductName, SUM(s.Quantity) as TotalSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSold DESC LIMIT 1;

-- 13. Show categories without products
SELECT c.* FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
WHERE p.ProductID IS NULL;

-- 14. List all sales with product names
SELECT s.SaleID, p.ProductName, s.Quantity, s.SaleDate, s.CustomerName
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID;

-- 15. Show purchases with supplier names
SELECT pur.PurchaseID, p.ProductName, pur.Quantity, pur.PurchaseDate, s.SupplierName
FROM Purchases pur
JOIN Products p ON pur.ProductID = p.ProductID
JOIN Suppliers s ON pur.SupplierID = s.SupplierID;

-- 16. Display suppliers with no purchases
SELECT s.* FROM Suppliers s
LEFT JOIN Purchases pur ON s.SupplierID = pur.SupplierID
WHERE pur.PurchaseID IS NULL;

-- 17. Show most recent purchase date for each product
SELECT p.ProductName, MAX(pur.PurchaseDate) as LastPurchaseDate
FROM Products p
LEFT JOIN Purchases pur ON p.ProductID = pur.ProductID
GROUP BY p.ProductID, p.ProductName;

-- 18. List customers who bought more than 3 products
SELECT CustomerName, COUNT(SaleID) as TotalPurchases
FROM Sales
GROUP BY CustomerName
HAVING COUNT(SaleID) > 3;

-- 19. Show total stock value (Price × Stock)
SELECT SUM(Price * Stock) as TotalStockValue FROM Products;

-- 20. Find product with maximum stock
SELECT * FROM Products ORDER BY Stock DESC LIMIT 1;
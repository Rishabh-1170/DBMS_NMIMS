-- Create Database
CREATE DATABASE FoodDelivery;
USE FoodDelivery;

-- Create Tables
CREATE TABLE Restaurants (
    RestaurantID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Rating DECIMAL(3,1)
);

CREATE TABLE MenuItems (
    MenuItemID INT PRIMARY KEY AUTO_INCREMENT,
    RestaurantID INT,
    ItemName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Category VARCHAR(50),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Address VARCHAR(200)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    RestaurantID INT,
    OrderDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE DeliveryAgents (
    AgentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    VehicleNo VARCHAR(20)
);

-- Insert Sample Data
INSERT INTO Restaurants (Name, City, Rating) VALUES
('Spice Garden', 'Bangalore', 4.5),
('Pizza Palace', 'Mumbai', 4.2),
('Burger Hub', 'Delhi', 4.0),
('Chinese Corner', 'Bangalore', 4.3),
('South Indian Delight', 'Chennai', 4.7);

INSERT INTO MenuItems (RestaurantID, ItemName, Price, Category) VALUES
(1, 'Butter Chicken', 450.00, 'Main Course'),
(1, 'Garlic Naan', 80.00, 'Bread'),
(2, 'Margherita Pizza', 350.00, 'Pizza'),
(2, 'Garlic Bread', 120.00, 'Appetizer'),
(3, 'Classic Burger', 180.00, 'Burger');

INSERT INTO Customers (Name, Phone, Address) VALUES
('Aarav Sharma', '9876543210', 'Bangalore'),
('Priya Patel', '8765432109', 'Mumbai'),
('Rohan Kumar', '7654321098', 'Delhi'),
('Sneha Gupta', '6543210987', 'Bangalore'),
('Ankit Singh', '9432109876', 'Chennai');

INSERT INTO Orders (CustomerID, RestaurantID, OrderDate, Status) VALUES
(1, 1, '2024-02-01', 'Delivered'),
(2, 2, '2024-02-02', 'Pending'),
(3, 3, '2024-02-03', 'In Progress'),
(4, 1, '2024-02-04', 'Delivered'),
(5, 4, '2024-02-05', 'Cancelled');

INSERT INTO DeliveryAgents (Name, Phone, VehicleNo) VALUES
('Raj Kumar', '9123456780', 'KA01AB1234'),
('Suresh Patel', '8234567891', 'MH02CD5678'),
('Amit Sharma', '7345678902', 'DL03EF9012'),
('Priya Singh', '6456789013', 'KA04GH3456');

-- 20 Queries
-- 1. List restaurants in 'Bangalore'
SELECT * FROM Restaurants WHERE City = 'Bangalore';

-- 2. Show menu items priced above 300
SELECT * FROM MenuItems WHERE Price > 300;

-- 3. Find orders placed in the last week
SELECT * FROM Orders 
WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 4. Show top 5 highest rated restaurants
SELECT * FROM Restaurants ORDER BY Rating DESC LIMIT 5;

-- 5. List customers from a specific city
SELECT * FROM Customers WHERE Address LIKE '%Bangalore%';

-- 6. Show orders with status 'Delivered'
SELECT * FROM Orders WHERE Status = 'Delivered';

-- 7. Count menu items per restaurant
SELECT r.Name, COUNT(m.MenuItemID) as MenuItemCount
FROM Restaurants r
LEFT JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
GROUP BY r.RestaurantID, r.Name;

-- 8. Find customers who ordered from more than 3 restaurants
SELECT c.Name, COUNT(DISTINCT o.RestaurantID) as RestaurantCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
HAVING COUNT(DISTINCT o.RestaurantID) > 3;

-- 9. Show most expensive item in each restaurant
SELECT r.Name, m.ItemName, m.Price
FROM Restaurants r
JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
WHERE m.Price = (SELECT MAX(Price) FROM MenuItems WHERE RestaurantID = r.RestaurantID);

-- 10. List delivery agents with more than 10 deliveries
SELECT da.Name, COUNT(o.OrderID) as DeliveryCount
FROM DeliveryAgents da
JOIN Orders o -- Assuming delivery agent assignment in orders table
GROUP BY da.AgentID, da.Name
HAVING COUNT(o.OrderID) > 10;

-- 11. Find restaurants with no orders
SELECT r.* FROM Restaurants r
LEFT JOIN Orders o ON r.RestaurantID = o.RestaurantID
WHERE o.OrderID IS NULL;

-- 12. Show average price of items per category
SELECT Category, AVG(Price) as AveragePrice
FROM MenuItems
GROUP BY Category;

-- 13. List orders with customer and restaurant names
SELECT o.OrderID, c.Name as CustomerName, r.Name as RestaurantName, o.OrderDate, o.Status
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID;

-- 14. Find customers who ordered the same item multiple times
SELECT c.Name, m.ItemName, COUNT(o.OrderID) as OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN MenuItems m -- Assuming order details table exists
GROUP BY c.CustomerID, c.Name, m.ItemName
HAVING COUNT(o.OrderID) > 1;

-- 15. Show delivery agent with maximum orders
SELECT da.Name, COUNT(o.OrderID) as OrderCount
FROM DeliveryAgents da
JOIN Orders o -- Assuming delivery agent assignment
GROUP BY da.AgentID, da.Name
ORDER BY OrderCount DESC LIMIT 1;

-- 16. List orders with status 'Cancelled'
SELECT * FROM Orders WHERE Status = 'Cancelled';

-- 17. Find restaurants serving 'Pizza'
SELECT DISTINCT r.* 
FROM Restaurants r
JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
WHERE m.ItemName LIKE '%Pizza%';

-- 18. Show most popular item overall
SELECT m.ItemName, COUNT(o.OrderID) as OrderCount
FROM MenuItems m
JOIN Orders o -- Assuming order details table
GROUP BY m.MenuItemID, m.ItemName
ORDER BY OrderCount DESC LIMIT 1;

-- 19. Display top 3 customers by order value
SELECT c.Name, SUM(m.Price) as TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN MenuItems m -- Assuming order details
GROUP BY c.CustomerID, c.Name
ORDER BY TotalSpent DESC LIMIT 3;

-- 20. Show orders sorted by date
SELECT * FROM Orders ORDER BY OrderDate DESC;
-- Create Database
CREATE DATABASE HotelManagement;
USE HotelManagement;

-- Create Tables
CREATE TABLE Hotels (
    HotelID INT PRIMARY KEY AUTO_INCREMENT,
    HotelName VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    Rating DECIMAL(3,1)
);

CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    HotelID INT,
    RoomType VARCHAR(50),
    PricePerNight DECIMAL(10,2),
    Availability BOOLEAN,
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
);

CREATE TABLE Guests (
    GuestID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(200)
);

CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    RoomID INT,
    GuestID INT,
    CheckInDate DATE,
    CheckOutDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    ReservationID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    Method VARCHAR(20),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

-- Insert Sample Data
INSERT INTO Hotels (HotelName, Location, Rating) VALUES
('Taj Mahal Palace', 'Mumbai', 4.8),
('The Oberoi', 'Delhi', 4.7),
('ITC Grand Chola', 'Chennai', 4.6),
('The Leela Palace', 'Bangalore', 4.9),
('Park Hyatt', 'Goa', 4.5);

INSERT INTO Rooms (HotelID, RoomType, PricePerNight, Availability) VALUES
(1, 'Deluxe', 5000.00, TRUE),
(1, 'Suite', 12000.00, FALSE),
(2, 'Standard', 3500.00, TRUE),
(2, 'Deluxe', 6000.00, TRUE),
(3, 'Suite', 15000.00, FALSE);

INSERT INTO Guests (Name, Phone, Email, Address) VALUES
('Aarav Sharma', '9876543210', 'aarav.sharma@email.com', 'Mumbai'),
('Priya Patel', '8765432109', 'priya.patel@email.com', 'Delhi'),
('Rohan Kumar', '7654321098', 'rohan.kumar@email.com', 'Bangalore'),
('Sneha Gupta', '6543210987', 'sneha.gupta@email.com', 'Chennai'),
('Ankit Singh', '9432109876', 'ankit.singh@email.com', 'Mumbai');

INSERT INTO Reservations (RoomID, GuestID, CheckInDate, CheckOutDate, Status) VALUES
(1, 1, '2024-02-01', '2024-02-05', 'Checked-In'),
(2, 2, '2024-02-02', '2024-02-07', 'Confirmed'),
(3, 3, '2024-02-03', '2024-02-06', 'Pending'),
(4, 4, '2024-02-04', '2024-02-08', 'Confirmed'),
(5, 5, '2024-02-05', '2024-02-10', 'Cancelled');

INSERT INTO Payments (ReservationID, Amount, PaymentDate, Method) VALUES
(1, 20000.00, '2024-01-28', 'Credit Card'),
(2, 60000.00, '2024-01-29', 'Debit Card'),
(4, 24000.00, '2024-01-30', 'UPI');

-- 20 Queries
-- 1. List all hotels in 'Mumbai'
SELECT * FROM Hotels WHERE Location = 'Mumbai';

-- 2. Show rooms with price above 3000 per night
SELECT * FROM Rooms WHERE PricePerNight > 3000;

-- 3. Find available rooms in a given hotel
SELECT r.* FROM Rooms r
JOIN Hotels h ON r.HotelID = h.HotelID
WHERE h.HotelName = 'Taj Mahal Palace' AND r.Availability = TRUE;

-- 4. List guests with reservations in a specific hotel
SELECT g.Name, g.Phone 
FROM Guests g
JOIN Reservations res ON g.GuestID = res.GuestID
JOIN Rooms r ON res.RoomID = r.RoomID
JOIN Hotels h ON r.HotelID = h.HotelID
WHERE h.HotelName = 'Taj Mahal Palace';

-- 5. Show reservations with status 'Checked-In'
SELECT * FROM Reservations WHERE Status = 'Checked-In';

-- 6. Count rooms by type for each hotel
SELECT h.HotelName, r.RoomType, COUNT(r.RoomID) as RoomCount
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
GROUP BY h.HotelID, h.HotelName, r.RoomType;

-- 7. Find guests who stayed more than 5 nights
SELECT g.Name, DATEDIFF(res.CheckOutDate, res.CheckInDate) as NightsStayed
FROM Guests g
JOIN Reservations res ON g.GuestID = res.GuestID
WHERE DATEDIFF(res.CheckOutDate, res.CheckInDate) > 5;

-- 8. Show top 3 most expensive room types
SELECT DISTINCT RoomType, PricePerNight 
FROM Rooms 
ORDER BY PricePerNight DESC 
LIMIT 3;

-- 9. List all reservations in the last month
SELECT * FROM Reservations 
WHERE CheckInDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 10. Display guests who made more than 2 reservations
SELECT g.Name, COUNT(res.ReservationID) as ReservationCount
FROM Guests g
JOIN Reservations res ON g.GuestID = res.GuestID
GROUP BY g.GuestID, g.Name
HAVING COUNT(res.ReservationID) > 2;

-- 11. Show hotels with average room price above 4000
SELECT h.HotelName, AVG(r.PricePerNight) as AvgRoomPrice
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
GROUP BY h.HotelID, h.HotelName
HAVING AVG(r.PricePerNight) > 4000;

-- 12. List guests from a specific city
SELECT * FROM Guests WHERE Address = 'Mumbai';

-- 13. Find hotels without any reservations
SELECT h.* FROM Hotels h
LEFT JOIN Rooms r ON h.HotelID = r.HotelID
LEFT JOIN Reservations res ON r.RoomID = res.RoomID
WHERE res.ReservationID IS NULL;

-- 14. Show reservations with guest name, hotel name, and room type
SELECT res.ReservationID, g.Name as GuestName, h.HotelName, r.RoomType, res.CheckInDate, res.CheckOutDate
FROM Reservations res
JOIN Guests g ON res.GuestID = g.GuestID
JOIN Rooms r ON res.RoomID = r.RoomID
JOIN Hotels h ON r.HotelID = h.HotelID;

-- 15. Find total revenue for each hotel
SELECT h.HotelName, SUM(p.Amount) as TotalRevenue
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
JOIN Reservations res ON r.RoomID = res.RoomID
JOIN Payments p ON res.ReservationID = p.ReservationID
GROUP BY h.HotelID, h.HotelName;

-- 16. List reservations where check-out date is before check-in date (data check)
SELECT * FROM Reservations 
WHERE CheckOutDate < CheckInDate;

-- 17. Show payment methods used
SELECT DISTINCT Method FROM Payments;

-- 18. Find guests who haven't made any payments
SELECT g.* FROM Guests g
JOIN Reservations res ON g.GuestID = res.GuestID
LEFT JOIN Payments p ON res.ReservationID = p.ReservationID
WHERE p.PaymentID IS NULL;

-- 19. Display reservations sorted by check-in date
SELECT * FROM Reservations ORDER BY CheckInDate DESC;

-- 20. Find hotels with rating above 4
SELECT * FROM Hotels WHERE Rating > 4.0;
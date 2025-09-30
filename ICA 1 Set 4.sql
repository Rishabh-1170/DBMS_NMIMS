-- Create Database
CREATE DATABASE AirlineReservation;
USE AirlineReservation;

-- Create Tables
CREATE TABLE Airlines (
    AirlineID INT PRIMARY KEY AUTO_INCREMENT,
    AirlineName VARCHAR(100) NOT NULL,
    Country VARCHAR(50)
);

CREATE TABLE Flights (
    FlightID INT PRIMARY KEY AUTO_INCREMENT,
    AirlineID INT,
    Source VARCHAR(50),
    Destination VARCHAR(50),
    DepartureTime DATETIME,
    ArrivalTime DATETIME,
    Price DECIMAL(10,2),
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    PassportNo VARCHAR(20),
    Nationality VARCHAR(50),
    DOB DATE
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    FlightID INT,
    PassengerID INT,
    BookingDate DATE,
    SeatNo VARCHAR(10),
    Status VARCHAR(20),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    Method VARCHAR(20),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- Insert Sample Data
INSERT INTO Airlines (AirlineName, Country) VALUES
('Air India', 'India'),
('IndiGo', 'India'),
('Emirates', 'UAE'),
('Singapore Airlines', 'Singapore'),
('British Airways', 'UK');

INSERT INTO Flights (AirlineID, Source, Destination, DepartureTime, ArrivalTime, Price) VALUES
(1, 'Delhi', 'Mumbai', '2024-02-01 08:00:00', '2024-02-01 10:00:00', 4500.00),
(2, 'Mumbai', 'Bangalore', '2024-02-01 14:00:00', '2024-02-01 16:00:00', 3800.00),
(3, 'Delhi', 'Dubai', '2024-02-01 22:00:00', '2024-02-02 02:00:00', 25000.00),
(1, 'Chennai', 'Delhi', '2024-02-02 07:00:00', '2024-02-02 09:30:00', 5200.00),
(2, 'Bangalore', 'Goa', '2024-02-02 12:00:00', '2024-02-02 13:30:00', 3200.00);

INSERT INTO Passengers (Name, PassportNo, Nationality, DOB) VALUES
('Rajesh Kumar', 'A12345678', 'India', '1985-03-15'),
('Priya Sharma', 'B87654321', 'India', '1990-07-20'),
('John Smith', 'US123456', 'USA', '1978-11-10'),
('Wei Chen', 'CH789012', 'China', '1982-05-25'),
('Emma Wilson', 'UK456789', 'UK', '1995-09-30');

INSERT INTO Bookings (FlightID, PassengerID, BookingDate, SeatNo, Status) VALUES
(1, 1, '2024-01-25', '12A', 'Confirmed'),
(2, 2, '2024-01-26', '15B', 'Confirmed'),
(3, 3, '2024-01-27', '08C', 'Pending'),
(1, 4, '2024-01-28', '20D', 'Confirmed'),
(4, 5, '2024-01-29', '05A', 'Cancelled');

INSERT INTO Payments (BookingID, Amount, PaymentDate, Method) VALUES
(1, 4500.00, '2024-01-25', 'Credit Card'),
(2, 3800.00, '2024-01-26', 'Debit Card'),
(4, 5200.00, '2024-01-28', 'UPI'),
(3, 25000.00, '2024-01-27', 'Net Banking');

-- 20 Queries
-- 1. List all flights from 'Delhi' to 'Mumbai'
SELECT * FROM Flights WHERE Source = 'Delhi' AND Destination = 'Mumbai';

-- 2. Show flights departing after 6 PM
SELECT * FROM Flights WHERE HOUR(DepartureTime) >= 18;

-- 3. Find passengers with nationality 'India'
SELECT * FROM Passengers WHERE Nationality = 'India';

-- 4. List bookings with status 'Confirmed'
SELECT * FROM Bookings WHERE Status = 'Confirmed';

-- 5. Show all bookings for a given passenger name
SELECT b.* FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
WHERE p.Name = 'Rajesh Kumar';

-- 6. Count total flights operated by each airline
SELECT a.AirlineName, COUNT(f.FlightID) as TotalFlights
FROM Airlines a
LEFT JOIN Flights f ON a.AirlineID = f.AirlineID
GROUP BY a.AirlineID, a.AirlineName;

-- 7. Find passengers who booked more than 3 flights
SELECT p.Name, COUNT(b.BookingID) as BookingCount
FROM Passengers p
JOIN Bookings b ON p.PassengerID = b.PassengerID
GROUP BY p.PassengerID, p.Name
HAVING COUNT(b.BookingID) > 3;

-- 8. Show the most expensive flight
SELECT * FROM Flights ORDER BY Price DESC LIMIT 1;

-- 9. List all airlines operating in 'USA'
SELECT * FROM Airlines WHERE Country = 'USA';

-- 10. Display bookings made in the last 7 days
SELECT * FROM Bookings WHERE BookingDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 11. Show average price of flights per airline
SELECT a.AirlineName, AVG(f.Price) as AveragePrice
FROM Airlines a
JOIN Flights f ON a.AirlineID = f.AirlineID
GROUP BY a.AirlineID, a.AirlineName;

-- 12. List passengers without any bookings
SELECT p.* FROM Passengers p
LEFT JOIN Bookings b ON p.PassengerID = b.PassengerID
WHERE b.BookingID IS NULL;

-- 13. Find flights with no bookings
SELECT f.* FROM Flights f
LEFT JOIN Bookings b ON f.FlightID = b.FlightID
WHERE b.BookingID IS NULL;

-- 14. Show passengers with passport numbers starting with 'M'
SELECT * FROM Passengers WHERE PassportNo LIKE 'M%';

-- 15. List all bookings along with passenger names and flight details
SELECT b.BookingID, p.Name, f.Source, f.Destination, b.SeatNo, b.Status
FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
JOIN Flights f ON b.FlightID = f.FlightID;

-- 16. Show top 5 highest payment transactions
SELECT * FROM Payments ORDER BY Amount DESC LIMIT 5;

-- 17. Count number of passengers on each flight
SELECT f.FlightID, f.Source, f.Destination, COUNT(b.PassengerID) as PassengerCount
FROM Flights f
LEFT JOIN Bookings b ON f.FlightID = b.FlightID
WHERE b.Status = 'Confirmed'
GROUP BY f.FlightID, f.Source, f.Destination;

-- 18. Find flights arriving before 10 AM
SELECT * FROM Flights WHERE HOUR(ArrivalTime) < 10;

-- 19. Show flights along with airline names
SELECT f.*, a.AirlineName 
FROM Flights f
JOIN Airlines a ON f.AirlineID = a.AirlineID;

-- 20. Find passengers with multiple bookings on the same date
SELECT p.Name, b.BookingDate, COUNT(b.BookingID) as SameDayBookings
FROM Passengers p
JOIN Bookings b ON p.PassengerID = b.PassengerID
GROUP BY p.PassengerID, p.Name, b.BookingDate
HAVING COUNT(b.BookingID) > 1;
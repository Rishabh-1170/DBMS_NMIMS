-- Create Database
CREATE DATABASE CinemaBooking;
USE CinemaBooking;

-- Create Tables
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(50),
    Language VARCHAR(30),
    Duration INT,
    ReleaseDate DATE
);

CREATE TABLE Screens (
    ScreenID INT PRIMARY KEY AUTO_INCREMENT,
    ScreenName VARCHAR(50),
    Capacity INT
);

CREATE TABLE Showtimes (
    ShowID INT PRIMARY KEY AUTO_INCREMENT,
    MovieID INT,
    ScreenID INT,
    ShowDate DATE,
    ShowTime TIME,
    Price DECIMAL(10,2),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY AUTO_INCREMENT,
    ShowID INT,
    CustomerID INT,
    SeatNo VARCHAR(10),
    BookingDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (ShowID) REFERENCES Showtimes(ShowID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert Sample Data
INSERT INTO Movies (Title, Genre, Language, Duration, ReleaseDate) VALUES
('Avatar: The Way of Water', 'Action', 'English', 192, '2022-12-16'),
('RRR', 'Action', 'Hindi', 187, '2022-03-25'),
('Kantara', 'Drama', 'Kannada', 148, '2022-09-30'),
('Drishyam 2', 'Thriller', 'Hindi', 140, '2022-11-18'),
('Vikram Vedha', 'Action', 'Hindi', 147, '2022-09-30');

INSERT INTO Screens (ScreenName, Capacity) VALUES
('Screen 1', 200),
('Screen 2', 150),
('Screen 3', 180),
('IMAX', 250),
('4DX', 120);

INSERT INTO Showtimes (MovieID, ScreenID, ShowDate, ShowTime, Price) VALUES
(1, 4, '2024-02-01', '10:00:00', 500.00),
(2, 1, '2024-02-01', '13:30:00', 350.00),
(3, 2, '2024-02-01', '16:00:00', 300.00),
(4, 3, '2024-02-01', '19:00:00', 400.00),
(5, 5, '2024-02-01', '21:30:00', 450.00);

INSERT INTO Customers (Name, Email, Phone) VALUES
('Aarav Sharma', 'aarav.sharma@email.com', '9876543210'),
('Priya Patel', 'priya.patel@email.com', '8765432109'),
('Rohan Kumar', 'rohan.kumar@email.com', '7654321098'),
('Sneha Gupta', 'sneha.gupta@email.com', '6543210987'),
('Ankit Singh', 'ankit.singh@email.com', '9432109876');

INSERT INTO Tickets (ShowID, CustomerID, SeatNo, BookingDate, Status) VALUES
(1, 1, 'A12', '2024-01-30', 'Confirmed'),
(2, 2, 'B05', '2024-01-30', 'Confirmed'),
(3, 3, 'C18', '2024-01-31', 'Pending'),
(4, 4, 'D22', '2024-01-31', 'Confirmed'),
(5, 5, 'E15', '2024-02-01', 'Cancelled');

-- 20 Queries
-- 1. List movies in 'Action' genre
SELECT * FROM Movies WHERE Genre = 'Action';

-- 2. Show movies released after 2020
SELECT * FROM Movies WHERE ReleaseDate > '2020-12-31';

-- 3. Find shows scheduled for today
SELECT * FROM Showtimes WHERE ShowDate = CURDATE();

-- 4. Show top 3 highest priced shows
SELECT * FROM Showtimes ORDER BY Price DESC LIMIT 3;

-- 5. Count tickets sold for each show
SELECT s.ShowID, m.Title, COUNT(t.TicketID) as TicketsSold
FROM Showtimes s
JOIN Movies m ON s.MovieID = m.MovieID
LEFT JOIN Tickets t ON s.ShowID = t.ShowID
WHERE t.Status = 'Confirmed'
GROUP BY s.ShowID, m.Title;

-- 6. Find customers who booked more than 5 tickets
SELECT c.Name, COUNT(t.TicketID) as TicketCount
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID
WHERE t.Status = 'Confirmed'
GROUP BY c.CustomerID, c.Name
HAVING COUNT(t.TicketID) > 5;

-- 7. Show shows with available seats (Capacity - Tickets sold)
SELECT s.ShowID, m.Title, sc.Capacity, 
       (sc.Capacity - COUNT(t.TicketID)) as AvailableSeats
FROM Showtimes s
JOIN Movies m ON s.MovieID = m.MovieID
JOIN Screens sc ON s.ScreenID = sc.ScreenID
LEFT JOIN Tickets t ON s.ShowID = t.ShowID AND t.Status = 'Confirmed'
GROUP BY s.ShowID, m.Title, sc.Capacity;

-- 8. List customers who booked tickets for a given movie
SELECT DISTINCT c.Name 
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID
JOIN Showtimes s ON t.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID
WHERE m.Title = 'Avatar: The Way of Water';

-- 9. Show movies with no shows
SELECT m.* FROM Movies m
LEFT JOIN Showtimes s ON m.MovieID = s.MovieID
WHERE s.ShowID IS NULL;

-- 10. Display tickets with customer and movie names
SELECT t.TicketID, c.Name as CustomerName, m.Title as MovieName, 
       t.SeatNo, t.BookingDate, t.Status
FROM Tickets t
JOIN Customers c ON t.CustomerID = c.CustomerID
JOIN Showtimes s ON t.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID;

-- 11. Find customers without any bookings
SELECT c.* FROM Customers c
LEFT JOIN Tickets t ON c.CustomerID = t.CustomerID
WHERE t.TicketID IS NULL;

-- 12. Show daily ticket sales totals
SELECT BookingDate, COUNT(TicketID) as TicketsSold, SUM(
    SELECT Price FROM Showtimes WHERE ShowID = t.ShowID
) as TotalRevenue
FROM Tickets t
WHERE Status = 'Confirmed'
GROUP BY BookingDate;

-- 13. Find movies with duration greater than 2 hours
SELECT * FROM Movies WHERE Duration > 120;

-- 14. Show most popular movie
SELECT m.Title, COUNT(t.TicketID) as TicketsSold
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
JOIN Tickets t ON s.ShowID = t.ShowID
WHERE t.Status = 'Confirmed'
GROUP BY m.MovieID, m.Title
ORDER BY TicketsSold DESC LIMIT 1;

-- 15. List top 5 customers by tickets purchased
SELECT c.Name, COUNT(t.TicketID) as TicketsPurchased
FROM Customers c
JOIN Tickets t ON c.CustomerID = t.CustomerID
WHERE t.Status = 'Confirmed'
GROUP BY c.CustomerID, c.Name
ORDER BY TicketsPurchased DESC LIMIT 5;

-- 16. Show cancelled tickets
SELECT * FROM Tickets WHERE Status = 'Cancelled';

-- 17. Find shows in a specific screen
SELECT s.*, m.Title 
FROM Showtimes s
JOIN Movies m ON s.MovieID = m.MovieID
WHERE s.ScreenID = 1;

-- 18. Show average price per genre
SELECT m.Genre, AVG(s.Price) as AveragePrice
FROM Movies m
JOIN Showtimes s ON m.MovieID = s.MovieID
GROUP BY m.Genre;

-- 19. List movies in 'Hindi' language
SELECT * FROM Movies WHERE Language = 'Hindi';

-- 20. Show shows in the next 7 days
SELECT s.*, m.Title 
FROM Showtimes s
JOIN Movies m ON s.MovieID = m.MovieID
WHERE s.ShowDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);
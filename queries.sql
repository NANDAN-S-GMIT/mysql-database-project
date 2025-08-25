-- MySQL database project (Exercise solution)

-- Task 1 solution:  Filter data using the WHERE clause and logical operators.
-- Create an SQL statement to print all records from the Bookings table for the dates of the following bookings using the BETWEEN operator: 
-- 2021-11-11, 
-- 2021-11-12, 
-- and 2021-11-13. 

SELECT * 
FROM Bookings 
WHERE BookingDate BETWEEN '2021-11-11' AND '2021-11-13';


-- Task 2 solution:  Create a JOIN query.
-- Create a JOIN SQL statement on the Customers and Bookings tables. The statement must print the customers full names and related bookings IDs from the date 2021-11-11.  


SELECT Customers.FullName, Bookings.BookingID 
FROM Customers RIGHT JOIN Bookings 
ON Customers.CustomerID = Bookings.CustomerID 
WHERE BookingDate = '2021-11-11';

-- Task 3 solution: Create a GROUP BY query.
-- Create a SQl statement to print the bookings dates from Bookings table. The statement must show the total number of bookings placed on each of the printed dates using the GROUP BY BookingDate.


SELECT BookingDate, COUNT(BookingDate) 
FROM Bookings 
GROUP BY BookingDate;

-- Task 4 solution:  Create a REPLACE statement.
-- Create a SQL REPLACE statement that updates the cost of the Kabsa course from $17.00 to $20.00. 


REPLACE INTO Courses (CourseName, Cost) VALUES ("Kabasa", 20.00);

-- Task 5 solution:  Create constraints
-- Create a new table called "DeliveryAddress" in the Little Lemon database with the following columns and constraints:
--  ID: INT PRIMARY KEY
--  Address: VARCHAR(255) NOT NULL
--  Type: VARCHAR(100) NOT NULL DEFAULT "Private"
--  CustomerID: INT NOT NULL FOREIGN KEY referencing CustomerID in the Customers table

CREATE TABLE DeliveryAddress(     
    ID INT PRIMARY KEY,     
    Address VARCHAR(255) NOT NULL,     
    Type VARCHAR(100) NOT NULL DEFAULT "Private",     
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Task 6 solution: Create an ALTER TABLE statement
-- Create a SQL statement that adds a new column called 'Ingredients' to the Courses table.
-- Ingredients: VARCHAR(255)

ALTER TABLE Courses ADD COLUMN Ingredients VARCHAR(255);

-- Task 7 solution: Create a subquery
-- Create a SQL statement with a subquery that prints the full names of all customers who made bookings in the restaurant on the following date: 2021-11-11.


SELECT FullName 
FROM Customers 
WHERE (SELECT CustomerID FROM Bookings WHERE Customers.CustomerID = Bookings.CustomerID and BookingDate = "2021-11-11");

-- Task 8 solution: Create a virtual table
-- Create the "BookingsView" virtual table to print all bookings IDs, bookings dates and the number of guests for bookings made in the restaurant before 2021-11-13 and where the number of guests is larger than 3.

CREATE VIEW BookingsView AS SELECT BookingID, BookingDate, NumberOfGuests FROM Bookings WHERE NumberOfGuests > 3 AND BookingDate < "2021-11-13";

-- Task 9 solution: Create a stored procedure
-- Create a stored procedure called 'GetBookingsData'. The procedure must contain one date parameter called "InputDate". This parameter retrieves all data from the Bookings table based on the user input of the date.

CREATE PROCEDURE GetBookingsData (InputDate DATE) 
SELECT * 
FROM Bookings 
WHERE BookingDate = InputDate;
Call the stored procedure.


CALL GetBookingsData ("2021-11-13");

-- Task 10 solution: Use the String function

-- Create a SQL SELECT query using the appropriate MySQL string function to list "Booking Details" including booking ID, booking date and number of guests. The data must be listed in the same format as the following example:
-- ID: 10, Date: 2021-11-10, Number of guests: 5

SELECT CONCAT("ID: ", BookingID,', Date: ', BookingDate,', Number of guests: ', NumberOfGuests) AS "Booking Details" FROM Bookings;

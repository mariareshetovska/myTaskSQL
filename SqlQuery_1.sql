CREATE DATABASE  HotelTaskSQL
GO

CREATE TABLE Hotel
 (
	IDHotel int NOT NULL IDENTITY PRIMARY KEY,
	Name nvarchar(20) NOT NULL,
	FoundationYear date NOT NULL,
	Adress nvarchar(40) NOT NULL,
	IsActive bit
 );
 GO

 CREATE TABLE Rooms
 (
	IdRoom  int NOT NULL IDENTITY PRIMARY KEY,
	RoomNumber int  NOT NULL,
	Price money DEFAULT 0.00,
	Comfort int CONSTRAINT Level CHECK(Comfort LIKE '[1-3]') NOT NULL,
	Capability int,
	HotelID int,
	FOREIGN KEY(HotelID) REFERENCES hotel (IDHotel) ON DELETE CASCADE
 );
 GO
 
 CREATE TABLE Users 
 (
	IdUsers int NOT NULL IDENTITY PRIMARY KEY,
	Name nvarchar(30) NOT NULL,
	Email nvarchar(30) NOT NULL
 );
 GO

  CREATE TABLE Booking
  (
	RoomBooked int FOREIGN KEY REFERENCES Rooms (IdRoom) ON DELETE CASCADE,
    BookUser int FOREIGN KEY REFERENCES Users (IdUsers) ON DELETE CASCADE,
    StartDate date,
    EndDate date
  );
  GO
  
	INSERT into Hotel (Name, FoundationYear, Adress, IsActive)
	VALUES  
	('Hotel Lviv', '1998-05-03', 'Lviv', 'True'),
	('Edelweiss', '2003-05-22', 'Kyiv', 'True'),
	('Hotel Poltava', '1963-11-14', 'Poltava', 'True');
	GO

	--1) Add 3 hotels to DB, one with name 'Edelweiss’
	SELECT * 
	FROM Hotel
	GO

	-- 2) Get All hotels from DB
	UPDATE Hotel 
	SET FoundationYear='1937'
	WHERE 
	IDHotel=1;
	GO

	--3) Update first hotel foundation year from existing value to 1937
	SELECT * 
	FROM Hotel
	GO

	--4) Delete 3d hotel from DB by Id
	DELETE Hotel
	WHERE IDHotel=3;
	GO
	
	--5) Insert 10 users to Database, but have at least 2 users with Name Andrew or Anton
	INSERT INTO Users(name, email)
	VALUES
	('Andrew', 'andrew1@gmail.com'),
	('Andrew', 'andrew2@gmail.com'),
	('Andrew', 'andrew3@gmail.com'),
	('Anton', 'anton1@gmail.com'), 
	('Anton', 'anton2@gmail.com'),
	('Anton', 'anton3@gmail.com'), 
	('Oleh', 'oleh@gmail.com'),
	('Ivan', 'ivan@gmail,com'),
	('Olia', 'oiae@gmail.com'),
	('Olena', 'olena@gmail.com');
	GO

	-- 6) Get all users which name starts from "A"
	SELECT *
	FROM Users
	WHERE Name LIKE 'A%';
	GO

	--7) Insert 10 rooms in DB. 7 to first hotel and 3 to other. Make sure both hotels have room number 101. 
	-- Make sure 'Edelweiss' has room number 301, but other hotel no. 
	-- Also make sure 'Edelweiss' do not have rooms with comfort level 3, but second hotel has at least one room with such comfort level
	INSERT INTO Rooms(RoomNumber, Price, Comfort, Capability, HotelID)
	VALUES
	(101, 500.0, 2, 2, 1),
	(10, 350.0, 1, 1, 1),
	(302, 680.5, 2, 2, 1),
	(411, 450.5, 2, 1, 1),
	(52, 250.0, 1, 1, 1),
	(106, 760.0, 3, 1, 1),
	(74, 690.0, 2, 2, 1),
	(101, 650.0, 2, 1, 2),
	(301, 800.0, 1, 2, 2),
	(10, 135.0, 2, 3, 2);
	GO

	SELECT * FROM ROOMS;

	--8) Select All rooms from DB sorted by Price
	SELECT * FROM Rooms
	ORDER BY Price;
	GO

	--9) Select All rooms from DB that belong to 'Edelweiss' hotel and sorted by price
	SELECT * FROM Rooms
	WHERE Rooms.HotelID = (SELECT IDHotel FROM Hotel
    WHERE Name = 'Edelweiss') ORDER BY Price;
    GO

	-- 10) Select Hotels that have rooms with comfort level 3
	SELECT * FROM Rooms 
	WHERE Comfort = 3;
	GO

	-- 11) Select Hotelname and room number for rooms that have comfort level 1
    SELECT Hotel.Name, Rooms.RoomNumber 
    FROM Hotel
    JOIN Rooms
    ON Hotel.IDHotel = Rooms.HotelID 
    WHERE Rooms.Comfort = 1;
	GO

	-- 02) Select Hotel names and count of hotel rooms
	SELECT Name, (SELECT COUNT(*) FROM Rooms 
	WHERE Rooms.HotelID = Hotel.IDHotel) AS [COUNT] 
	FROM Hotel
	GO

	--13) Insert 10 different reservations to db.
	INSERT INTO Booking(RoomBooked, BookUser, StartDate, EndDate)
	VALUES
	(1, 1,'2021-02-02', '2021-02-05'),
	(2, 1,'2021-01-21', '2021-01-22'),
	(3, 2,'2021-02-23', '2021-02-25'),
	(4, 3,'2021-02-05', '2021-02-25'),
	(5, 5,'2021-02-17', '2021-02-20'),
	(6, 5,'2021-02-05', '2021-02-15'),
	(7, 6,'2021-02-17', '2021-02-22'),
	(8, 7,'2021-02-02', '2021-02-15'),
	(9, 8,'2021-02-05', '2021-02-14'),
	(2, 9,'2021-02-08', '2021-02-09');
	GO

	-- 14) Select Username, room number, reservation period.
	SELECT Users.Name, Rooms.RoomNumber, Booking.StartDate, Booking.EndDate FROM Users
	JOIN Booking ON Booking.BookUser = IdUsers
	JOIN Rooms ON Rooms.IdRoom = Booking.RoomBooked;
	GO
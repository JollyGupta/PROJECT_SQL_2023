/*Project: Streaming Service Database*/

--The database will store information about movies, TV shows, and users

-- Create Movies table

drop table if exists Movies;
CREATE TABLE Movies (
  MovieID INT PRIMARY KEY,
  Title varchar(30),
  ReleaseYear INT,
  Director varchar(20),
  Genre varchar(20),
  Duration INT,
  Rating DECIMAL(3,1)
);

-- Create TVShows table
drop table if exists TVShows;
CREATE TABLE TVShows (
  ShowID INT PRIMARY KEY,
  Title varchar(30), 
  ReleaseYear varchar(20),
  Creator varchar(20),
  Genre varchar(20),
  Seasons INT,
  Rating DECIMAL(3,1)
);

-- Create Users table
drop table if exists Users;
CREATE TABLE Users (
  UserID INT PRIMARY KEY,
  Name varchar(20),
  Email varchar(30),
  SubscriptionDate DATE
);

-- Insert sample data
INSERT INTO Movies (MovieID, Title, ReleaseYear, Director, Genre, Duration, Rating)
VALUES
  (1, 'The Shawshank Redemption', 1994, 'Frank Darabont', 'Drama', 142, 9.3),
  (2, 'The Godfather', 1972, 'Francis Ford Coppola', 'Crime', 175, 9.2),
  (3, 'Pulp Fiction', 1994, 'Quentin Tarantino', 'Crime', 154, 8.9);

INSERT INTO TVShows (ShowID, Title, ReleaseYear, Creator, Genre, Seasons, Rating)
VALUES
  --(1, 'Friends', 1994, 'David Crane,Marta Kauffman', 'Comedy', 10, 8.9),
  (1, 'Friends', 1994, 'David Crane', 'Comedy', 10, 8.9),
  (2, 'Breaking Bad', 2008, 'Vince Gilligan', 'Crime', 5, 9.5),
  (3, 'Stranger Things', 2016, 'The Duffer Brothers', 'Drama', 4, 8.7);

--String or binary data would be truncated in table 'SQLPROJECTS.dbo.TVShows', column 'Creator'. Truncated value: 'David Crane, Marta K'.
--The statement has been terminated

--for this increase varchar value 
INSERT INTO Users (UserID, Name, Email, SubscriptionDate)
VALUES
  (1, 'John Doe', 'johndoe@example.com', '2023-01-15'),
  (2, 'Jane Smith', 'janesmith@example.com', '2023-02-05'),
  (3, 'Mark Johnson', 'markjohnson@example.com', '2023-03-10');

--Retrieve data:

--Write SQL queries to retrieve the following information:

--Retrieve all movies.
SELECT * FROM Movies;


--Retrieve all TV shows.
SELECT * FROM TVShows;

--Retrieve movies released in a specific year.
--SELECT * FROM  Movies DATEPART();
SELECT * FROM Movies WHERE ReleaseYear = 1994;

--Retrieve TV shows with a specific genre.
SELECT * FROM TVShows WHERE Genre = 'Drama';

--Retrieve users who subscribed in a specific month.
SELECT * FROM Users WHERE EXTRACT(MONTH FROM SubscriptionDate) = 2;
--'EXTRACT' is not a recognized built-in function name.


--Update data:
--Write SQL queries to update the rating of a movie or TV show based on its ID.
UPDATE Movies SET Rating = 9.5 WHERE MovieID = 1;
SELECT Rating FROM Movies

--Delete data:

--Write SQL queries to delete a movie, TV show, or user based on their respective IDs.
DELETE FROM Movies WHERE MovieID = 3;
SELECT * FROM Movies

--Calculate aggregate data:

--Write SQL queries to calculate the average rating of all movies.
SELECT AVG(Rating) AS AverageRating FROM Movies;

--Write SQL queries to calculate the average rating of all TV shows.
SELECT AVG(Rating) AS AverageRating FROM TVShows;

--Complex Queries

--Retrieve the movies and TV shows with a rating above 8.5:

SELECT * FROM Movies WHERE Rating > 8.5
UNION
SELECT * FROM TVShows WHERE Rating > 8.5;

--Retrieve the users who subscribed in a specific year and sort them by subscription date:

/*SELECT * FROM Users WHERE EXTRACT(YEAR FROM SubscriptionDate) = 2023
ORDER BY SubscriptionDate;*/

--Retrieve the average rating of movies and TV shows separately, rounded to one decimal place:

SELECT 'Movies' AS Media, ROUND(AVG(Rating), 1) AS AverageRating FROM Movies
UNION
SELECT 'TV Shows' AS Media, ROUND(AVG(Rating), 1) AS AverageRating FROM TVShows;

--Retrieve the top 5 longest movies:

--SELECT * FROM Movies ORDER BY Duration DESC LIMIT 5;
  SELECT TOP 5 * FROM Movies ORDER BY Duration DESC;
  
--Retrieve the TV shows with the highest rating for each genre:

SELECT Genre, MAX(Rating) AS HighestRating
FROM TVShows
GROUP BY Genre;

--Retrieve the users who subscribed in the first quarter of the year (January to March):

--SELECT * FROM Users WHERE EXTRACT(MONTH FROM SubscriptionDate) IN (1, 2, 3);
SELECT * FROM Users
WHERE DATEPART(MONTH, SubscriptionDate) IN (1, 2, 3);

--Update the duration of a movie based on its ID:
UPDATE Movies SET Duration = 160 WHERE MovieID = 2;
SELECT * FROM Movies

--Delete the TV show with the lowest rating:
DELETE FROM TVShows WHERE Rating = (SELECT MIN(Rating) FROM TVShows);
SELECT * FROM TVShows

--- even more complex queries

--Retrieve the total number of active subscribers:
ALTER TABLE Users
ADD EndDate DATE;

--UPDATE Users
UPDATE Users SET EndDate = '2023-06-30' WHERE UserID = 1;
Select * from USERS;

 -- Adjust the condition to match the specific user(s) you want to update

SELECT COUNT(*) AS TotalActiveSubscribers
FROM Users
WHERE EndDate >= GETDATE();

--Retrieve the top 10 most-watched movies and their view counts:
Create Views table
CREATE TABLE Views (
  ViewID INT PRIMARY KEY,
  UserID INT,
  MovieID INT,
  WatchDate DATE,
  -- Additional columns as needed
);

-- Insert sample data into Views table
INSERT INTO Views (ViewID, UserID, MovieID, WatchDate)
VALUES
  (1, 1, 1, '2023-06-01'),
  (2, 2, 1, '2023-06-02'),
  (3, 1, 2, '2023-06-03'),
  (4, 3, 1, '2023-06-04');
  -- Additional sample data as needed


-- Retrieve the top 10 most-watched movies and their view counts

SELECT TOP 10 M.MovieID, M.Title, COUNT(V.MovieID) AS ViewCount
FROM Movies M
LEFT JOIN Views V ON M.MovieID = V.MovieID
GROUP BY M.MovieID, M.Title
ORDER BY ViewCount DESC;

SELECT TOP 10 M.MovieID, M.Title, COUNT(V.MovieID) AS ViewCount
FROM Movies M
INNER JOIN Views V ON M.MovieID = V.MovieID
GROUP BY M.MovieID, M.Title
ORDER BY ViewCount DESC;
--Retrieve the total revenue generated from subscriptions in the last month:
drop table if exists Subscriptions;
CREATE TABLE Subscriptions (
  SubscriptionID INT PRIMARY KEY,
  UserID INT,
  SubscriptionFee DECIMAL(10, 2),
  SubscriptionDate DATE,
  -- Additional columns as needed
);
INSERT INTO Subscriptions (SubscriptionID, UserID, SubscriptionFee, SubscriptionDate)
VALUES
  (1, 1, 9.99, '2023-05-15'),
  (2, 2, 14.99, '2023-06-01');
  -- Additional sample data as needed
 --Retrieve the total revenue generated from subscriptions in the last month:
 SELECT SUM(SubscriptionFee) AS TotalRevenue
FROM Subscriptions
WHERE SubscriptionDate >= DATEADD(MONTH, -1, GETDATE());

--Retrieve the list of users who have watched a specific TV show:
/*CREATE TABLE Views (
  ViewID INT PRIMARY KEY,
  UserID INT,
  MovieID INT,
  WatchDate DATE,
  -- Additional columns as needed, TRICK join the prIMARY KEYS 
);*/

SELECT U.UserID, U.Name
FROM Users U
inner JOIN [Views] V ON U.UserID = V.UserID
--inner JOIN TVShows T ON V.ViewID = T.ShowID
inner JOIN TVShows T ON V.MovieID  = T.ShowID
WHERE T.Title = 'Friends';

--Retrieve the average rating of movies released in each year:

SELECT ReleaseYear, AVG(Rating) AS AverageRating
FROM Movies
GROUP BY ReleaseYear;

--Retrieve the list of movies that have not been watched by any user:

SELECT M.MovieID, M.Title
FROM Movies M
LEFT JOIN Views V ON M.MovieID = V.MovieID
WHERE V.MovieID IS NULL;

--Retrieve the top 5 most popular genres based on the number of views://not executing
SELECT TOP 5 G.Genre, COUNT(V.MovieID) AS ViewCount
FROM Movies M
INNER JOIN Genre G ON M.GenreID = G.GenreID
INNER JOIN [Views] V ON M.MovieID = V.MovieID
GROUP BY G.Genre
ORDER BY ViewCount DESC;

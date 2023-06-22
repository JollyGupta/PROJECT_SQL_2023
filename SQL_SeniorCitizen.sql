

                     --"Senior Citizens of a Society "
Use SQLPROJECTS;
  -- Create the SeniorCitizens table
 Drop Table if exists SeniorCitizens;
 CREATE TABLE SeniorCitizens (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  age INT,
  Gender VARCHAR(10),
  working_status VARCHAR(10)
);

-- Insert data into the SeniorCitizens table
INSERT INTO SeniorCitizens (id, name, age, Gender, working_status)
VALUES
  (1, 'Savita Aunty', 65, 'Female', 'Retired'),
  (2, 'V K Gupta Uncle', 70, 'Male', 'Retired'),
  (3, 'Madhur Gupta', 68, 'Female', 'Employed'),
  (4, 'Ashok Gupta', 72, 'Male', 'Retired');

-- Create the HappinessIndex table
 Drop Table if exists HappinessIndex;
CREATE TABLE HappinessIndex (
  id INT PRIMARY KEY,
  attribute VARCHAR(255),
  team_names VARCHAR(255),
  senior_citizen_id INT,
  FOREIGN KEY (senior_citizen_id) REFERENCES SeniorCitizens(id)
);

-- Insert data into the HappinessIndex table
INSERT INTO HappinessIndex (id, attribute, team_names, senior_citizen_id)
VALUES
  (1, 'Contentment', 'Team A', 1),
  (2, 'Satisfaction', 'Team B', 2),
  (3, 'Fulfillment', 'Team C', 4);

-- Create the HealthProblems table
 Drop Table if exists HealthProblems;
CREATE TABLE HealthProblems (
  id INT PRIMARY KEY,
  attribute VARCHAR(255),
  senior_citizen_id INT,
  FOREIGN KEY (senior_citizen_id) REFERENCES SeniorCitizens(id)
);

-- Insert data into the HealthProblems table
INSERT INTO HealthProblems (id, attribute, senior_citizen_id)
VALUES
  (1, 'Hypertension', 2),
  (2, 'Arthritis', 1),
  (3, 'Diabetes', 4);

  
--1. Retrieve all senior citizens' names, ages, and working statuses:
SELECT name, age, working_status
FROM SeniorCitizens;

--2. Get the happiness attributes and team names for each senior citizen:
SELECT s.name, h.attribute, h.team_names
FROM SeniorCitizens s
INNER JOIN HappinessIndex h ON s.id = h.senior_citizen_id;

--3. Find senior citizens who are retired:
SELECT *
FROM SeniorCitizens
WHERE working_status = 'Retired';

--4. Count the number of senior citizens with health problems:

SELECT COUNT(*) AS num_senior_citizens_with_health_problems
FROM SeniorCitizens s
INNER JOIN HealthProblems hp ON s.id = hp.senior_citizen_id;

--5. Get the names of senior citizens and their corresponding health problems:

SELECT s.name, hp.attribute AS health_problem
FROM SeniorCitizens s
INNER JOIN HealthProblems hp ON s.id = hp.senior_citizen_id;

--These queries demonstrate a variety of operations, including basic data retrieval, joining tables, filtering based on specific conditions, and aggregating data.

--Certainly! Here's an example of a more complex query that involves views and a stored procedure.

--1. Create a view to retrieve the names and working statuses of employed senior citizens:

Alter VIEW EmployedSeniorCitizens AS
SELECT name, working_status
FROM SeniorCitizens
WHERE working_status = 'Employed';

SELECT * FROM EmployedSeniorCitizens;

--A view always shows up-to-date data! The database engine recreates the view, every timea user queries it.


2. Create a view to retrieve the names and attributes of health problems for male senior citizens:

CREATE VIEW MaleSeniorCitizenHealthProblems AS
SELECT sc.name, hp.attribute
FROM SeniorCitizens sc
INNER JOIN HealthProblems hp ON sc.id = hp.senior_citizen_id
WHERE sc.Gender = 'Male';

SELECT * FROM MaleSeniorCitizenHealthProblems;

--Now, let's create a stored procedure that utilizes these views:

-- Create a stored procedure to retrieve the names and details of employed male senior citizens

ALTER PROCEDURE GetEmployedMaleSeniorCitizens
AS
BEGIN
  SELECT es.name, es.working_status, mshp.attribute
  FROM EmployedSeniorCitizens es
  INNER JOIN MaleSeniorCitizenHealthProblems mshp ON es.name = mshp.name;
END;
--note: not working 

--select * from GetEmployedMaleSeniorCitizens
--In this stored procedure, we join the views `EmployedSeniorCitizens` and `MaleSeniorCitizenHealthProblems` to retrieve the names, working statuses, and health problem attributes for employed male senior citizens.

--To execute the stored procedure, you can simply call it using the following command:

EXEC GetEmployedMaleSeniorCitizens;
EXECUTE GetEmployedMaleSeniorCitizens;

EXECUTE GetEmployedMaleSeniorCitizens WITH RESULT SETS UNDEFINED;

--DECLARE @outputVariable VARCHAR(255);
--EXECUTE GetEmployedMaleSeniorCitizens @outputVariable OUTPUT;


-- or
--This will execute the stored procedure and return the result set with the names, working statuses, and health problem attributes of employed male senior citizens.

--By using views and stored procedures, you can simplify complex queries, encapsulate business logic, and improve code reusability.
Certainly! Here are some more realistic queries based on the provided table structure:

-- Retrieve the names and ages of senior citizens who are retired:

SELECT name, age
FROM SeniorCitizens
WHERE working_status = 'Retired';


--Retrieve the names and happiness attributes of senior citizens along with their team names:

SELECT sc.name, hi.attribute, hi.team_names
FROM SeniorCitizens sc
INNER JOIN HappinessIndex hi ON sc.id = hi.senior_citizen_id;


-- Retrieve the names and health problems of senior citizens who have diabetes:

SELECT sc.name, hp.attribute
FROM SeniorCitizens sc
INNER JOIN HealthProblems hp ON sc.id = hp.senior_citizen_id
WHERE hp.attribute = 'Diabetes';


-- Retrieve the count of male senior citizens:

SELECT COUNT(*) AS male_count
FROM SeniorCitizens
WHERE Gender = 'Male';


-- Retrieve the average age of female senior citizens:

SELECT AVG(age) AS average_age
FROM SeniorCitizens
WHERE Gender = 'Female';


--Retrieve the team names and the count of senior citizens in each team from the HappinessIndex table:

SELECT team_names, COUNT(*) AS senior_count
FROM HappinessIndex
GROUP BY team_names;


--These queries cover a range of scenarios and provide insights into the senior citizen data, including their working status, happiness attributes, health problems, gender distribution, and team-wise statistics.

SELECT sc.name, sc.age, sc.Gender, sc.working_status, hi.attribute AS happiness_attribute, hp.attribute AS health_problem
FROM SeniorCitizens sc
LEFT JOIN HappinessIndex hi ON sc.id = hi.senior_citizen_id
LEFT JOIN HealthProblems hp ON sc.id = hp.senior_citizen_id
WHERE sc.age >= 70
ORDER BY sc.age DESC;



https://www.simplilearn.com/tutorials/sql-tutorial/stored-procedure-in-sql
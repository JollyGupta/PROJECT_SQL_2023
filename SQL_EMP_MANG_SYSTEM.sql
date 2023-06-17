/*Project: Employee Management System*/

CREATE DATABASE SQLPROJECTS;
USE SQLPROJECTS

/*CREATE TABLE Employees (
  ID INT PRIMARY KEY,
  Name TEXT,
  Department TEXT,
  Designation TEXT,
  Salary DECIMAL(10,2)
);*/

--The data types text and varchar are incompatible in the equal to operator.
drop table if exists Employees
CREATE TABLE Employees (
  ID INT PRIMARY KEY,
  Name varchar(20),
  Department varchar(20),
  Designation varchar(20),
  Salary int 
);
INSERT INTO Employees (ID, Name, Department, Designation, Salary)
VALUES
  (1, 'John Doe', 'Sales', 'Sales Manager', 5000.00),
  (2, 'Jane Smith', 'Marketing', 'Marketing Specialist', 4000.00),
  (3, 'Mark Johnson', 'Finance', 'Financial Analyst', 4500.00),
  (4, 'Sarah Williams', 'HR', 'HR Manager', 5500.00),
  (5, 'Michael Brown', 'IT', 'IT Manager', 6000.00);

 --Specific Queries:

--Retrieve data:

--Write SQL queries to retrieve the following information:
--Retrieve all employee records.

--Retrieve employees by department.
SELECT * FROM Employees WHERE Department = 'Sales';

--Retrieve employees by designation.
SELECT * FROM Employees WHERE Designation = 'IT Manager';

--Retrieve employees with a salary greater than a specified value.
SELECT * FROM Employees WHERE Salary > 4500.00;

--Update data:
--Write SQL queries to update an employee's designation based on their ID.
UPDATE Employees SET Designation = 'Senior Sales Manager' WHERE ID = 1;
SELECT * FROM Employees

--Delete data:
--Write SQL queries to delete an employee record based on their ID.
DELETE FROM Employees WHERE ID = 2;
SELECT * FROM Employees

--Calculate aggregate data:

--Write SQL queries to calculate the average salary of all employees.
SELECT AVG(Salary) AS AverageSalary FROM Employees;

--Write SQL queries to calculate the total salary of employees in a specific department.
SELECT SUM(Salary) AS TotalSalary FROM Employees WHERE Department = 'Finance';


--COMPLEX QUERIES
--Retrieve the names of employees who have a salary greater than the average salary of all employees:

SELECT Name FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

--Retrieve the total salary of employees in each department:
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department;

--Retrieve the employee with the highest salary:
SELECT *
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);

--Retrieve the employees who have the same salary:
SELECT e1.Name, e2.Name, e1.Salary
FROM Employees e1, Employees e2
WHERE e1.ID <> e2.ID AND e1.Salary = e2.Salary;

--Retrieve the departments with more than two employees:
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 2;

--Retrieve the average salary for each designation:
SELECT Designation, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Designation;

--Retrieve the employees who have a salary within a specific range (e.g., between 4000 and 5000):
SELECT *
FROM Employees
WHERE Salary BETWEEN 4000 AND 5000;

--Retrieve the employees who have a name starting with a specific letter (e.g., 'J'):
SELECT *
FROM Employees
WHERE Name LIKE 'J%';








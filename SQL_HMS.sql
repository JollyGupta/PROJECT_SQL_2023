
/*Project 4 HEALTH MANAGEMENT SYSTEM1 */

use SQLPROJECTS
-- Create the Patients table
--drop table if exists Patients1;

drop table if exists Patients1;
CREATE TABLE Patients1 (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    -- other patient details...
);

-- Create the Appointments table
drop table if exists Appointments1;
CREATE TABLE Appointments1 (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    AppointmentDateTime DATETIME,
    Duration TIME,
    -- other appointment details...
	StartTime TIME ,
	EndTime TIME, 
    FOREIGN KEY (PatientID) REFERENCES Patients1(PatientID)
);

-- Create the Visits table
drop table if exists Visits1;
CREATE TABLE Visits1 (
    VisitID INT PRIMARY KEY,
    PatientID INT,
    VisitDateTime DATETIME,
    -- other visit details...
    FOREIGN KEY (PatientID) REFERENCES Patients1(PatientID)
);

-- Create the Prescriptions table
drop table if exists Prescriptions1;
CREATE TABLE Prescriptions1 (
    PrescriptionID INT PRIMARY KEY,
    PatientID INT,
    PrescriptionDate DATE,
    -- other prescription details...
    FOREIGN KEY (PatientID) REFERENCES Patients1(PatientID)
);

-- Create the Consultations table
drop table if exists Consultations1;
CREATE TABLE Consultations1 (
    ConsultationID INT PRIMARY KEY,
    PatientID INT,
    ConsultationDateTime DATETIME,
    ConsultationFee DECIMAL(10, 2),
    -- other consultation details...
    FOREIGN KEY (PatientID) REFERENCES Patients1(PatientID)
);

-- Create the DiagnosedConditions table
drop table if exists DiagnosedConditions1;
CREATE TABLE DiagnosedConditions1 (
    ConditionID INT PRIMARY KEY,
    ConditionName VARCHAR(50),
    -- other condition details...
);

-- Create the Diagnoses table
drop table if exists Diagnoses1;
CREATE TABLE Diagnoses1 (
    DiagnosisID INT PRIMARY KEY,
    PatientID INT,
    ConditionID INT,
    DiagnosisDateTime DATETIME,
    -- other diagnosis details...
    FOREIGN KEY (PatientID) REFERENCES Patients1(PatientID),
    FOREIGN KEY (ConditionID) REFERENCES DiagnosedConditions1(ConditionID)
);

-- Insert sample data into the tables
INSERT INTO Patients1 (PatientID, PatientName, Age, Gender)
VALUES (1, 'John Doe', 30, 'Male'),
       (2, 'Jane Smith', 45, 'Female'),
	   (3, 'Jol', 40, 'Female');
       


INSERT INTO Appointments1 (AppointmentID, PatientID, AppointmentDateTime, Duration, StartTime, EndTime)
VALUES (1, 1, '2023-06-17 10:00:00', '00:30:00', '05:00:00', '05:15:00'),
       (2, 2, '2023-06-17 14:30:00', '00:45:00', '05:15:00', '05:25:00'),
       (3, 3, '2023-06-18 14:30:00', '00:45:00', '05:25:00', '06:00:00');


INSERT INTO Visits1 (VisitID, PatientID, VisitDateTime)
VALUES (1, 1, '2023-06-17 09:00:00'),
       (2, 2, '2023-06-17 13:45:00'),
	   (3, 3, '2023-06-17 13:45:00');
      

INSERT INTO Prescriptions1 (PrescriptionID, PatientID, PrescriptionDate)
VALUES (1, 1, '2023-06-17'),
       (2, 2, '2023-06-17'),
	   (3, 3, '2023-06-18');
       

INSERT INTO Consultations1 (ConsultationID, PatientID, ConsultationDateTime, ConsultationFee)
VALUES (1, 1, '2023-06-17 10:00:00', 50.00),
       (2, 2, '2023-06-17 14:30:00', 75.00),
	   (3, 3, '2023-06-18 14:30:00', 1000.00);
  

INSERT INTO DiagnosedConditions1 (ConditionID, ConditionName)
VALUES (1, 'Common Cold'),
       (2, 'Influenza'),
	   (3, 'eyeprob');
       

INSERT INTO Diagnoses1 (DiagnosisID, PatientID, ConditionID, DiagnosisDateTime)
VALUES (1, 1, 1, '2023-06-17 11:00:00'),
       (2, 2, 2, '2023-06-17 15:30:00'),
	   (3, 3, 3, '2023-06-17 15:30:00');
       
	   
--Retrieve all appointments scheduled for yesterday:
/*SELECT *
FROM Appointments1
WHERE DATE(AppointmentDateTime) = GETDATE() - INTERVAL 1 DAY;*/

/*SELECT *
FROM Appointments1
WHERE CAST(AppointmentDateTime AS DATE) = DATEADD(DAY, -1, GETDATE());*/
--ans 2

SELECT COUNT(DISTINCT AppointmentID) AS Allapintments
FROM Appointments1
WHERE CAST(AppointmentDateTime AS DATE) = (
    SELECT DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
);

--Get the total number of patients who visited the clinic yesterday:
In SQL Server Management Studio (SSMS), you cannot use the DATEADD() function directly in the WHERE clause when casting a column to a date. Instead, you can use a subquery or a common table expression (CTE) to calculate yesterday's date and then use it in the WHERE clause. Here's an example:

/*SELECT COUNT(DISTINCT PatientID) AS TotalPatients
FROM Visits1
--WHERE DATE(VisitDateTime) = GETDATE() - INTERVAL 1 DAY;
WHERE CAST(VisitDateTime AS DATE) = DATEADD(DAY, -1, GETDATE());*/

---using a subquery 3 correct
SELECT COUNT(DISTINCT PatientID) AS TotalPatients
FROM Visits1
WHERE CAST(VisitDateTime AS DATE) = (
    SELECT DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
);
--Using a CTE:

WITH Yesterday AS (
    SELECT DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AS YesterdayDate
)
SELECT COUNT(DISTINCT PatientID) AS TotalPatients
FROM Visits1
WHERE CAST(VisitDateTime AS DATE) = (SELECT YesterdayDate FROM Yesterday);


--Calculate the average consultation duration for yesterday's appointments:
--ans 12 both queries are correct

SELECT AVG(DATEDIFF(MINUTE, StartTime, EndTime)) AS AverageDurationMinutes
FROM Appointments1
WHERE CAST(AppointmentDateTime AS DATE) = DATEADD(DAY, -1, CAST(GETDATE() AS DATE));

SELECT AVG(DATEDIFF(MINUTE, StartTime, EndTime)) AS AverageDurationMinutes
FROM Appointments1
WHERE CAST(AppointmentDateTime AS DATE) = (
    SELECT DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
);

--Retrieve the list of patients who were prescribed medications yesterday:

/*SELECT DISTINCT p.PatientID, p.PatientName
FROM Patients1 p
JOIN Prescriptions1 pr ON p.PatientID = pr.PatientID
WHERE DATE(pr.PrescriptionDate) = GETDATE() - INTERVAL 1 DAY;*/

SELECT DISTINCT p.PatientID, p.PatientName
FROM Patients1 p
JOIN Prescriptions1 pr ON p.PatientID = pr.PatientID
WHERE CAST(pr.PrescriptionDate AS DATE) = CAST(GETDATE() - 1 AS DATE);

--Get the total revenue generated from consultations yesterday:
SELECT SUM(c.ConsultationFee) AS TotalRevenue
FROM Consultations1 c
--WHERE DATE(c.ConsultationDateTime) = GETDATE() - INTERVAL 1 DAY;
WHERE CAST(c.ConsultationDateTime AS DATE) = CAST(GETDATE() - 1 AS DATE);

--Retrieve the top 5 most frequently diagnosed conditions yesterday:
SELECT TOP 5 dc.ConditionName, COUNT(*) AS DiagnosisCount
FROM Diagnoses1 d
JOIN DiagnosedConditions1 dc ON d.ConditionID = dc.ConditionID
WHERE CAST(d.DiagnosisDateTime AS DATE) = CAST(GETDATE() - 1 AS DATE)
GROUP BY dc.ConditionName
ORDER BY DiagnosisCount DESC;


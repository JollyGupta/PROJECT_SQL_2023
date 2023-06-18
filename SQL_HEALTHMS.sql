/* a database schema for a Hospital Management System, along with some realistic SQL queries:*/

USE SQLPROJECTS

--1.Create the Patient table:
drop table if exists Patient;
CREATE TABLE Patient (
  patient_id INT PRIMARY KEY,
  patient_name VARCHAR(50),
  date_of_birth DATE,
  gender VARCHAR(10),
  address VARCHAR(100),
  contact_number VARCHAR(20)
);

--Insert data into the Patient table:

INSERT INTO Patient (patient_id, patient_name, date_of_birth, gender, address, contact_number)
VALUES
  (1, 'John Doe', '1990-05-10', 'Male', '123 Main St, City', '555-123-4567'),
  (2, 'Jane Smith', '1985-09-15', 'Female', '456 Elm St, Town', '555-987-6543'),
  (3, 'David Lee', '1988-12-03', 'Male', '789 Oak Ave, Village', '555-246-1357');

--2.Create the Doctor table:
drop table if exists Doctor;
CREATE TABLE Doctor (
  doctor_id INT PRIMARY KEY,
  doctor_name VARCHAR(50),
  specialization VARCHAR(50),
  contact_number VARCHAR(20),
  email VARCHAR(100)
);

--Insert data into the Doctor table:

INSERT INTO Doctor (doctor_id, doctor_name, specialization, contact_number, email)
VALUES
  (1, 'Dr. Robert Shaw', 'Cardiology', '555-111-1111', 'robertshaw@example.com'),
  (2, 'Dr. Emily Chen', 'Pediatrics', '555-222-2222', 'emilychen@example.com'),
  (3, 'Dr. Michael Wong', 'Orthopedics', '555-333-3333', 'michaelwong@example.com');

--3.Create the Appointment table:
drop table if exists Appointment;
CREATE TABLE Appointment (
  appointment_id INT PRIMARY KEY,
  doctor_id INT,
  patient_id INT,
  appointment_date DATE,
  appointment_time TIME,
  FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);
--Insert data into the Appointment table:

INSERT INTO Appointment (appointment_id, doctor_id, patient_id, appointment_date, appointment_time)
VALUES
  (1, 1, 1, '2023-06-20', '10:00:00'),
  (2, 2, 2, '2023-06-21', '11:30:00'),
  (3, 3, 3, '2023-06-22', '14:00:00');

--4. Create the Prescription table:
drop table if exists Prescription;
CREATE TABLE Prescription (
  prescription_id INT PRIMARY KEY,
  appointment_id INT,
  prescription_date DATE,
  medication VARCHAR(50),
  dosage VARCHAR(20),
  instructions VARCHAR(200),
  FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);
--Insert data into the Prescription table:

INSERT INTO Prescription (prescription_id, appointment_id, prescription_date, medication, dosage, instructions)
VALUES
  (1, 1, '2023-06-20', 'Aspirin', '500 mg', 'Take once daily'),
  (2, 2, '2023-06-21', 'Amoxicillin', '250 mg', 'Take twice daily'),
  (3, 3, '2023-06-22', 'Ibuprofen', '400 mg', 'Take as needed for pain');

 --Create the Bill table:
drop table if exists Bill;
CREATE TABLE Bill (
  bill_id INT PRIMARY KEY,
  appointment_id INT,
  bill_date DATE,
  total_amount DECIMAL(10, 2),
  FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

--Insert data into the Bill table:
INSERT INTO Bill (bill_id, appointment_id, bill_date, total_amount)
VALUES
  (1, 1, '2023-06-20', 1000.00),
  (2, 2, '2023-06-21', 750.00),
  (3, 3, '2023-06-22', 500.00);

 -- 1. Retrieve all patients:
   
   SELECT * FROM Patient;
 

--2. Retrieve all doctors:
   
   SELECT * FROM Doctor;
  

--3. Retrieve all appointments for a specific doctor:
   
   SELECT * FROM Appointment WHERE doctor_id = 1;
   SELECT * FROM Doctor;

SELECT D.doctor_name, D.specialization, A.appointment_date,A.appointment_time 
FROM Doctor as D
INNER JOIN Appointment as A
ON D.doctor_id = A.doctor_id
WHERE A.doctor_id = 1; 

--4. Retrieve all appointments for a specific patient:
   
SELECT * FROM Appointment WHERE patient_id = 2;


SELECT D.doctor_name,P.patient_name,  D.specialization,A.appointment_id,A.appointment_time
FROM Doctor as D
INNER JOIN Appointment as A
ON D.doctor_id = A.doctor_id
INNER JOIN Patient as P
ON P.patient_id = A.patient_id

--5. Retrieve all prescriptions for a specific appointment:
   
   SELECT * FROM Prescription WHERE appointment_id = 2;
   
--6. Calculate the total amount of a specific bill:
  
   SELECT total_amount FROM Bill WHERE bill_id = 1;
  

--7. Update a patient's address:
   
   UPDATE Patient SET address = 'bangalore' WHERE patient_id = 2;
   SELECT * FROM Patient ;

--8. Delete a specific appointment:
   
   DELETE FROM Appointment WHERE appointment_id =2 ;
  -- The DELETE statement conflicted with the REFERENCE constraint "FK__Prescript__appoi__778AC167". The conflict occurred in database "SQLPROJECTS", table "dbo.Prescription", column 'appointment_id'.The statement has been terminated.

   SELECT * FROM Appointment ;

--9. Insert a new patient:
  
   INSERT INTO Patient (patient_id,patient_name, date_of_birth, gender, address, contact_number) 
   VALUES (4,'J', '1983-09-28', 'F', 'Kha', '8448530112');
 
--10. Insert a new prescription for an appointment:
   
    INSERT INTO Prescription (prescription_id, appointment_id, prescription_date, medication, dosage, instructions)
VALUES
  (5, 3, '2023-06-18', 'Aspirin', '100 mg', 'Take twice daily');
   
   INSERT INTO Prescription (prescription_id, appointment_id, prescription_date, medication, dosage, instructions)
VALUES
  (4, 2, '2023-06-20', 'Aspirin', '500 mg', 'Take once daily');

================================================================

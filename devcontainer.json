-- =============================================
-- WEEK 2: Filtering, Functions & Aggregates
-- Database: BootcampDB
-- =============================================

USE BootcampDB;
GO

-- -----------------------------------------------
-- EXERCISE 1: Date functions
-- -----------------------------------------------
-- Task: Calculate each patient's current age in years
-- Hint: Use DATEDIFF(YEAR, DateOfBirth, GETDATE())
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 2: Filter by age
-- -----------------------------------------------
-- Task: Find all patients over 70 years old
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 3: NULL handling
-- -----------------------------------------------
-- Task: Find all admissions where the patient has NOT yet been discharged
-- (DischargeDate is NULL means still admitted)
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 4: COUNT
-- -----------------------------------------------
-- Task: How many patients are registered in total?
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 5: GROUP BY
-- -----------------------------------------------
-- Task: Count how many patients are registered with each GP
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 6: COUNT with GROUP BY on admissions
-- -----------------------------------------------
-- Task: How many admissions were Emergency vs Elective vs Transfer?
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 7: HAVING
-- -----------------------------------------------
-- Task: Which GPs have more than 2 registered patients?
-- YOUR ANSWER:


-- -----------------------------------------------
-- BONUS: Length of stay
-- -----------------------------------------------
-- Task: Calculate the length of stay in days for completed admissions
-- (where DischargeDate is not null)
-- Show: AdmissionID, Diagnosis, and LengthOfStayDays
-- YOUR ANSWER:


-- =============================================
-- ANSWERS
-- =============================================
/*
Ex 1:
  SELECT FirstName, LastName,
         DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS AgeYears
  FROM Patients;

Ex 2:
  SELECT * FROM Patients
  WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 70;

Ex 3:
  SELECT * FROM Admissions
  WHERE DischargeDate IS NULL;

Ex 4:
  SELECT COUNT(*) AS TotalPatients FROM Patients;

Ex 5:
  SELECT RegisteredGP, COUNT(*) AS PatientCount
  FROM Patients
  GROUP BY RegisteredGP;

Ex 6:
  SELECT AdmissionType, COUNT(*) AS Total
  FROM Admissions
  GROUP BY AdmissionType;

Ex 7:
  SELECT RegisteredGP, COUNT(*) AS PatientCount
  FROM Patients
  GROUP BY RegisteredGP
  HAVING COUNT(*) > 2;

BONUS:
  SELECT AdmissionID, Diagnosis,
         DATEDIFF(DAY, AdmissionDate, DischargeDate) AS LengthOfStayDays
  FROM Admissions
  WHERE DischargeDate IS NOT NULL;
*/

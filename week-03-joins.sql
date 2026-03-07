-- =============================================
-- WEEK 3: JOINs
-- Database: BootcampDB
-- =============================================

USE BootcampDB;
GO

-- -----------------------------------------------
-- EXERCISE 1: INNER JOIN
-- -----------------------------------------------
-- Task: List all admissions showing the patient's full name alongside
--       their AdmissionDate and Diagnosis
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 2: JOIN three tables
-- -----------------------------------------------
-- Task: Show patient name, ward name, admission date, and diagnosis
--       for all admissions
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 3: Filter after JOIN
-- -----------------------------------------------
-- Task: Show all patients currently admitted to a Virtual Ward
-- (DischargeDate IS NULL, WardType = 'Virtual')
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 4: LEFT JOIN
-- -----------------------------------------------
-- Task: List ALL patients, and show their most recent admission date
--       if they have one (patients with no admissions should still appear)
-- Hint: Use LEFT JOIN and MAX()
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 5: Observations JOIN
-- -----------------------------------------------
-- Task: Show all observations for Patient ID 5, including
--       the observation type, value, and when it was recorded
-- YOUR ANSWER:


-- -----------------------------------------------
-- BONUS: Readmissions
-- -----------------------------------------------
-- Task: Find any patients who have been admitted more than once
--       Show their name and admission count
-- YOUR ANSWER:


-- =============================================
-- ANSWERS
-- =============================================
/*
Ex 1:
  SELECT p.FirstName + ' ' + p.LastName AS PatientName,
         a.AdmissionDate, a.Diagnosis
  FROM Admissions a
  INNER JOIN Patients p ON a.PatientID = p.PatientID;

Ex 2:
  SELECT p.FirstName + ' ' + p.LastName AS PatientName,
         w.WardName, a.AdmissionDate, a.Diagnosis
  FROM Admissions a
  INNER JOIN Patients p ON a.PatientID = p.PatientID
  INNER JOIN Wards w    ON a.WardID    = w.WardID;

Ex 3:
  SELECT p.FirstName + ' ' + p.LastName AS PatientName,
         w.WardName, a.AdmissionDate, a.Diagnosis
  FROM Admissions a
  INNER JOIN Patients p ON a.PatientID = p.PatientID
  INNER JOIN Wards w    ON a.WardID    = w.WardID
  WHERE a.DischargeDate IS NULL
    AND w.WardType = 'Virtual';

Ex 4:
  SELECT p.FirstName + ' ' + p.LastName AS PatientName,
         MAX(a.AdmissionDate) AS MostRecentAdmission
  FROM Patients p
  LEFT JOIN Admissions a ON p.PatientID = a.PatientID
  GROUP BY p.FirstName, p.LastName;

Ex 5:
  SELECT p.FirstName + ' ' + p.LastName AS PatientName,
         o.ObsType, o.ObsValue, o.ObsDateTime, o.RecordedBy
  FROM Observations o
  INNER JOIN Admissions a ON o.AdmissionID = a.AdmissionID
  INNER JOIN Patients p   ON a.PatientID   = p.PatientID
  WHERE p.PatientID = 5
  ORDER BY o.ObsDateTime;

BONUS:
  SELECT p.FirstName + ' ' + p.LastName AS PatientName,
         COUNT(*) AS AdmissionCount
  FROM Admissions a
  INNER JOIN Patients p ON a.PatientID = p.PatientID
  GROUP BY p.FirstName, p.LastName
  HAVING COUNT(*) > 1;
*/

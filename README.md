-- =============================================
-- WEEK 1: SELECT Basics
-- Database: BootcampDB
-- =============================================
-- HOW TO RUN: Highlight a query, press Ctrl+Shift+E
-- =============================================

USE BootcampDB;
GO

-- -----------------------------------------------
-- EXERCISE 1: Retrieve all patients
-- -----------------------------------------------
-- Task: Select everything from the Patients table
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 2: Specific columns
-- -----------------------------------------------
-- Task: Select only FirstName, LastName and DateOfBirth
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 3: Rename columns with aliases
-- -----------------------------------------------
-- Task: Select FirstName as "First Name", LastName as "Surname"
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 4: Filter with WHERE
-- -----------------------------------------------
-- Task: Find all female patients
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 5: Filter with AND
-- -----------------------------------------------
-- Task: Find all female patients registered with Dr. Ahmed
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 6: Sort results
-- -----------------------------------------------
-- Task: List all patients ordered by LastName A-Z
-- YOUR ANSWER:


-- -----------------------------------------------
-- EXERCISE 7: Limit rows
-- -----------------------------------------------
-- Task: Return only the first 5 patients (by PatientID)
-- YOUR ANSWER:


-- -----------------------------------------------
-- BONUS: Calculated column
-- -----------------------------------------------
-- Task: Show each patient's full name as a single column called "FullName"
-- Hint: Use + to concatenate strings, and add a space between them
-- YOUR ANSWER:


-- =============================================
-- ANSWERS (scroll down only after trying!)
-- =============================================
/*
Ex 1:  SELECT * FROM Patients;

Ex 2:  SELECT FirstName, LastName, DateOfBirth FROM Patients;

Ex 3:  SELECT FirstName AS [First Name], LastName AS Surname FROM Patients;

Ex 4:  SELECT * FROM Patients WHERE Gender = 'Female';

Ex 5:  SELECT * FROM Patients WHERE Gender = 'Female' AND RegisteredGP = 'Dr. Ahmed';

Ex 6:  SELECT * FROM Patients ORDER BY LastName ASC;

Ex 7:  SELECT TOP 5 * FROM Patients ORDER BY PatientID;

BONUS: SELECT FirstName + ' ' + LastName AS FullName FROM Patients;
*/

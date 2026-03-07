-- =============================================
-- BootcampDB Seed Script
-- NHS-inspired sample dataset for T-SQL training
-- =============================================

CREATE DATABASE BootcampDB;
GO

USE BootcampDB;
GO

-- =============================================
-- TABLES
-- =============================================

CREATE TABLE Patients (
    PatientID       INT PRIMARY KEY IDENTITY(1,1),
    NHSNumber       CHAR(10) NOT NULL UNIQUE,
    FirstName       NVARCHAR(50) NOT NULL,
    LastName        NVARCHAR(50) NOT NULL,
    DateOfBirth     DATE NOT NULL,
    Gender          NVARCHAR(10),
    Postcode        NVARCHAR(8),
    RegisteredGP    NVARCHAR(100),
    CreatedDate     DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Wards (
    WardID          INT PRIMARY KEY IDENTITY(1,1),
    WardName        NVARCHAR(100) NOT NULL,
    WardType        NVARCHAR(50),   -- e.g. Medical, Surgical, Virtual
    Capacity        INT,
    Site            NVARCHAR(100)
);
GO

CREATE TABLE Admissions (
    AdmissionID     INT PRIMARY KEY IDENTITY(1,1),
    PatientID       INT NOT NULL REFERENCES Patients(PatientID),
    WardID          INT REFERENCES Wards(WardID),
    AdmissionDate   DATETIME NOT NULL,
    DischargeDate   DATETIME,
    AdmissionType   NVARCHAR(50),   -- Elective, Emergency, Transfer
    Diagnosis       NVARCHAR(200),
    DischargeReason NVARCHAR(100)
);
GO

CREATE TABLE Observations (
    ObservationID   INT PRIMARY KEY IDENTITY(1,1),
    AdmissionID     INT NOT NULL REFERENCES Admissions(AdmissionID),
    ObsDateTime     DATETIME NOT NULL,
    ObsType         NVARCHAR(50),   -- BP, HeartRate, Temperature, SpO2
    ObsValue        NVARCHAR(20),
    RecordedBy      NVARCHAR(100)
);
GO

-- =============================================
-- SEED DATA
-- =============================================

INSERT INTO Wards (WardName, WardType, Capacity, Site) VALUES
('Ward A - General Medical',    'Medical',   28, 'Main Hospital'),
('Ward B - Cardiology',         'Medical',   20, 'Main Hospital'),
('Ward C - Surgical',           'Surgical',  24, 'Main Hospital'),
('Virtual Ward - Respiratory',  'Virtual',   50, 'Community'),
('Virtual Ward - Heart Failure','Virtual',   40, 'Community'),
('Ward D - Orthopaedics',       'Surgical',  18, 'Main Hospital');
GO

INSERT INTO Patients (NHSNumber, FirstName, LastName, DateOfBirth, Gender, Postcode, RegisteredGP) VALUES
('1234567890', 'James',   'Patel',     '1952-03-14', 'Male',   'LS1 4AP', 'Dr. Ahmed'),
('2345678901', 'Sandra',  'Williams',  '1968-07-22', 'Female', 'LS2 9JT', 'Dr. Singh'),
('3456789012', 'Michael', 'Thompson',  '1945-11-05', 'Male',   'LS3 1BQ', 'Dr. Ahmed'),
('4567890123', 'Patricia','Clarke',    '1980-02-19', 'Female', 'LS4 2RN', 'Dr. Okafor'),
('5678901234', 'David',   'Robinson',  '1939-09-30', 'Male',   'LS1 6WX', 'Dr. Singh'),
('6789012345', 'Linda',   'Evans',     '1975-05-11', 'Female', 'LS5 3KL', 'Dr. Okafor'),
('7890123456', 'Robert',  'Johnson',   '1960-12-28', 'Male',   'LS2 4HM', 'Dr. Ahmed'),
('8901234567', 'Margaret','Brown',     '1955-08-16', 'Female', 'LS6 1DP', 'Dr. Singh'),
('9012345678', 'Thomas',  'Wilson',    '1990-04-03', 'Male',   'LS3 7QR', 'Dr. Okafor'),
('0123456789', 'Karen',   'Taylor',    '1983-01-25', 'Female', 'LS1 2ST', 'Dr. Ahmed');
GO

INSERT INTO Admissions (PatientID, WardID, AdmissionDate, DischargeDate, AdmissionType, Diagnosis, DischargeReason) VALUES
(1,  1, '2024-01-05 09:30', '2024-01-12 14:00', 'Emergency',  'COPD Exacerbation',          'Clinically Fit'),
(2,  2, '2024-01-08 11:00', '2024-01-15 10:30', 'Elective',   'Atrial Fibrillation',         'Clinically Fit'),
(3,  1, '2024-01-10 14:15', '2024-01-20 09:00', 'Emergency',  'Pneumonia',                   'Clinically Fit'),
(4,  3, '2024-01-12 08:00', '2024-01-14 16:00', 'Elective',   'Appendectomy',                'Clinically Fit'),
(5,  2, '2024-01-15 22:45', NULL,               'Emergency',  'Acute MI',                    NULL),
(6,  4, '2024-01-18 10:00', '2024-01-25 11:00', 'Transfer',   'Respiratory Infection',       'Clinically Fit'),
(7,  1, '2024-01-20 16:30', '2024-01-28 14:00', 'Emergency',  'Type 2 Diabetes Complication','Clinically Fit'),
(8,  5, '2024-01-22 09:15', NULL,               'Transfer',   'Heart Failure',               NULL),
(9,  3, '2024-01-25 07:45', '2024-01-26 18:00', 'Elective',   'Knee Arthroscopy',            'Clinically Fit'),
(10, 1, '2024-01-28 13:00', NULL,               'Emergency',  'Sepsis',                      NULL),
(1,  4, '2024-03-01 10:00', '2024-03-10 12:00', 'Transfer',   'Post-discharge COPD Monitoring','Clinically Fit'),
(3,  4, '2024-03-05 09:00', NULL,               'Transfer',   'Ongoing Respiratory Support', NULL);
GO

INSERT INTO Observations (AdmissionID, ObsDateTime, ObsType, ObsValue, RecordedBy) VALUES
(1, '2024-01-05 10:00', 'SpO2',        '88%',      'Nurse A'),
(1, '2024-01-05 10:00', 'HeartRate',   '102',      'Nurse A'),
(1, '2024-01-05 10:00', 'Temperature', '38.2',     'Nurse A'),
(1, '2024-01-06 08:00', 'SpO2',        '94%',      'Nurse B'),
(1, '2024-01-06 08:00', 'HeartRate',   '88',       'Nurse B'),
(2, '2024-01-08 12:00', 'BP',          '145/90',   'Nurse C'),
(2, '2024-01-08 12:00', 'HeartRate',   '115',      'Nurse C'),
(2, '2024-01-09 08:00', 'BP',          '132/82',   'Nurse A'),
(5, '2024-01-15 23:00', 'BP',          '90/60',    'Nurse D'),
(5, '2024-01-15 23:00', 'HeartRate',   '130',      'Nurse D'),
(5, '2024-01-15 23:00', 'SpO2',        '91%',      'Nurse D'),
(5, '2024-01-16 06:00', 'BP',          '110/72',   'Nurse B'),
(5, '2024-01-16 06:00', 'HeartRate',   '98',       'Nurse B'),
(10,'2024-01-28 14:00', 'Temperature', '39.8',     'Nurse C'),
(10,'2024-01-28 14:00', 'BP',          '85/55',    'Nurse C'),
(10,'2024-01-28 14:00', 'HeartRate',   '122',      'Nurse C');
GO

PRINT 'BootcampDB created and seeded successfully.';
GO

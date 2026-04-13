SELECT DISTINCT AdmissionType, COUNT(*) AS NumAdmissions 
FROM Admissions
GROUP BY AdmissionType, Diagnosis;
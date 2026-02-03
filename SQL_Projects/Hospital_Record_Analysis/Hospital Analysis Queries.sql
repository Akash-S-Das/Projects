CREATE TABLE hospital(
		Hospital_Name VARCHAR(50),
		Location VARCHAR(50),
		Department VARCHAR(50),
		Doctors_Count INTEGER,
		Patients_Count INTEGER,
		Admission_Date DATE,
		Discharge_Date DATE,
		Medical_Expenses NUMERIC(10, 2)
);

SElECT * FROM hospital;

-- 1. Write an SQL query to find the total number of patients across all hospitals.
SELECT SUM(patients_count) FROM hospital;

-- 2. Retrieve the average count of doctors available in each hospital.
SELECT AVG(doctors_count) FROM hospital;

-- 3. Find the top 3 hospital departments that have the highest number of patients.
SELECT department, SUM(patients_count) FROM hospital
GROUP BY department
ORDER BY SUM(patients_count) DESC
LIMIT 3;

-- 4. Identify the hospital that recorded the highest medical expenses.
SELECT hospital_name, MAX(medical_expenses) FROM hospital
GROUP BY hospital_name
ORDER BY SUM(medical_expenses) DESC
LIMIT 1;

-- 5. Calculate the average medical expenses per day for each hospital. 
SELECT hospital_name, ROUND(SUM(medical_expenses)/SUM((discharge_date-admission_date)), 2) 
AS avg_expenses FROM hospital
GROUP BY hospital_name;

-- 6. Find the patient with the longest stay by calculating the difference between 
Discharge Date and Admission Date.
SELECT hospital_name, location, department, medical_expenses, (discharge_date-admission_date) AS longest_stay
FROM hospital
ORDER BY longest_stay DESC
LIMIT 1;

-- 7. Count the total number of patients treated in each city.
SELECT location, SUM(patients_count) AS total_patients FROM hospital
GROUP BY location;

-- 8. Calculate the average number of days patients spend in each department.
SELECT department, ROUND(SUM((discharge_date-admission_date)*patients_count)::NUMERIC/SUM(patients_count), 0) AS avg_days_spend FROM hospital
GROUP BY department;

-- 9. Find the department with the least number of patients.
SELECT department, SUM(patients_count) AS patient_counts FROM hospital
GROUP BY department
ORDER BY SUM(patients_count)
LIMIT 1;

-- 10. Group the data by month and calculate the total medical expenses for each month.
SELECT Date(DATE_TRUNC('month', admission_date)) AS month, ROUND(SUM(medical_expenses), 2) AS total_medical_expenses FROM hospital
GROUP BY DATE(DATE_TRUNC('month', admission_date))
ORDER BY month;
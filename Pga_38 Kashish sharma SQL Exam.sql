1 --List the first 10 patients from the city ‘Bengaluru’, showing patient_id, full name, city, and blood group.
Ans - INSERT INTO patients (first_name, last_name, city, blood_group, date_of_birth, phone, email, address)
VALUES 
('Rahul', 'Dravid', 'Bengaluru', 'O+', '1973-01-11', '9876543210', 'rahul.d@example.com', 'Indiranagar, Bengaluru'),
('Anil', 'Kumble', 'Bengaluru', 'B+', '1970-10-17', '9876543211', 'anil.k@example.com', 'Jayanagar, Bengaluru');

SELECT patient_id, CONCAT(first_name, ' ', last_name) AS full_name, city, blood_group FROM patients WHERE city = 'Bengaluru'
LIMIT 10;

2 -- Display all doctors who are currently ‘Active’ and have more than 10 years of experience.
Ans - SELECT * FROM doctors WHERE status = 'Active' AND 'experience' > 10;

3 -- Find the total number of patients treated by each doctor.
Display doctor_id, doctor name, and patient_count.
Ans - SELECT COUNT(*) FROM appointments; ( Returns 0)
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, department_id, purpose)
VALUES 
(1, 1, '2023-12-01', '10:00:00', 'Completed', 1, 'Regular Checkup'),
(2, 1, '2023-12-02', '11:30:00', 'Completed', 1, 'Follow-up'),
(1, 2, '2023-12-03', '02:00:00', 'Completed', 2, 'Consultation');
SELECT 
    d.doctor_id, 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, 
    COUNT(a.patient_id) AS patient_count
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

4 -- For each payment mode, find how many bills are ‘Paid’ and their total net_amount.
Ans - INSERT INTO appointments (appointment_id, patient_id, doctor_id, department_id, appointment_date, appointment_time, status, purpose)
VALUES 
(101, 1, 1, 1, '2023-11-25', '10:00:00', 'Completed', 'Consultation'),
(102, 2, 2, 2, '2023-11-26', '11:00:00', 'Completed', 'Follow-up'),
(103, 1, 1, 1, '2023-11-27', '12:00:00', 'Completed', 'Check-up');

SELECT payment_mode, COUNT(bill_id) AS paid_bills_count, SUM(net_amount) AS total_net_amount FROM bills WHERE payment_status = 'Paid'
GROUP BY payment_mode;

5 -- Show top 5 departments with the highest total revenue generated from patient bills.
Ans - SELECT appointment_id, patient_id, doctor_id FROM appointments WHERE appointment_id IN (101, 102, 103);
INSERT INTO bills (total_amount, payment_status, payment_mode, patient_id, net_amount, due_date, doctor_id, billing_date, appointment_id)
VALUES 
(1500.00, 'Paid', 'Cash', 1, 1400.00, '2023-12-01', 1, '2023-11-25', 101),
(2500.00, 'Paid', 'Card', 2, 2400.00, '2023-12-02', 2, '2023-11-26', 102),
(500.00, 'Paid', 'UPI', 1, 500.00, '2023-12-05', 1, '2023-11-27', 103);
SELECT d.department_name, SUM(b.net_amount) AS total_revenue FROM departments d JOIN doctors dr ON d.department_id = dr.department_id JOIN bills b ON dr.doctor_id = b.doctor_id GROUP BY d.department_name ORDER BY total_revenue DESC
LIMIT 5;


6 -- collected from paid bills.
The view should include:
●	Doctor ID	
●	Doctor Full Name
●	Total Revenue (sum of net_amount from paid bills)
Then write a query to:
1.	Select all columns from vw_doctor_revenue.
2.	Display only those doctors whose total revenue exceeds ₹1000

Ans - 1 Select all columns from vw_doctor_revenue. ( CREATE OR REPLACE VIEW vw_doctor_revenue AS SELECT d.doctor_id, CONCAT(d.first_name, ' ', d.last_name) AS doctor_full_name, SUM(b.net_amount) AS total_revenue FROM doctors d JOIN bills b ON d.doctor_id = b.doctor_id
WHERE b.payment_status = 'Paid'GROUP BY d.doctor_id, d.first_name, d.last_name;
SELECT * FROM vw_doctor_revenue;
SELECT * FROM vw_doctor_revenue WHERE total_revenue > 1000; )
 

7 -- Identify the top 5 patients who have paid the highest total amount across all their bills.
Show patient name and total amount paid.

Ans - DESCRIBE patients;
DESCRIBE bills;
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name, SUM(b.net_amount) AS total_amount_paid FROM patients p JOIN bills b ON p.patient_id = b.patient_id GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_amount_paid DESCLIMIT 5;

8 -- Show a list of medications prescribed by doctors belonging to departments whose name contains ‘ology’ (like Cardiology, Neurology, etc.).

Ans - SHOW TABLES;
DESCRIBE medications;
SELECT COUNT(*) FROM medications;
SELECT doctor_id, first_name FROM doctors;

9 -- Using a window function, list the top 3 earning patients per city based on total amount paid (net_amount from bills).
Ans -  

10 -- Increase the discount by 5% for all bills where payment_status = ‘Pending’.
Before updating:
1.	Check how many such records exist.
2.	Preview a few rows.
After update:
3.	Verify that discounts are correctly applied.

Ans - 1 - Check how many such records exist. ( SELECT COUNT(*) AS pending_bills_count FROM bills WHERE payment_status = 'Pending'; )
2 - Preview a few rows. ( SELECT bill_id, patient_id, discount AS current_discount,(discount + 5) AS projected_discount FROM bills WHERE payment_status = 'Pending'
LIMIT 5; )

3 - Verify that discounts are correctly applied. ( SELECT bill_id, payment_status, discount FROM bills WHERE payment_status = 'Pending'; )

11 - Part A – CTE:
Write a CTE (Common Table Expression) to find doctors who have handled more than 8 appointments.
Display doctor_id, doctor_name, and appointment_count.
Part B – Trigger:
Create a trigger named trg_update_discount that automatically updates the discount field in the bills table
to 10% of net_amount whenever a new bill is inserted with a NULL discount
 Ans - A - CTE ( 
 
 B- TRIGGER ( SELECT net_amount, discount FROM bills WHERE appointment_id = 1; )
 
  12 -- Create a new database named ‘Hospital_Training_DB’ and inside it create two tables:
test_doctors and test_patients.
Requirements:
1.	test_doctors table:
o	doctor_id (INT, Primary Key, Auto Increment)
o	first_name (VARCHAR(50), Not Null)
o	last_name (VARCHAR(50), Not Null)
o	specialization (VARCHAR(100))
o	experience_years (INT)
2.	test_patients table:
 Ans -- 1 - 1.	test_doctors table: 
 INSERT INTO test_doctors (first_name, last_name, specialization, experience_years)
VALUES ('Rahul', 'Sharma', 'Cardiology', 12);
INSERT INTO test_patients (first_name, last_name, doctor_id, city)
VALUES ('Amit', 'Verma', 1, 'Bengaluru');
SELECT * FROM test_patients;
SELECT 
    p.first_name AS patient_name, 
    p.city, 
    d.first_name AS doctor_name, 
    d.specialization
FROM test_patients p
JOIN test_doctors d ON p.doctor_id = d.doctor_id;

2 - test_patients table:

DESCRIBE test_patients;
SELECT * FROM test_patients;
INSERT INTO test_patients (first_name, last_name, doctor_id, city)
VALUES ('Vikram', 'Singh', 1, 'Delhi');



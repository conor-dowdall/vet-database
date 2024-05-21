-- Veterinary Practice Database Solution and Queries
-- by Conor Dowdall
--
--
-- this script is executable using the following command:
-- source PATH_TO_FILE/FILENAME.sql
--
--
-- create queries to demonstrate CRUD statements
-- SELECT
CREATE VIEW appointments_for_today AS
SELECT name AS 'Customer',
    TIME(date_time) AS 'Time'
FROM customers
    INNER JOIN appointments USING (customer_id)
WHERE DATE(date_time) = DATE(NOW());
--
\! echo 'Appointments for Today';
SELECT *
FROM appointments_for_today;
--
CREATE VIEW treatment_payments_due AS
SELECT treatment_id AS 'ID',
    name AS 'Customer',
    appointments.date_time AS 'Appointment',
    cost AS 'Treatment Cost',
    IFNULL(SUM(amount), 0) AS 'Amount Paid',
    cost - IFNULL(SUM(amount), 0) AS 'Amount Due'
FROM treatments
    INNER JOIN appointments USING (appointment_id)
    INNER JOIN customers ON customers.customer_id = appointments.customer_id
    LEFT JOIN payments USING (treatment_id)
GROUP BY treatment_id
HAVING cost - IFNULL(SUM(amount), 0) > 0;
--
\! echo 'Treatment Payments Due';
SELECT *
FROM treatment_payments_due;
-- 
UPDATE appointments
SET cancelled_date_time = NOW() - INTERVAL 2 HOUR
WHERE appointment_id = 2;
CREATE VIEW appointments_cancelled_due AS
SELECT appointment_id AS 'ID',
    name AS 'Customer',
    appointments.date_time AS 'Appointment',
    appointments.cancelled_date_time AS 'Cancelled',
    fees.cost AS 'Fee',
    IFNULL(SUM(amount), 0) AS 'Amount Paid',
    fees.cost - IFNULL(SUM(amount), 0) AS 'Amount Due'
FROM appointments
    INNER JOIN customers USING (customer_id)
    INNER JOIN fees ON fees.type = 'cancellation'
    LEFT JOIN payments USING (appointment_id)
WHERE TIMESTAMPDIFF(
        HOUR,
        appointments.cancelled_date_time,
        appointments.date_time
    ) < 24
GROUP BY appointment_id,
    fees.cost;
--
\! echo 'Late Cancelled Appointment Payments Due';
SELECT *
FROM appointments_cancelled_due;
-- 
-- INSERT
INSERT INTO payments
VALUES (NULL, 3, NULL, 50.0, 'credit card', DEFAULT);
--
\! echo '*********************************\nPay €50 for Appointment with ID 3\n*********************************';
--
\! echo 'Treatment Payments Due';
SELECT *
FROM treatment_payments_due;
--
-- UPDATE
CREATE VIEW animals_owners AS
SELECT animals.name AS 'Animal',
    customers.name AS 'Owner'
FROM animals
    INNER JOIN customers USING (animal_id);
SELECT *
FROM animals_owners;
SELECT *
FROM customers;
UPDATE animals
    INNER JOIN customers USING (animal_id)
SET animals.name = 'Fluffy Badger Baby',
    customers.email = 'newemail@email.com'
WHERE animals.name = 'B Badger Name';
--
\! echo '*********************************\nAnimal name changed + new owner email\n*********************************';
SELECT *
FROM animals_owners;
SELECT *
FROM customers;
--
-- DELETE
--
\! echo 'Treatment Payments Due';
SELECT *
FROM treatment_payments_due;
INSERT INTO payments
VALUES (NULL, 1, NULL, 20.0, 'cash', DEFAULT);
--
\! echo '*********************************\nPay €20 for Appointment with ID 1\n*********************************';
--
\! echo 'Treatment Payments Due';
SELECT *
FROM treatment_payments_due;
--
\! echo '*********************************\nPayment Error for Appointment with ID 1\nDelete most recent payment\n*********************************';
CREATE TEMPORARY TABLE payments_copy AS
SELECT MAX(payment_id) AS id
from payments;
DELETE FROM payments
WHERE payment_id = (
        SELECT id
        FROM payments_copy
    );
DROP TEMPORARY TABLE IF EXISTS payments_copy;
--
\! echo 'Treatment Payments Due';
SELECT *
FROM treatment_payments_due;
--
--
-- demonstrate 3 of Codd's rules
-- Rule 3
-- Systematic Treatment of Null Values
--
\! echo 'Rule 3';
SELECT *
FROM appointments
WHERE cancelled_date_time IS NULL;
SELECT *
FROM appointments
WHERE cancelled_date_time IS NOT NULL;
-- Rule 6
-- View Updating Rule
--
\! echo 'Rule 6';
CREATE VIEW customers_appointments AS
SELECT name AS 'Name',
    date_time
FROM customers
    INNER JOIN appointments USING (customer_id);
SELECT *
FROM customers_appointments;
UPDATE customers_appointments
SET date_time = (NOW() - INTERVAL 1 YEAR)
WHERE name LIKE 'B %';
SELECT *
FROM customers_appointments;
-- Rule 9
-- Logical Data Independence
--
\! echo 'Rule 9';
SELECT *
FROM fees;
ALTER TABLE fees
ADD COLUMN description VARCHAR(255);
SELECT *
FROM fees;
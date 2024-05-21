-- Veterinary Practice Database Solution and Queries
-- by Conor Dowdall
--
--
-- this script is executable using the following command:
-- source PATH_TO_FILE/FILENAME.sql
--
--
-- create the database
CREATE DATABASE IF NOT EXISTS veterinary_practice;
--
--
-- Use of roles
-- further discussion with the business would allow a 
-- proper implementation of user roles
-- for example, only a 'vet' can access the 
-- 'treatments' table and, perhaps, only a 'receptionist' 
-- can access the 'appointments' table
-- Sample Statements...
-- CREATE ROLE 'vet',
-- 'nurse',
-- 'receptionist';
-- GRANT SELECT,
--     INSERT,
--     UPDATE,
--     DELETE,
--     ON veterinary_practice.treatments to 'vet';
-- GRANT SELECT,
--     INSERT,
--     UPDATE,
--     DELETE,
--     ON veterinary_practice.appointments to 'receptionist';
-- CREATE USER vet1 @localhost IDENTIFIED BY 'Vet1234!';
-- CREATE USER receptionist @localhost IDENTIFIED BY 'Receptionist1234!';
-- GRANT 'vet' TO vet1 @localhost;
-- GRANT 'receptionist' TO receptionist @localhost;
-- localhost may be unnecessary for actual deployment 
-- (i.e. default to % for non-localhost logins)
--
--
-- use the created database
USE veterinary_practice;
--
--
-- drop existing views and tables
DROP VIEW IF EXISTS customers_appointments;
DROP VIEW IF EXISTS appointments_for_today;
DROP VIEW IF EXISTS treatment_payments_due;
DROP VIEW IF EXISTS appointments_cancelled_due;
DROP VIEW IF EXISTS animals_owners;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS animals;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS fees;
DROP TABLE IF EXISTS roles;
--
--
-- create the tables
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT,
    role VARCHAR(50),
    PRIMARY KEY (role_id)
);
CREATE TABLE fees (
    fee_id INT AUTO_INCREMENT,
    type VARCHAR(20) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (fee_id)
);
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT,
    role_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(30),
    PRIMARY KEY (employee_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);
CREATE TABLE animals (
    animal_id INT AUTO_INCREMENT,
    name VARCHAR(50),
    species VARCHAR(50),
    subspecies VARCHAR(50),
    history TEXT,
    PRIMARY KEY (animal_id)
);
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT,
    animal_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(30),
    PRIMARY KEY (customer_id),
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id)
);
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT,
    customer_id INT NOT NULL,
    animal_id INT NOT NULL,
    vet_id INT NOT NULL,
    receptionist_id INT NOT NULL,
    date_time DATETIME NOT NULL,
    cancelled_date_time DATETIME,
    symptoms TEXT,
    PRIMARY KEY (appointment_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id),
    FOREIGN KEY (vet_id) REFERENCES employees(employee_id),
    FOREIGN KEY (receptionist_id) REFERENCES employees(employee_id)
);
CREATE TABLE treatments (
    treatment_id INT AUTO_INCREMENT,
    appointment_id INT NOT NULL,
    diagnosis TEXT,
    medication TEXT,
    follow_up_required BOOLEAN,
    cost DECIMAL(10, 2),
    PRIMARY KEY (treatment_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT,
    treatment_id INT,
    appointment_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    method VARCHAR(20) NOT NULL,
    date_time DATETIME DEFAULT NOW(),
    PRIMARY KEY (payment_id),
    FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);
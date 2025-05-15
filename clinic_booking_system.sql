-- Create the database
CREATE DATABASE IF NOT EXISTS ClinicDB;
USE ClinicDB;

-- Table: Patients
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- Table: Doctors
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE
);

-- Table: Departments
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Relationship: Many Doctors belong to One Department (1-M)
ALTER TABLE Doctors
ADD COLUMN department_id INT,
ADD CONSTRAINT fk_doctor_department
FOREIGN KEY (department_id) REFERENCES Departments(department_id);

-- Table: Appointments
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    reason TEXT,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Table: Prescriptions
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE, -- 1-to-1 with Appointments
    diagnosis TEXT,
    treatment TEXT,
    issued_date DATE NOT NULL,
    CONSTRAINT fk_prescription_appointment FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Table: Medications
CREATE TABLE Medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL
);

-- Many-to-Many: Prescriptions and Medications
CREATE TABLE Prescription_Medications (
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    PRIMARY KEY (prescription_id, medication_id),
    FOREIGN KEY (prescription_id) REFERENCES Prescriptions(prescription_id),
    FOREIGN KEY (medication_id) REFERENCES Medications(medication_id)
);

-- Table: Billing
CREATE TABLE Billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Pending', 'Paid') DEFAULT 'Pending',
    billing_date DATE NOT NULL,
    CONSTRAINT fk_billing_appointment FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

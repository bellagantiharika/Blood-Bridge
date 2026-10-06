-- ============================================================
-- BloodConnect Database Schema
-- Compatible with MySQL 5.7+ / 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS bloodconnect_db;
USE bloodconnect_db;

-- Drop tables if they exist (Order respects Foreign Keys)
DROP TABLE IF EXISTS request_responses;
DROP TABLE IF EXISTS blood_requests;
DROP TABLE IF EXISTS recipients;
DROP TABLE IF EXISTS donors;
DROP TABLE IF EXISTS users;

-- 1. Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role ENUM('DONOR', 'RECIPIENT', 'ADMIN') NOT NULL DEFAULT 'DONOR',
    status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Donors Table
CREATE TABLE donors (
    donor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    age INT NOT NULL,
    gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    last_donation_date DATE NULL,
    availability BOOLEAN NOT NULL DEFAULT TRUE,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Recipients Table
CREATE TABLE recipients (
    recipient_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Blood Requests Table
CREATE TABLE blood_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_id INT NOT NULL,
    patient_name VARCHAR(100) NOT NULL,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    units_needed INT NOT NULL DEFAULT 1,
    hospital_name VARCHAR(150) NOT NULL,
    hospital_address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    urgency ENUM('NORMAL', 'URGENT', 'CRITICAL') NOT NULL DEFAULT 'NORMAL',
    status ENUM('PENDING', 'ACCEPTED', 'FULFILLED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    contact_phone VARCHAR(20) NOT NULL,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipient_id) REFERENCES recipients(recipient_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Request Responses Table
CREATE TABLE request_responses (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    donor_id INT NOT NULL,
    status ENUM('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
    message TEXT,
    responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_request_donor (request_id, donor_id),
    FOREIGN KEY (request_id) REFERENCES blood_requests(request_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SAMPLE SEED DATA
-- Default password for all sample accounts is: "password123"
-- BCrypt Hash: $2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq
-- ============================================================

-- Seed Users (Admin, Donors, Recipients)
INSERT INTO users (user_id, name, email, password_hash, phone, role, status) VALUES
(1, 'System Administrator', 'admin@bloodconnect.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543210', 'ADMIN', 'ACTIVE'),
(2, 'John Doe', 'john.donor@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543211', 'DONOR', 'ACTIVE'),
(3, 'Sarah Connor', 'sarah.donor@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543212', 'DONOR', 'ACTIVE'),
(4, 'Michael Smith', 'mike.donor@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543213', 'DONOR', 'ACTIVE'),
(5, 'Emily Watson', 'emily.donor@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543214', 'DONOR', 'ACTIVE'),
(6, 'Robert Johnson', 'robert.recipient@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543215', 'RECIPIENT', 'ACTIVE'),
(7, 'Alice Brown', 'alice.recipient@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543216', 'RECIPIENT', 'ACTIVE');

-- Seed Donors
INSERT INTO donors (donor_id, user_id, blood_group, age, gender, last_donation_date, availability, city, state, address) VALUES
(1, 2, 'O+', 28, 'MALE', '2024-02-15', TRUE, 'New York', 'NY', '123 Broadway St, Suite 4'),
(2, 3, 'A+', 34, 'FEMALE', '2023-11-20', TRUE, 'Los Angeles', 'CA', '456 Sunset Blvd'),
(3, 4, 'B-', 25, 'MALE', '2024-05-10', TRUE, 'New York', 'NY', '789 5th Ave'),
(4, 5, 'AB+', 29, 'FEMALE', '2024-01-05', FALSE, 'Chicago', 'IL', '321 Michigan Ave');

-- Seed Recipients
INSERT INTO recipients (recipient_id, user_id, city, state, address) VALUES
(1, 6, 'New York', 'NY', '55 Wall Street'),
(2, 7, 'Los Angeles', 'CA', '101 Wilshire Blvd');

-- Seed Blood Requests
INSERT INTO blood_requests (request_id, recipient_id, patient_name, blood_group, units_needed, hospital_name, hospital_address, city, state, urgency, status, contact_phone, note) VALUES
(1, 1, 'Robert Johnson Sr.', 'O+', 2, 'City Central Hospital', '400 E 34th St, New York', 'New York', 'NY', 'URGENT', 'PENDING', '9876543215', 'Surgery scheduled for tomorrow morning. Urgent need for O+ blood.'),
(2, 1, 'David Johnson', 'B-', 1, 'Mount Sinai Hospital', '1468 Madison Ave, New York', 'New York', 'NY', 'CRITICAL', 'ACCEPTED', '9876543215', 'Emergency trauma care.'),
(3, 2, 'Clara Brown', 'A+', 3, 'St. Vincent Hospital', '201 S Alvarado St, Los Angeles', 'Los Angeles', 'CA', 'NORMAL', 'FULFILLED', '9876543216', 'Post-operative recovery supply.');

-- Seed Request Responses
INSERT INTO request_responses (response_id, request_id, donor_id, status, message) VALUES
(1, 1, 1, 'PENDING', 'I am available in NYC and can donate tomorrow at 9 AM.'),
(2, 2, 3, 'ACCEPTED', 'I am on my way to Mount Sinai Hospital now.');

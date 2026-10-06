package com.bloodconnect.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Thread-safe Database Connection Utility with automatic H2 In-Memory Database fallback
 * if local MySQL is unreachable or unconfigured.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static final String DB_URL = System.getenv().getOrDefault("DB_URL", 
            "jdbc:mysql://localhost:3306/bloodconnect_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String DB_PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "root");

    private static final String H2_URL = "jdbc:h2:mem:bloodconnect_db;DB_CLOSE_DELAY=-1;MODE=MySQL;CASE_INSENSITIVE_IDENTIFIERS=TRUE";
    private static final String H2_USER = "sa";
    private static final String H2_PASSWORD = "";

    private static HikariDataSource dataSource;
    private static boolean isH2Fallback = false;

    static {
        initializeDataSource();
    }

    private static void initializeDataSource() {
        try {
            // 1. Try MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            HikariConfig mysqlConfig = new HikariConfig();
            mysqlConfig.setJdbcUrl(DB_URL);
            mysqlConfig.setUsername(DB_USER);
            mysqlConfig.setPassword(DB_PASSWORD);
            mysqlConfig.setMaximumPoolSize(10);
            mysqlConfig.setConnectionTimeout(3000); // 3 sec timeout test

            HikariDataSource mysqlDs = new HikariDataSource(mysqlConfig);
            // Test connection
            try (Connection conn = mysqlDs.getConnection()) {
                dataSource = mysqlDs;
                LOGGER.info("Successfully connected to MySQL Database.");
                return;
            } catch (Exception e) {
                LOGGER.warning("MySQL connection test failed (" + e.getMessage() + "). Falling back to H2 Embedded Database.");
                mysqlDs.close();
            }
        } catch (Exception e) {
            LOGGER.warning("MySQL driver error or configuration issue: " + e.getMessage());
        }

        // 2. Fallback to H2 Embedded DB
        try {
            Class.forName("org.h2.Driver");
            HikariConfig h2Config = new HikariConfig();
            h2Config.setJdbcUrl(H2_URL);
            h2Config.setUsername(H2_USER);
            h2Config.setPassword(H2_PASSWORD);
            h2Config.setMaximumPoolSize(15);

            dataSource = new HikariDataSource(h2Config);
            isH2Fallback = true;
            LOGGER.info("Initialized H2 Embedded Database pool successfully.");

            // Create H2 Tables and Seed Data
            initH2Database();

        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Fatal: Unable to initialize H2 fallback database.", ex);
            dataSource = null;
        }
    }

    private static void initH2Database() {
        String schemaSql = 
            "CREATE TABLE IF NOT EXISTS users (" +
            "    user_id INT AUTO_INCREMENT PRIMARY KEY, " +
            "    name VARCHAR(100) NOT NULL, " +
            "    email VARCHAR(100) NOT NULL UNIQUE, " +
            "    password_hash VARCHAR(255) NOT NULL, " +
            "    phone VARCHAR(20) NOT NULL, " +
            "    role VARCHAR(20) DEFAULT 'DONOR', " +
            "    status VARCHAR(20) DEFAULT 'ACTIVE', " +
            "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP " +
            "); " +
            "CREATE TABLE IF NOT EXISTS donors (" +
            "    donor_id INT AUTO_INCREMENT PRIMARY KEY, " +
            "    user_id INT NOT NULL UNIQUE, " +
            "    blood_group VARCHAR(10) NOT NULL, " +
            "    age INT NOT NULL, " +
            "    gender VARCHAR(10) NOT NULL, " +
            "    last_donation_date DATE, " +
            "    availability BOOLEAN DEFAULT TRUE, " +
            "    city VARCHAR(50) NOT NULL, " +
            "    state VARCHAR(50) NOT NULL, " +
            "    address TEXT NOT NULL, " +
            "    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE " +
            "); " +
            "CREATE TABLE IF NOT EXISTS recipients (" +
            "    recipient_id INT AUTO_INCREMENT PRIMARY KEY, " +
            "    user_id INT NOT NULL UNIQUE, " +
            "    city VARCHAR(50) NOT NULL, " +
            "    state VARCHAR(50) NOT NULL, " +
            "    address TEXT NOT NULL, " +
            "    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE " +
            "); " +
            "CREATE TABLE IF NOT EXISTS blood_requests (" +
            "    request_id INT AUTO_INCREMENT PRIMARY KEY, " +
            "    recipient_id INT NOT NULL, " +
            "    patient_name VARCHAR(100) NOT NULL, " +
            "    blood_group VARCHAR(10) NOT NULL, " +
            "    units_needed INT DEFAULT 1, " +
            "    hospital_name VARCHAR(150) NOT NULL, " +
            "    hospital_address TEXT NOT NULL, " +
            "    city VARCHAR(50) NOT NULL, " +
            "    state VARCHAR(50) NOT NULL, " +
            "    urgency VARCHAR(20) DEFAULT 'NORMAL', " +
            "    status VARCHAR(20) DEFAULT 'PENDING', " +
            "    contact_phone VARCHAR(20) NOT NULL, " +
            "    note TEXT, " +
            "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "    FOREIGN KEY (recipient_id) REFERENCES recipients(recipient_id) ON DELETE CASCADE " +
            "); " +
            "CREATE TABLE IF NOT EXISTS request_responses (" +
            "    response_id INT AUTO_INCREMENT PRIMARY KEY, " +
            "    request_id INT NOT NULL, " +
            "    donor_id INT NOT NULL, " +
            "    status VARCHAR(20) DEFAULT 'PENDING', " +
            "    message TEXT, " +
            "    responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "    FOREIGN KEY (request_id) REFERENCES blood_requests(request_id) ON DELETE CASCADE, " +
            "    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE " +
            "); " +
            "MERGE INTO users (user_id, name, email, password_hash, phone, role, status) VALUES " +
            "(1, 'System Administrator', 'admin@bloodconnect.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543210', 'ADMIN', 'ACTIVE'), " +
            "(2, 'John Doe', 'john.donor@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543211', 'DONOR', 'ACTIVE'), " +
            "(3, 'Sarah Connor', 'sarah.donor@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543212', 'DONOR', 'ACTIVE'), " +
            "(6, 'Robert Johnson', 'robert.recipient@gmail.com', '$2a$10$lzif45bQA0QHOkmc9WkMyuJYRSA0zo0O8zexhkB2WmYo8Cvxtbhaq', '9876543215', 'RECIPIENT', 'ACTIVE'); " +
            "MERGE INTO donors (donor_id, user_id, blood_group, age, gender, last_donation_date, availability, city, state, address) VALUES " +
            "(1, 2, 'O+', 28, 'MALE', '2024-02-15', TRUE, 'New York', 'NY', '123 Broadway St, Suite 4'), " +
            "(2, 3, 'A+', 34, 'FEMALE', '2023-11-20', TRUE, 'Los Angeles', 'CA', '456 Sunset Blvd'); " +
            "MERGE INTO recipients (recipient_id, user_id, city, state, address) VALUES " +
            "(1, 6, 'New York', 'NY', '55 Wall Street'); ";

        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(schemaSql);
            LOGGER.info("H2 In-Memory Database schema and seed data initialized successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error populating H2 schema: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource != null && !dataSource.isClosed()) {
            return dataSource.getConnection();
        } else {
            return DriverManager.getConnection(H2_URL, H2_USER, H2_PASSWORD);
        }
    }

    public static boolean isH2Fallback() {
        return isH2Fallback;
    }

    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            LOGGER.info("Database Connection Pool shut down cleanly.");
        }
    }
}

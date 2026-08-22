package com.bloodconnect.dao;

import com.bloodconnect.config.DBConnection;
import com.bloodconnect.model.Donor;
import com.bloodconnect.model.Recipient;
import com.bloodconnect.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {

    private static final Logger LOGGER =
            Logger.getLogger(UserDAO.class.getName());

    /**
     * Register a new User along with their specific Role details
     * (Donor or Recipient) in a transaction.
     */
    public boolean registerUser(User user, Donor donor, Recipient recipient) {

        Connection conn = null;
        PreparedStatement stmtUser = null;
        PreparedStatement stmtRole = null;
        ResultSet rsKeys = null;

        String insertUserSql =
                "INSERT INTO users " +
                "(name, email, password_hash, phone, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try {

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Hash password with BCrypt
            String hashedPassword =
                    BCrypt.hashpw(
                            user.getPasswordHash(),
                            BCrypt.gensalt(10)
                    );

            // Insert user
            stmtUser = conn.prepareStatement(
                    insertUserSql,
                    Statement.RETURN_GENERATED_KEYS
            );

            stmtUser.setString(1, user.getName());
            stmtUser.setString(
                    2,
                    user.getEmail().toLowerCase().trim()
            );
            stmtUser.setString(3, hashedPassword);
            stmtUser.setString(4, user.getPhone());
            stmtUser.setString(5, user.getRole());
            stmtUser.setString(6, "ACTIVE");

            int rows = stmtUser.executeUpdate();

            if (rows == 0) {
                conn.rollback();
                return false;
            }

            // Get generated user ID
            rsKeys = stmtUser.getGeneratedKeys();

            int generatedUserId = 0;

            if (rsKeys.next()) {

                generatedUserId = rsKeys.getInt(1);
                user.setUserId(generatedUserId);

            } else {

                conn.rollback();
                return false;
            }

            // ============================
            // DONOR REGISTRATION
            // ============================

            if ("DONOR".equalsIgnoreCase(user.getRole())
                    && donor != null) {

                String insertDonorSql =
                        "INSERT INTO donors " +
                        "(user_id, blood_group, age, gender, " +
                        "last_donation_date, availability, city, state, address) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

                stmtRole = conn.prepareStatement(insertDonorSql);

                stmtRole.setInt(1, generatedUserId);
                stmtRole.setString(2, donor.getBloodGroup());
                stmtRole.setInt(3, donor.getAge());
                stmtRole.setString(4, donor.getGender());
                if (donor.getLastDonationDate() != null) {
                    stmtRole.setDate(5, donor.getLastDonationDate());
                } else {
                    stmtRole.setNull(5, Types.DATE);
                }
                stmtRole.setBoolean(6, donor.isAvailability());
                stmtRole.setString(7, donor.getCity() != null ? donor.getCity() : "");
                stmtRole.setString(8, donor.getState() != null ? donor.getState() : "");
                stmtRole.setString(9, donor.getAddress() != null ? donor.getAddress() : "");

                stmtRole.executeUpdate();
            }

            // ============================
            // RECIPIENT REGISTRATION
            // ============================

            else if ("RECIPIENT".equalsIgnoreCase(user.getRole())
                    && recipient != null) {

                String insertRecipientSql =
                        "INSERT INTO recipients " +
                        "(user_id, city, state, address) " +
                        "VALUES (?, ?, ?, ?)";

                stmtRole =
                        conn.prepareStatement(insertRecipientSql);

                stmtRole.setInt(1, generatedUserId);
                stmtRole.setString(2, recipient.getCity());
                stmtRole.setString(3, recipient.getState());
                stmtRole.setString(4, recipient.getAddress());

                stmtRole.executeUpdate();
            }

            // Commit transaction
            conn.commit();

            return true;

        } catch (SQLException e) {

            // Rollback if something goes wrong
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(
                            Level.SEVERE,
                            "Rollback failed",
                            ex
                    );
                }
            }

            // Show the REAL database error
            e.printStackTrace();

            LOGGER.log(
                    Level.SEVERE,
                    "User registration failed: "
                            + e.getMessage(),
                    e
            );

            return false;

        } finally {

            closeQuietly(
                    rsKeys,
                    stmtUser,
                    conn
            );

            if (stmtRole != null) {
                try {
                    stmtRole.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    /**
     * Authenticate user credentials with BCrypt password check.
     */
    public User authenticateUser(
            String email,
            String plainPassword) {

        String sql =
                "SELECT * FROM users " +
                "WHERE email = ? AND status = 'ACTIVE'";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt =
                        conn.prepareStatement(sql)
        ) {

            stmt.setString(
                    1,
                    email.toLowerCase().trim()
            );

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    String storedHash =
                            rs.getString("password_hash");

                    if (BCrypt.checkpw(
                            plainPassword,
                            storedHash)) {

                        return extractUserFromResultSet(rs);
                    }
                }
            }

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "Authentication failed for email "
                            + email,
                    e
            );
        }

        return null;
    }

    /**
     * Find user by email.
     */
    public User findByEmail(String email) {

        String sql =
                "SELECT * FROM users WHERE email = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt =
                        conn.prepareStatement(sql)
        ) {

            stmt.setString(
                    1,
                    email.toLowerCase().trim()
            );

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "findByEmail error",
                    e
            );
        }

        return null;
    }

    /**
     * Find user by ID.
     */
    public User findById(int userId) {

        String sql =
                "SELECT * FROM users WHERE user_id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt =
                        conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "findById error",
                    e
            );
        }

        return null;
    }

    /**
     * Get all users.
     */
    public List<User> getAllUsers() {

        List<User> list = new ArrayList<>();

        String sql =
                "SELECT * FROM users " +
                "ORDER BY created_at DESC";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt =
                        conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                list.add(
                        extractUserFromResultSet(rs)
                );
            }

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "getAllUsers error",
                    e
            );
        }

        return list;
    }

    /**
     * Update user status.
     */
    public boolean updateUserStatus(
            int userId,
            String status) {

        String sql =
                "UPDATE users SET status = ? " +
                "WHERE user_id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt =
                        conn.prepareStatement(sql)
        ) {

            stmt.setString(1, status);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "updateUserStatus error",
                    e
            );

            return false;
        }
    }

    /**
     * Delete user.
     */
    public boolean deleteUser(int userId) {

        String sql =
                "DELETE FROM users WHERE user_id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt =
                        conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, userId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "deleteUser error",
                    e
            );

            return false;
        }
    }

    /**
     * Convert ResultSet to User object.
     */
    private User extractUserFromResultSet(
            ResultSet rs) throws SQLException {

        User user = new User();

        user.setUserId(
                rs.getInt("user_id")
        );

        user.setName(
                rs.getString("name")
        );

        user.setEmail(
                rs.getString("email")
        );

        user.setPasswordHash(
                rs.getString("password_hash")
        );

        user.setPhone(
                rs.getString("phone")
        );

        user.setRole(
                rs.getString("role")
        );

        user.setStatus(
                rs.getString("status")
        );

        user.setCreatedAt(
                rs.getTimestamp("created_at")
        );

        return user;
    }

    /**
     * Close resources safely.
     */
    private void closeQuietly(
            AutoCloseable... resources) {

        for (AutoCloseable r : resources) {

            if (r != null) {

                try {
                    r.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}
package com.bloodconnect.dao;

import com.bloodconnect.config.DBConnection;
import com.bloodconnect.model.Donor;
import com.bloodconnect.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DonorDAO {
    private static final Logger LOGGER = Logger.getLogger(DonorDAO.class.getName());

    public Donor getDonorByUserId(int userId) {
        String sql = "SELECT d.*, u.name, u.email, u.phone, u.status FROM donors d " +
                     "JOIN users u ON d.user_id = u.user_id WHERE d.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractDonorWithUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getDonorByUserId error", e);
        }
        return null;
    }

    public Donor getDonorById(int donorId) {
        String sql = "SELECT d.*, u.name, u.email, u.phone, u.status FROM donors d " +
                     "JOIN users u ON d.user_id = u.user_id WHERE d.donor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, donorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractDonorWithUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getDonorById error", e);
        }
        return null;
    }

    public boolean updateAvailability(int donorId, boolean availability) {
        String sql = "UPDATE donors SET availability = ? WHERE donor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, availability);
            stmt.setInt(2, donorId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "updateAvailability error", e);
            return false;
        }
    }

    public boolean updateLastDonationDate(int donorId, Date lastDonationDate) {
        String sql = "UPDATE donors SET last_donation_date = ? WHERE donor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (lastDonationDate != null) {
                stmt.setDate(1, lastDonationDate);
            } else {
                stmt.setNull(1, Types.DATE);
            }
            stmt.setInt(2, donorId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "updateLastDonationDate error", e);
            return false;
        }
    }

    public List<Donor> searchDonors(String bloodGroup, String city, String state) {
        List<Donor> donors = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT d.*, u.name, u.email, u.phone, u.status FROM donors d " +
            "JOIN users u ON d.user_id = u.user_id " +
            "WHERE u.status = 'ACTIVE' "
        );

        List<Object> params = new ArrayList<>();

        if (bloodGroup != null && !bloodGroup.trim().isEmpty() && !"ALL".equalsIgnoreCase(bloodGroup)) {
            sql.append("AND d.blood_group = ? ");
            params.add(bloodGroup.trim());
        }

        if (city != null && !city.trim().isEmpty()) {
            sql.append("AND d.city LIKE ? ");
            params.add("%" + city.trim() + "%");
        }

        if (state != null && !state.trim().isEmpty()) {
            sql.append("AND d.state LIKE ? ");
            params.add("%" + state.trim() + "%");
        }

        sql.append("ORDER BY d.availability DESC, d.last_donation_date ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    donors.add(extractDonorWithUser(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "searchDonors error", e);
        }
        return donors;
    }

    public List<Donor> getAllDonors() {
        return searchDonors(null, null, null);
    }

    public Map<String, Integer> getBloodGroupCounts() {
        Map<String, Integer> counts = new HashMap<>();
        // Initialize all blood groups with 0
        String[] groups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
        for (String g : groups) {
            counts.put(g, 0);
        }

        String sql = "SELECT blood_group, COUNT(*) as cnt FROM donors GROUP BY blood_group";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                counts.put(rs.getString("blood_group"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getBloodGroupCounts error", e);
        }
        return counts;
    }

    public int getTotalDonorCount() {
        String sql = "SELECT COUNT(*) FROM donors";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getTotalDonorCount error", e);
        }
        return 0;
    }

    private Donor extractDonorWithUser(ResultSet rs) throws SQLException {
        Donor donor = new Donor();
        donor.setDonorId(rs.getInt("donor_id"));
        donor.setUserId(rs.getInt("user_id"));
        donor.setBloodGroup(rs.getString("blood_group"));
        donor.setAge(rs.getInt("age"));
        donor.setGender(rs.getString("gender"));
        donor.setLastDonationDate(rs.getDate("last_donation_date"));
        donor.setAvailability(rs.getBoolean("availability"));
        donor.setCity(rs.getString("city"));
        donor.setState(rs.getString("state"));
        donor.setAddress(rs.getString("address"));

        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setStatus(rs.getString("status"));
        donor.setUser(user);

        return donor;
    }
}

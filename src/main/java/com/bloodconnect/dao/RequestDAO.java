package com.bloodconnect.dao;

import com.bloodconnect.config.DBConnection;
import com.bloodconnect.model.BloodRequest;
import com.bloodconnect.model.Donor;
import com.bloodconnect.model.Recipient;
import com.bloodconnect.model.RequestResponse;
import com.bloodconnect.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RequestDAO {
    private static final Logger LOGGER = Logger.getLogger(RequestDAO.class.getName());

    public Recipient getRecipientByUserId(int userId) {
        String sql = "SELECT r.*, u.name, u.email, u.phone, u.status FROM recipients r " +
                     "JOIN users u ON r.user_id = u.user_id WHERE r.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Recipient recipient = new Recipient();
                    recipient.setRecipientId(rs.getInt("recipient_id"));
                    recipient.setUserId(rs.getInt("user_id"));
                    recipient.setCity(rs.getString("city"));
                    recipient.setState(rs.getString("state"));
                    recipient.setAddress(rs.getString("address"));

                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setName(rs.getString("name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setStatus(rs.getString("status"));
                    recipient.setUser(u);

                    return recipient;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getRecipientByUserId error", e);
        }
        return null;
    }

    public boolean createRequest(BloodRequest request) {
        String sql = "INSERT INTO blood_requests (recipient_id, patient_name, blood_group, units_needed, hospital_name, hospital_address, city, state, urgency, status, contact_phone, note) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING', ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, request.getRecipientId());
            stmt.setString(2, request.getPatientName());
            stmt.setString(3, request.getBloodGroup());
            stmt.setInt(4, request.getUnitsNeeded());
            stmt.setString(5, request.getHospitalName());
            stmt.setString(6, request.getHospitalAddress());
            stmt.setString(7, request.getCity());
            stmt.setString(8, request.getState());
            stmt.setString(9, request.getUrgency());
            stmt.setString(10, request.getContactPhone());
            stmt.setString(11, request.getNote());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        request.setRequestId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "createRequest error", e);
        }
        return false;
    }

    public BloodRequest getRequestById(int requestId) {
        String sql = "SELECT br.*, u.name as recipient_name, " +
                     "(SELECT COUNT(*) FROM request_responses rr WHERE rr.request_id = br.request_id) as response_count " +
                     "FROM blood_requests br " +
                     "JOIN recipients r ON br.recipient_id = r.recipient_id " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "WHERE br.request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, requestId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractBloodRequest(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getRequestById error", e);
        }
        return null;
    }

    public List<BloodRequest> getRequestsByRecipientId(int recipientId) {
        List<BloodRequest> list = new ArrayList<>();
        String sql = "SELECT br.*, u.name as recipient_name, " +
                     "(SELECT COUNT(*) FROM request_responses rr WHERE rr.request_id = br.request_id) as response_count " +
                     "FROM blood_requests br " +
                     "JOIN recipients r ON br.recipient_id = r.recipient_id " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "WHERE br.recipient_id = ? ORDER BY br.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, recipientId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBloodRequest(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getRequestsByRecipientId error", e);
        }
        return list;
    }

    public List<BloodRequest> getMatchingOpenRequestsForDonor(String bloodGroup, String city) {
        List<BloodRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT br.*, u.name as recipient_name, " +
            "(SELECT COUNT(*) FROM request_responses rr WHERE rr.request_id = br.request_id) as response_count " +
            "FROM blood_requests br " +
            "JOIN recipients r ON br.recipient_id = r.recipient_id " +
            "JOIN users u ON r.user_id = u.user_id " +
            "WHERE br.status IN ('PENDING', 'ACCEPTED') "
        );

        List<Object> params = new ArrayList<>();

        if (bloodGroup != null && !bloodGroup.isEmpty()) {
            sql.append("AND br.blood_group = ? ");
            params.add(bloodGroup);
        }

        if (city != null && !city.isEmpty()) {
            sql.append("AND br.city LIKE ? ");
            params.add("%" + city + "%");
        }

        sql.append("ORDER BY CASE br.urgency WHEN 'CRITICAL' THEN 1 WHEN 'URGENT' THEN 2 ELSE 3 END, br.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBloodRequest(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getMatchingOpenRequestsForDonor error", e);
        }
        return list;
    }

    public List<BloodRequest> getAllRequests() {
        List<BloodRequest> list = new ArrayList<>();
        String sql = "SELECT br.*, u.name as recipient_name, " +
                     "(SELECT COUNT(*) FROM request_responses rr WHERE rr.request_id = br.request_id) as response_count " +
                     "FROM blood_requests br " +
                     "JOIN recipients r ON br.recipient_id = r.recipient_id " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "ORDER BY br.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(extractBloodRequest(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getAllRequests error", e);
        }
        return list;
    }

    public boolean respondToRequest(int requestId, int donorId, String message) {
        String sql = "INSERT INTO request_responses (request_id, donor_id, status, message) VALUES (?, ?, 'PENDING', ?) " +
                     "ON DUPLICATE KEY UPDATE status = 'PENDING', message = VALUES(message), responded_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, requestId);
            stmt.setInt(2, donorId);
            stmt.setString(3, message);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "respondToRequest error", e);
            return false;
        }
    }

    public List<RequestResponse> getResponsesForRequest(int requestId) {
        List<RequestResponse> responses = new ArrayList<>();
        String sql = "SELECT rr.*, d.blood_group, d.age, d.gender, d.city, d.state, d.last_donation_date, u.name as donor_name, u.email as donor_email, u.phone as donor_phone " +
                     "FROM request_responses rr " +
                     "JOIN donors d ON rr.donor_id = d.donor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE rr.request_id = ? ORDER BY rr.responded_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, requestId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RequestResponse resp = new RequestResponse();
                    resp.setResponseId(rs.getInt("response_id"));
                    resp.setRequestId(rs.getInt("request_id"));
                    resp.setDonorId(rs.getInt("donor_id"));
                    resp.setStatus(rs.getString("status"));
                    resp.setMessage(rs.getString("message"));
                    resp.setRespondedAt(rs.getTimestamp("responded_at"));

                    Donor d = new Donor();
                    d.setDonorId(rs.getInt("donor_id"));
                    d.setBloodGroup(rs.getString("blood_group"));
                    d.setAge(rs.getInt("age"));
                    d.setGender(rs.getString("gender"));
                    d.setCity(rs.getString("city"));
                    d.setState(rs.getString("state"));
                    d.setLastDonationDate(rs.getDate("last_donation_date"));

                    User u = new User();
                    u.setName(rs.getString("donor_name"));
                    u.setEmail(rs.getString("donor_email"));
                    u.setPhone(rs.getString("donor_phone"));
                    d.setUser(u);

                    resp.setDonor(d);
                    responses.add(resp);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getResponsesForRequest error", e);
        }
        return responses;
    }

    public List<RequestResponse> getResponsesByDonorId(int donorId) {
        List<RequestResponse> list = new ArrayList<>();
        String sql = "SELECT rr.*, br.patient_name, br.blood_group, br.units_needed, br.hospital_name, br.city, br.urgency, br.status as req_status " +
                     "FROM request_responses rr " +
                     "JOIN blood_requests br ON rr.request_id = br.request_id " +
                     "WHERE rr.donor_id = ? ORDER BY rr.responded_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, donorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RequestResponse resp = new RequestResponse();
                    resp.setResponseId(rs.getInt("response_id"));
                    resp.setRequestId(rs.getInt("request_id"));
                    resp.setDonorId(rs.getInt("donor_id"));
                    resp.setStatus(rs.getString("status"));
                    resp.setMessage(rs.getString("message"));
                    resp.setRespondedAt(rs.getTimestamp("responded_at"));

                    BloodRequest req = new BloodRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setPatientName(rs.getString("patient_name"));
                    req.setBloodGroup(rs.getString("blood_group"));
                    req.setUnitsNeeded(rs.getInt("units_needed"));
                    req.setHospitalName(rs.getString("hospital_name"));
                    req.setCity(rs.getString("city"));
                    req.setUrgency(rs.getString("urgency"));
                    req.setStatus(rs.getString("req_status"));

                    resp.setBloodRequest(req);
                    list.add(resp);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getResponsesByDonorId error", e);
        }
        return list;
    }

    public boolean updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE blood_requests SET status = ? WHERE request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, requestId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "updateRequestStatus error", e);
            return false;
        }
    }

    public boolean updateResponseStatus(int responseId, String status) {
        String sql = "UPDATE request_responses SET status = ? WHERE response_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, responseId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "updateResponseStatus error", e);
            return false;
        }
    }

    public Map<String, Integer> getRequestStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("TOTAL", 0);
        stats.put("PENDING", 0);
        stats.put("ACCEPTED", 0);
        stats.put("FULFILLED", 0);
        stats.put("CANCELLED", 0);

        String sql = "SELECT status, COUNT(*) as cnt FROM blood_requests GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            int total = 0;
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("cnt");
                stats.put(status, count);
                total += count;
            }
            stats.put("TOTAL", total);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getRequestStats error", e);
        }
        return stats;
    }

    private BloodRequest extractBloodRequest(ResultSet rs) throws SQLException {
        BloodRequest req = new BloodRequest();
        req.setRequestId(rs.getInt("request_id"));
        req.setRecipientId(rs.getInt("recipient_id"));
        req.setPatientName(rs.getString("patient_name"));
        req.setBloodGroup(rs.getString("blood_group"));
        req.setUnitsNeeded(rs.getInt("units_needed"));
        req.setHospitalName(rs.getString("hospital_name"));
        req.setHospitalAddress(rs.getString("hospital_address"));
        req.setCity(rs.getString("city"));
        req.setState(rs.getString("state"));
        req.setUrgency(rs.getString("urgency"));
        req.setStatus(rs.getString("status"));
        req.setContactPhone(rs.getString("contact_phone"));
        req.setNote(rs.getString("note"));
        req.setCreatedAt(rs.getTimestamp("created_at"));
        req.setRecipientName(rs.getString("recipient_name"));
        try {
            req.setResponseCount(rs.getInt("response_count"));
        } catch (SQLException ignored) {}
        return req;
    }
}

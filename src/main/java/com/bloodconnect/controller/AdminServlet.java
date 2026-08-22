package com.bloodconnect.controller;

import com.bloodconnect.dao.DonorDAO;
import com.bloodconnect.dao.RequestDAO;
import com.bloodconnect.dao.UserDAO;
import com.bloodconnect.model.BloodRequest;
import com.bloodconnect.model.User;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {
    "/admin/dashboard", 
    "/admin/users/status", 
    "/admin/users/delete", 
    "/admin/requests/status",
    "/admin/api/stats"
})
public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;
    private DonorDAO donorDAO;
    private RequestDAO requestDAO;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        donorDAO = new DonorDAO();
        requestDAO = new RequestDAO();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/api/stats".equals(path)) {
            handleStatsAPI(request, response);
            return;
        }

        // Dashboard main view
        List<User> allUsers = userDAO.getAllUsers();
        List<BloodRequest> allRequests = requestDAO.getAllRequests();
        Map<String, Integer> bloodGroupStats = donorDAO.getBloodGroupCounts();
        Map<String, Integer> requestStats = requestDAO.getRequestStats();
        int totalDonors = donorDAO.getTotalDonorCount();

        request.setAttribute("allUsers", allUsers);
        request.setAttribute("allRequests", allRequests);
        request.setAttribute("bloodGroupStats", bloodGroupStats);
        request.setAttribute("requestStats", requestStats);
        request.setAttribute("totalDonors", totalDonors);
        request.setAttribute("totalUsers", allUsers.size());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/users/status".equals(path)) {
            String userIdStr = request.getParameter("userId");
            String status = request.getParameter("status");
            if (userIdStr != null && status != null) {
                userDAO.updateUserStatus(Integer.parseInt(userIdStr), status);
                request.getSession().setAttribute("toastSuccess", "User status updated to " + status);
            }
        } else if ("/admin/users/delete".equals(path)) {
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null) {
                userDAO.deleteUser(Integer.parseInt(userIdStr));
                request.getSession().setAttribute("toastSuccess", "User deleted successfully.");
            }
        } else if ("/admin/requests/status".equals(path)) {
            String reqIdStr = request.getParameter("requestId");
            String status = request.getParameter("status");
            if (reqIdStr != null && status != null) {
                requestDAO.updateRequestStatus(Integer.parseInt(reqIdStr), status);
                request.getSession().setAttribute("toastSuccess", "Request status updated to " + status);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private void handleStatsAPI(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> data = new HashMap<>();
        data.put("bloodGroupCounts", donorDAO.getBloodGroupCounts());
        data.put("requestStats", requestDAO.getRequestStats());
        data.put("totalDonors", donorDAO.getTotalDonorCount());
        data.put("totalUsers", userDAO.getAllUsers().size());

        objectMapper.writeValue(response.getWriter(), data);
    }
}

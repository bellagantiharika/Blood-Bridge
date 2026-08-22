package com.bloodconnect.controller;

import com.bloodconnect.dao.DonorDAO;
import com.bloodconnect.dao.RequestDAO;
import com.bloodconnect.model.BloodRequest;
import com.bloodconnect.model.Donor;
import com.bloodconnect.model.RequestResponse;
import com.bloodconnect.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/donor/dashboard", "/donor/toggle-availability", "/donor/update-last-donation"})
public class DonorServlet extends HttpServlet {

    private DonorDAO donorDAO;
    private RequestDAO requestDAO;

    @Override
    public void init() throws ServletException {
        donorDAO = new DonorDAO();
        requestDAO = new RequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        Donor donor = donorDAO.getDonorByUserId(user.getUserId());
        if (donor == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Donor profile not found.");
            return;
        }

        session.setAttribute("donorProfile", donor);
        request.setAttribute("donor", donor);

        // Fetch open blood requests matching donor blood group
        List<BloodRequest> matchingRequests = requestDAO.getMatchingOpenRequestsForDonor(donor.getBloodGroup(), null);
        request.setAttribute("matchingRequests", matchingRequests);

        // Fetch responses submitted by this donor
        List<RequestResponse> myResponses = requestDAO.getResponsesByDonorId(donor.getDonorId());
        request.setAttribute("myResponses", myResponses);

        request.getRequestDispatcher("/WEB-INF/views/donor/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        Donor donor = donorDAO.getDonorByUserId(user.getUserId());

        if (donor == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("/donor/toggle-availability".equals(path)) {
            boolean currentAvail = donor.isAvailability();
            boolean updated = donorDAO.updateAvailability(donor.getDonorId(), !currentAvail);
            if (updated) {
                donor.setAvailability(!currentAvail);
                session.setAttribute("donorProfile", donor);
                session.setAttribute("toastSuccess", "Availability status updated successfully!");
            } else {
                session.setAttribute("toastError", "Failed to update availability status.");
            }
            response.sendRedirect(request.getContextPath() + "/donor/dashboard");

        } else if ("/donor/update-last-donation".equals(path)) {
            String dateStr = request.getParameter("lastDonationDate");
            if (dateStr != null && !dateStr.trim().isEmpty()) {
                try {
                    Date newDate = Date.valueOf(dateStr);
                    boolean updated = donorDAO.updateLastDonationDate(donor.getDonorId(), newDate);
                    if (updated) {
                        donor.setLastDonationDate(newDate);
                        session.setAttribute("donorProfile", donor);
                        session.setAttribute("toastSuccess", "Last donation date updated!");
                    } else {
                        session.setAttribute("toastError", "Failed to update donation date.");
                    }
                } catch (IllegalArgumentException e) {
                    session.setAttribute("toastError", "Invalid date format.");
                }
            }
            response.sendRedirect(request.getContextPath() + "/donor/dashboard");
        }
    }
}

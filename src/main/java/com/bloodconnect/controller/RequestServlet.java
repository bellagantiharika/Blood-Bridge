package com.bloodconnect.controller;

import com.bloodconnect.dao.DonorDAO;
import com.bloodconnect.dao.RequestDAO;
import com.bloodconnect.model.BloodRequest;
import com.bloodconnect.model.Donor;
import com.bloodconnect.model.Recipient;
import com.bloodconnect.model.RequestResponse;
import com.bloodconnect.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/request/create", 
    "/request/list", 
    "/request/respond", 
    "/request/update-status",
    "/recipient/dashboard",
    "/request/view-responses"
})
public class RequestServlet extends HttpServlet {

    private RequestDAO requestDAO;
    private DonorDAO donorDAO;

    @Override
    public void init() throws ServletException {
        requestDAO = new RequestDAO();
        donorDAO = new DonorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        switch (path) {
            case "/request/create":
                request.getRequestDispatcher("/WEB-INF/views/request/create.jsp").forward(request, response);
                break;

            case "/request/list":
                List<BloodRequest> allRequests = requestDAO.getAllRequests();
                request.setAttribute("requestsList", allRequests);
                request.getRequestDispatcher("/WEB-INF/views/request/list.jsp").forward(request, response);
                break;

            case "/recipient/dashboard":
                handleRecipientDashboard(request, response, user);
                break;

            case "/request/view-responses":
                handleViewResponses(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/request/list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        switch (path) {
            case "/request/create":
                handleCreateRequest(request, response, user);
                break;

            case "/request/respond":
                handleRespondToRequest(request, response, user);
                break;

            case "/request/update-status":
                handleUpdateStatus(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/");
                break;
        }
    }

    private void handleRecipientDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        Recipient recipient = requestDAO.getRecipientByUserId(user.getUserId());
        if (recipient == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recipient profile not found.");
            return;
        }

        List<BloodRequest> recipientRequests = requestDAO.getRequestsByRecipientId(recipient.getRecipientId());
        request.setAttribute("recipient", recipient);
        request.setAttribute("requestsList", recipientRequests);
        request.getRequestDispatcher("/WEB-INF/views/recipient/dashboard.jsp").forward(request, response);
    }

    private void handleCreateRequest(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        Recipient recipient = requestDAO.getRecipientByUserId(user.getUserId());
        if (recipient == null && !user.isAdmin()) {
            request.setAttribute("errorMessage", "Only registered recipients can issue blood requests.");
            request.getRequestDispatcher("/WEB-INF/views/request/create.jsp").forward(request, response);
            return;
        }

        String patientName = request.getParameter("patientName");
        String bloodGroup = request.getParameter("bloodGroup");
        String unitsStr = request.getParameter("unitsNeeded");
        String hospitalName = request.getParameter("hospitalName");
        String hospitalAddress = request.getParameter("hospitalAddress");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String urgency = request.getParameter("urgency");
        String contactPhone = request.getParameter("contactPhone");
        String note = request.getParameter("note");

        if (patientName == null || bloodGroup == null || hospitalName == null || city == null || contactPhone == null ||
            patientName.trim().isEmpty() || hospitalName.trim().isEmpty() || city.trim().isEmpty() || contactPhone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in all mandatory fields.");
            request.getRequestDispatcher("/WEB-INF/views/request/create.jsp").forward(request, response);
            return;
        }

        int unitsNeeded = 1;
        try {
            if (unitsStr != null && !unitsStr.trim().isEmpty()) {
                unitsNeeded = Integer.parseInt(unitsStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        BloodRequest bloodReq = new BloodRequest();
        bloodReq.setRecipientId(recipient != null ? recipient.getRecipientId() : 1);
        bloodReq.setPatientName(patientName.trim());
        bloodReq.setBloodGroup(bloodGroup);
        bloodReq.setUnitsNeeded(unitsNeeded);
        bloodReq.setHospitalName(hospitalName.trim());
        bloodReq.setHospitalAddress(hospitalAddress != null ? hospitalAddress.trim() : "");
        bloodReq.setCity(city.trim());
        bloodReq.setState(state != null ? state.trim() : "");
        bloodReq.setUrgency(urgency != null ? urgency : "NORMAL");
        bloodReq.setContactPhone(contactPhone.trim());
        bloodReq.setNote(note != null ? note.trim() : "");

        boolean created = requestDAO.createRequest(bloodReq);

        if (created) {
            HttpSession session = request.getSession();
            session.setAttribute("toastSuccess", "Blood donation request created successfully!");
            response.sendRedirect(request.getContextPath() + "/recipient/dashboard");
        } else {
            request.setAttribute("errorMessage", "Failed to submit request due to a server error.");
            request.getRequestDispatcher("/WEB-INF/views/request/create.jsp").forward(request, response);
        }
    }

    private void handleRespondToRequest(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        Donor donor = donorDAO.getDonorByUserId(user.getUserId());
        if (donor == null) {
            request.getSession().setAttribute("toastError", "Only registered donors can respond to requests.");
            response.sendRedirect(request.getContextPath() + "/request/list");
            return;
        }

        String reqIdStr = request.getParameter("requestId");
        String message = request.getParameter("message");

        if (reqIdStr != null && !reqIdStr.isEmpty()) {
            int requestId = Integer.parseInt(reqIdStr);
            boolean success = requestDAO.respondToRequest(requestId, donor.getDonorId(), message);
            if (success) {
                request.getSession().setAttribute("toastSuccess", "Response sent to recipient successfully!");
            } else {
                request.getSession().setAttribute("toastError", "Failed to respond to request.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/donor/dashboard");
    }

    private void handleViewResponses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reqIdStr = request.getParameter("requestId");
        if (reqIdStr != null && !reqIdStr.isEmpty()) {
            int requestId = Integer.parseInt(reqIdStr);
            BloodRequest bloodReq = requestDAO.getRequestById(requestId);
            List<RequestResponse> responses = requestDAO.getResponsesForRequest(requestId);
            request.setAttribute("bloodReq", bloodReq);
            request.setAttribute("responses", responses);
        }
        request.getRequestDispatcher("/WEB-INF/views/request/responses.jsp").forward(request, response);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String reqIdStr = request.getParameter("requestId");
        String status = request.getParameter("status");
        String responseIdStr = request.getParameter("responseId");

        if (reqIdStr != null && status != null) {
            int requestId = Integer.parseInt(reqIdStr);
            requestDAO.updateRequestStatus(requestId, status);
        }

        if (responseIdStr != null && status != null) {
            int respId = Integer.parseInt(responseIdStr);
            requestDAO.updateResponseStatus(respId, status);
        }

        String referer = request.getHeader("referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/recipient/dashboard");
        }
    }
}

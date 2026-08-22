package com.bloodconnect.controller;

import com.bloodconnect.dao.DonorDAO;
import com.bloodconnect.dao.RequestDAO;
import com.bloodconnect.dao.UserDAO;
import com.bloodconnect.model.Donor;
import com.bloodconnect.model.Recipient;
import com.bloodconnect.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO;
    private DonorDAO donorDAO;
    private RequestDAO requestDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        donorDAO = new DonorDAO();
        requestDAO = new RequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/login":
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                break;
            case "/logout":
                handleLogout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegistration(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and Password are required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticateUser(email, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);

            // Fetch specific profile info and attach to session
            if (user.isDonor()) {
                Donor donor = donorDAO.getDonorByUserId(user.getUserId());
                session.setAttribute("donorProfile", donor);
                response.sendRedirect(request.getContextPath() + "/donor/dashboard");
            } else if (user.isRecipient()) {
                Recipient recipient = requestDAO.getRecipientByUserId(user.getUserId());
                session.setAttribute("recipientProfile", recipient);
                response.sendRedirect(request.getContextPath() + "/recipient/dashboard");
            } else if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password, or your account is deactivated.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String address = request.getParameter("address");

        if (name == null || email == null || password == null || phone == null || role == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || phone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All required basic fields (Name, Email, Password, Phone) must be filled.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        if (city == null || state == null || address == null ||
            city.trim().isEmpty() || state.trim().isEmpty() || address.trim().isEmpty()) {
            request.setAttribute("errorMessage", "City, State, and Full Address are required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        if (!"DONOR".equalsIgnoreCase(role) && !"RECIPIENT".equalsIgnoreCase(role)) {
            request.setAttribute("errorMessage", "Please select a valid registration role (Donor or Recipient).");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (userDAO.findByEmail(email) != null) {
            request.setAttribute("errorMessage", "An account with this email already exists.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPasswordHash(password);
        user.setPhone(phone.trim());
        user.setRole(role.toUpperCase());

        Donor donor = null;
        Recipient recipient = null;

        if ("DONOR".equalsIgnoreCase(role)) {
            String bloodGroup = request.getParameter("bloodGroup");
            String gender = request.getParameter("gender");

            if (bloodGroup == null || bloodGroup.trim().isEmpty() || gender == null || gender.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Blood Group and Gender are required for Donors.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }

            donor = new Donor();
            donor.setBloodGroup(bloodGroup.trim());
            
            String ageStr = request.getParameter("age");
            int age = 18;
            if (ageStr != null && !ageStr.trim().isEmpty()) {
                try {
                    age = Integer.parseInt(ageStr.trim());
                } catch (NumberFormatException ignored) {}
            }
            donor.setAge(age);
            donor.setGender(gender.trim().toUpperCase());

            String lastDonationStr = request.getParameter("lastDonationDate");
            if (lastDonationStr != null && !lastDonationStr.trim().isEmpty()) {
                try {
                    donor.setLastDonationDate(Date.valueOf(lastDonationStr.trim()));
                } catch (IllegalArgumentException ignored) {}
            }
            donor.setAvailability(true);
            donor.setCity(city.trim());
            donor.setState(state.trim());
            donor.setAddress(address.trim());

        } else if ("RECIPIENT".equalsIgnoreCase(role)) {
            recipient = new Recipient();
            recipient.setCity(city.trim());
            recipient.setState(state.trim());
            recipient.setAddress(address.trim());
        }

        boolean success = userDAO.registerUser(user, donor, recipient);

        if (success) {
            request.setAttribute("successMessage", "Registration successful! You can now log in.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login?logout=true");
    }
}

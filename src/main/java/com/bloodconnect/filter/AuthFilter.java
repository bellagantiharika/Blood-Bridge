package com.bloodconnect.filter;

import com.bloodconnect.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        // Static resources and public routes bypass filter
        if (path.startsWith("/static/") || path.startsWith("/css/") || path.startsWith("/js/") ||
            path.equals("/login") || path.equals("/register") || path.equals("/logout") ||
            path.equals("/") || path.equals("/index.jsp") || path.equals("/search") ||
            path.equals("/about") || path.equals("/contact")) {
            chain.doFilter(request, response);
            return;
        }

        // Session validation
        HttpSession session = httpRequest.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            httpRequest.setAttribute("errorMessage", "Please log in to access this page.");
            httpRequest.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(httpRequest, httpResponse);
            return;
        }

        // Role-based authorization
        if (path.startsWith("/admin") && !loggedInUser.isAdmin()) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin privileges required.");
            return;
        }

        if (path.startsWith("/donor") && !loggedInUser.isDonor() && !loggedInUser.isAdmin()) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Donor account required.");
            return;
        }

        if (path.startsWith("/recipient") && !loggedInUser.isRecipient() && !loggedInUser.isAdmin()) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Recipient account required.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}

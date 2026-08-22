package com.bloodconnect.controller;

import com.bloodconnect.dao.DonorDAO;
import com.bloodconnect.model.Donor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private DonorDAO donorDAO;

    @Override
    public void init() throws ServletException {
        donorDAO = new DonorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bloodGroup = request.getParameter("bloodGroup");
        String city = request.getParameter("city");
        String state = request.getParameter("state");

        List<Donor> donorsList = donorDAO.searchDonors(bloodGroup, city, state);

        request.setAttribute("bloodGroup", bloodGroup);
        request.setAttribute("city", city);
        request.setAttribute("state", state);
        request.setAttribute("donorsList", donorsList);
        request.setAttribute("totalResults", donorsList.size());

        request.getRequestDispatcher("/WEB-INF/views/search/search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

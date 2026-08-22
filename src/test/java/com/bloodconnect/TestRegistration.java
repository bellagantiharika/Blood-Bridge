package com.bloodconnect;

import com.bloodconnect.dao.UserDAO;
import com.bloodconnect.model.Donor;
import com.bloodconnect.model.Recipient;
import com.bloodconnect.model.User;

public class TestRegistration {
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        
        System.out.println("=== TEST 1: Donor registration with full data & null last donation date ===");
        User u1 = new User();
        u1.setName("Alice Donor");
        u1.setEmail("alice.donor." + System.currentTimeMillis() + "@example.com");
        u1.setPasswordHash("password123");
        u1.setPhone("9876543210");
        u1.setRole("DONOR");

        Donor d1 = new Donor();
        d1.setBloodGroup("A+");
        d1.setAge(26);
        d1.setGender("FEMALE");
        d1.setLastDonationDate(null);
        d1.setCity("Seattle");
        d1.setState("WA");
        d1.setAddress("100 Pine Street");

        boolean res1 = userDAO.registerUser(u1, d1, null);
        System.out.println("Result 1 (Donor registration): " + res1 + " (User ID: " + u1.getUserId() + ")");

        System.out.println("=== TEST 2: Recipient registration ===");
        User u2 = new User();
        u2.setName("Bob Recipient");
        u2.setEmail("bob.recipient." + System.currentTimeMillis() + "@example.com");
        u2.setPasswordHash("password123");
        u2.setPhone("9876543211");
        u2.setRole("RECIPIENT");

        Recipient r2 = new Recipient();
        r2.setCity("Boston");
        r2.setState("MA");
        r2.setAddress("200 Beacon Street");

        boolean res2 = userDAO.registerUser(u2, null, r2);
        System.out.println("Result 2 (Recipient registration): " + res2 + " (User ID: " + u2.getUserId() + ")");

        if (res1 && res2) {
            System.out.println("ALL REGISTRATION INTEGRATION TESTS PASSED!");
        } else {
            System.err.println("TEST FAILURES DETECTED!");
            System.exit(1);
        }
    }
}

package com.bloodconnect.model;

import java.io.Serializable;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Donor implements Serializable {
    private static final long serialVersionUID = 1L;

    private int donorId;
    private int userId;
    private String bloodGroup; // A+, A-, B+, B-, AB+, AB-, O+, O-
    private int age;
    private String gender; // MALE, FEMALE, OTHER
    private Date lastDonationDate;
    private boolean availability;
    private String city;
    private String state;
    private String address;

    // Associated User object for joined queries
    private User user;

    public Donor() {}

    public Donor(int donorId, int userId, String bloodGroup, int age, String gender, Date lastDonationDate, boolean availability, String city, String state, String address) {
        this.donorId = donorId;
        this.userId = userId;
        this.bloodGroup = bloodGroup;
        this.age = age;
        this.gender = gender;
        this.lastDonationDate = lastDonationDate;
        this.availability = availability;
        this.city = city;
        this.state = state;
        this.address = address;
    }

    // Getters and Setters
    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public Date getLastDonationDate() { return lastDonationDate; }
    public void setLastDonationDate(Date lastDonationDate) { this.lastDonationDate = lastDonationDate; }

    public boolean isAvailability() { return availability; }
    public void setAvailability(boolean availability) { this.availability = availability; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    /**
     * Check donor eligibility (Must be 90+ days since last donation date).
     */
    public boolean isEligibleToDonate() {
        if (lastDonationDate == null) {
            return true; // Never donated before -> Eligible
        }
        LocalDate lastDonation = lastDonationDate.toLocalDate();
        LocalDate today = LocalDate.now();
        long daysPassed = ChronoUnit.DAYS.between(lastDonation, today);
        return daysPassed >= 90;
    }

    /**
     * Days remaining until next eligible donation date.
     */
    public long getDaysUntilNextDonation() {
        if (lastDonationDate == null) return 0;
        LocalDate lastDonation = lastDonationDate.toLocalDate();
        LocalDate nextEligible = lastDonation.plusDays(90);
        long daysRemaining = ChronoUnit.DAYS.between(LocalDate.now(), nextEligible);
        return Math.max(0, daysRemaining);
    }
}

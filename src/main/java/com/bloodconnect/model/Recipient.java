package com.bloodconnect.model;

import java.io.Serializable;

public class Recipient implements Serializable {
    private static final long serialVersionUID = 1L;

    private int recipientId;
    private int userId;
    private String city;
    private String state;
    private String address;

    // Associated User object
    private User user;

    public Recipient() {}

    public Recipient(int recipientId, int userId, String city, String state, String address) {
        this.recipientId = recipientId;
        this.userId = userId;
        this.city = city;
        this.state = state;
        this.address = address;
    }

    public int getRecipientId() { return recipientId; }
    public void setRecipientId(int recipientId) { this.recipientId = recipientId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}

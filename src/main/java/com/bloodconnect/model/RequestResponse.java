package com.bloodconnect.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class RequestResponse implements Serializable {
    private static final long serialVersionUID = 1L;

    private int responseId;
    private int requestId;
    private int donorId;
    private String status; // PENDING, ACCEPTED, DECLINED, COMPLETED
    private String message;
    private Timestamp respondedAt;

    // Joined info
    private Donor donor;
    private BloodRequest bloodRequest;

    public RequestResponse() {}

    public int getResponseId() { return responseId; }
    public void setResponseId(int responseId) { this.responseId = responseId; }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getRespondedAt() { return respondedAt; }
    public void setRespondedAt(Timestamp respondedAt) { this.respondedAt = respondedAt; }

    public Donor getDonor() { return donor; }
    public void setDonor(Donor donor) { this.donor = donor; }

    public BloodRequest getBloodRequest() { return bloodRequest; }
    public void setBloodRequest(BloodRequest bloodRequest) { this.bloodRequest = bloodRequest; }
}

// src/main/java/com/ems/model/Guest.java
package com.ems.model;

import java.sql.Timestamp;

public class Guest {
    private int guestId;
    private int eventId; // Foreign Key to Events table
    private String name;
    private String email;
    private String phone;
    private String rsvpStatus; // e.g., "Pending", "Confirmed", "Declined"
    private Timestamp invitationSentDate;
    private Timestamp rsvpResponseDate;

    // Default constructor
    public Guest() {}

    // Constructor for adding a new guest
    public Guest(int eventId, String name, String email, String phone) {
        this.eventId = eventId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.rsvpStatus = "Pending"; // Default status
    }

    // Getters and Setters
    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRsvpStatus() { return rsvpStatus; }
    public void setRsvpStatus(String rsvpStatus) { this.rsvpStatus = rsvpStatus; }

    public Timestamp getInvitationSentDate() { return invitationSentDate; }
    public void setInvitationSentDate(Timestamp invitationSentDate) { this.invitationSentDate = invitationSentDate; }

    public Timestamp getRsvpResponseDate() { return rsvpResponseDate; }
    public void setRsvpResponseDate(Timestamp rsvpResponseDate) { this.rsvpResponseDate = rsvpResponseDate; }
}


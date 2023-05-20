package com.johnesleyer.QRApp3.Entities;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;

@Entity
@Table(name = "student")
public class Student {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String username;
    private String password;
    private String firstName;
    private String lastName;
    private int schoolYear;

    @OneToOne(mappedBy = "student", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private ClassAttendance classAttendance;

    @OneToMany(mappedBy = "student", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<StudentClassroom> studentClassrooms;
    
    // Getters and setters
    public long getId() {
        return this.id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFirstName() {
        return this.firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return this.lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getSchoolYear() {
        return this.schoolYear;
    }

    public void setSchoolYear(int schoolYear) {
        this.schoolYear = schoolYear;
    }
    
}

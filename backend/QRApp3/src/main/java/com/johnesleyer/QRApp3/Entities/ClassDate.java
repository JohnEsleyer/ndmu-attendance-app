package com.johnesleyer.QRApp3.Entities;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.persistence.*;

@Entity
@Table(name = "classDate")
public class ClassDate {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne 
    @JoinColumn(name = "classroom_id")
    private Classroom classroom;

    @JsonFormat(pattern = "MM/dd/yyyy")
    private Date date;
    
    private String time;
    private String defaultTime;
    
    // Getters and setters

    public long getId() {
        return this.id;
    }

    public void setId(long id) {
        this.id = id;
    }



    public Classroom getClassroom() {
        return this.classroom;
    }

    public void setClassroom(Classroom classroom) {
        this.classroom = classroom;
    }


    public Date getdate() {
        return this.date;
    }

    public void setdate(Date date) {
        this.date = date;
    }

    public String getTime() {
        return this.time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getDefaultTime() {
        return this.defaultTime;
    }

    public void setDefaultTime(String defaultTime) {
        this.defaultTime = defaultTime;
    }

    
}

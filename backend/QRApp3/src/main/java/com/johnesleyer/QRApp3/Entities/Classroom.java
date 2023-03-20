package com.johnesleyer.QRApp3.Entities;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.persistence.*;

@Entity
@Table(name = "classroom")
public class Classroom {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String className;
    
    @JsonFormat(pattern = "yyyy/MM/dd")
    private Date schedule;

    private String time;

    @ManyToOne
    @JoinColumn(name = "teacher_id")
    private Teacher teacher;


    public String getTime() {
        return this.time;
    }

    public void setTime(String time) {
        this.time = time;
    }
    
    public Teacher getTeacher() {
        return this.teacher;
    }

    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }


    public long getId() {
        return this.id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getClassName() {
        return this.className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public Date getSchedule() {
        return this.schedule;
    }

    public void setSchedule(Date schedule) {
        this.schedule = schedule;
    }
    
    
}

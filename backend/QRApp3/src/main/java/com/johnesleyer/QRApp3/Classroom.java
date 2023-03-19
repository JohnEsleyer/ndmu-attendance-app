package com.johnesleyer.QRApp3;

import java.sql.Date;

import jakarta.persistence.*;

@Entity
@Table(name = "classroom")
public class Classroom {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String className;
    private Date schedule;
    @ManyToOne
    @JoinColumn(name = "teacher_id")
    private Teacher teacher;

    
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
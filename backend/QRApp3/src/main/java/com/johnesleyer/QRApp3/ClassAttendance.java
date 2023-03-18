package com.johnesleyer.QRApp3;

import java.sql.Date;

import jakarta.persistence.*;

@Entity
@Table(name = "classAttendance")
public class ClassAttendance {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private Date date;

    @ManyToOne
    @JoinColumn(name = "classroom_id")
    private Classroom classroom;

    @OneToOne 
    @JoinColumn(name = "student_id")
    private Student student;

    private String status;



    public long getId() {
        return this.id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Date getDate() {
        return this.date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Classroom getClassroom() {
        return this.classroom;
    }

    public void setClassroom(Classroom classroom) {
        this.classroom = classroom;
    }

    public Student getStudent() {
        return this.student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    
    
}

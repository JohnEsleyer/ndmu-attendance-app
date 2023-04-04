package com.johnesleyer.QRApp3.Controllers;


import com.johnesleyer.QRApp3.Entities.Student;

public class StudentDateRequest {
    private Student student;
    private String date;


    public Student getStudent() {
        return this.student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public String getDate() {
        return this.date;
    }

    public void setDate(String date) {
        this.date = date;
    }

}

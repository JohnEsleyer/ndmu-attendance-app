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

   @ManyToOne 
   @JoinColumn(name = "teacher_id")
   private Teacher teacher; 


    // The default schedule, set during the creation of the classroom
   @JsonFormat(pattern = "mm/dd/yyyy")
   private Date schedule;

   // The default time which is set during the creation of the classroom
   private String defaultTime;

   private String className;
   
   private String qrURL;
   private String qrValue;


    public String getQrURL() {
        return this.qrURL;
    }

    public void setQrURL(String qrURL) {
        this.qrURL = qrURL;
    }

    public String getQrValue() {
        return this.qrValue;
    }

    public void setQrValue(String qrValue) {
        this.qrValue = qrValue;
    }


    public String getDefaultTime() {
        return this.defaultTime;
    }

    public void setDefaultTime(String defaultTime) {
        this.defaultTime = defaultTime;
    }


   public String getClassName() {
       return this.className;
   }

   public void setClassName(String className) {
       this.className = className;
   }
   
    public long getId() {
        return this.id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Teacher getTeacher() {
        return this.teacher;
    }

    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }

    public Date getSchedule() {
        return this.schedule;
    }

    public void setSchedule(Date schedule) {
        this.schedule = schedule;
    }



    
}

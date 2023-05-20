package com.johnesleyer.QRApp3.Entities;



import java.sql.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.persistence.*;

@Entity
@Table(name = "classroom")
public class Classroom {
   @Id 
   @GeneratedValue(strategy = GenerationType.IDENTITY)
   private long id;

   @ManyToOne(cascade = CascadeType.REMOVE)
   @JoinColumn(name = "teacher_id")
   private Teacher teacher; 


    // The default schedule, set during the creation of the classroom
   @JsonFormat(pattern = "MM/dd/yyyy")
   private Date schedule;

   // The default time which is set during the creation of the classroom
   private String defaultTime;

   private String className;
   
   private String qrURL;
   private String qrValue;

   @OneToMany(mappedBy = "classroom", cascade = CascadeType.REMOVE)
   private List<StudentClassroom> studentClassrooms;

   @OneToMany(mappedBy = "classroom", cascade = CascadeType.REMOVE)
   private List<ClassDate> classDates;

   @OneToMany(mappedBy = "classroom", cascade = CascadeType.REMOVE)
   private List<ClassAttendance> classAttendances;

   
  


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

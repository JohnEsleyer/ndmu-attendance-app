package com.johnesleyer.QRApp3.Entities;

import java.sql.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.springframework.data.annotation.Id;

import com.fasterxml.jackson.annotation.JsonFormat;

@Entity
@Table(name = "classDate")
public class ClassDate {
   @Id 
   @GeneratedValue(strategy = GenerationType.IDENTITY)
   private long id;

   @ManyToOne 
   @JoinColumn(name = "classroom_id")
   private Classroom classroom; 

   // Default is current date, which will be provided by the client
   @JsonFormat(pattern = "yyyy/MM/dd")
   private Date schedule;

   // The time value to be processed and sent to the client
   private String time;

   // The default time which is set during the creation of the classroom
   private String defaultTime;
   



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

    public Date getSchedule() {
        return this.schedule;
    }

    public void setSchedule(Date schedule) {
        this.schedule = schedule;
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
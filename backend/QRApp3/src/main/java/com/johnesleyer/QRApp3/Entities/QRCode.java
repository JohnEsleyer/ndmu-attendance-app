package com.johnesleyer.QRApp3.Entities;


import jakarta.persistence.*;

@Entity
@Table(name = "qrcode")
public class QRCode {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String value;
    private String imageURL;
    @OneToOne
    @JoinColumn(name = "classroom_id")
    private Classroom classroom;


    public long getId() {
        return this.id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getValue() {
        return this.value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getImageURL() {
        return this.imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public Classroom getClassroom() {
        return this.classroom;
    }

    public void setClassroom(Classroom classroom) {
        this.classroom = classroom;
    }
    

}

package com.johnesleyer.QRApp3;



import jakarta.persistence.*;

@Entity
@Table(name = "studentClassroom")
public class StudentClassroom {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne 
    @JoinColumn(name = "student_id")
    private Student student;

    @ManyToOne
    @JoinColumn(name = "classroom_id")
    private Classroom classroom;

   
    
}

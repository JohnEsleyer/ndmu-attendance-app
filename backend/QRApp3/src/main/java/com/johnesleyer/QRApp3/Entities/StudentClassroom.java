package com.johnesleyer.QRApp3.Entities;



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

    

    public long getId() {
        return this.id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Student getStudent() {
        return this.student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Classroom getClassroom() {
        return this.classroom;
    }

    public void setClassroom(Classroom classroom) {
        this.classroom = classroom;
    }
    
}

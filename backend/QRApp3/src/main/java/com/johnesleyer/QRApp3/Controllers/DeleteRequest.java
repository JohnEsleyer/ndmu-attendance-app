package com.johnesleyer.QRApp3.Controllers;

public class DeleteRequest {
    private StudentRequest student;
    private ClassroomRequest classroom;

    public StudentRequest getStudent() {
        return student;
    }

    public void setStudent(StudentRequest student) {
        this.student = student;
    }

    public ClassroomRequest getClassroom() {
        return classroom;
    }

    public void setClassroom(ClassroomRequest classroom) {
        this.classroom = classroom;
    }
}

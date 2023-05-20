package com.johnesleyer.QRApp3.Controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.ClassAttendance;
import com.johnesleyer.QRApp3.Entities.Student;
import com.johnesleyer.QRApp3.Repositories.StudentRepository;


@RestController
public class StudentController {
    private final StudentRepository studentRepository;

    @Autowired
    private StudentService studentService;

    public StudentController(StudentRepository studentRepository){
        this.studentRepository = studentRepository;
    }

    @PostMapping("/register-student")
    public Student registerStudent(@RequestBody Student student){
        return studentRepository.save(student);
    }

    @GetMapping("/all-students")
    public List<Student> getAllStudents(){
        return studentRepository.findAll();
    }

    @PostMapping("/update-student")
    public ResponseEntity<Student> updateStudent(@RequestBody Student student) {
        Optional<Student> existingStudentOptional = studentRepository.findById(student.getId());

        if (existingStudentOptional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Student existingStudent = existingStudentOptional.get();
        existingStudent.setUsername(student.getUsername());
        existingStudent.setPassword(student.getPassword());
        existingStudent.setFirstName(student.getFirstName());
        existingStudent.setLastName(student.getLastName());
        existingStudent.setSchoolYear(student.getSchoolYear());

        Student updatedStudent = studentRepository.save(existingStudent);

        return ResponseEntity.ok(updatedStudent);
    }
    @DeleteMapping("/delete-student")
    public ResponseEntity<Void> deleteStudent(@RequestBody Student student) {
        Optional<Student> optionalStudent = studentRepository.findById(student.getId());
        if (optionalStudent.isPresent()) {
            studentRepository.delete(optionalStudent.get());
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    



}

package com.johnesleyer.QRApp3.Controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.Student;
import com.johnesleyer.QRApp3.Repositories.StudentRepository;


@RestController
public class StudentController {
    private final StudentRepository studentRepository;

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
}

package com.johnesleyer.QRApp3.Controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.StudentClassroom;


@RestController
public class StudentClassroomController {
    private final StudentClassroomRepository StudentClassroomRepository;

    public StudentClassroomController(StudentClassroomRepository StudentClassroomRepository){
        this.StudentClassroomRepository = StudentClassroomRepository;
    }

    @PostMapping("/register-studentClassroom")
    public StudentClassroom registerStudentClassroom(@RequestBody StudentClassroom StudentClassroom){
        return StudentClassroomRepository.save(StudentClassroom);
    }

    @GetMapping("/all-studentClassrooms")
    public List<StudentClassroom> getAllStudentClassrooms(){
        return StudentClassroomRepository.findAll();
    }
}

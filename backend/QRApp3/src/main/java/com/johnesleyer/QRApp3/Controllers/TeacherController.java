package com.johnesleyer.QRApp3.Controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.Teacher;
import com.johnesleyer.QRApp3.Repositories.TeacherRepository;


@RestController
public class TeacherController {
    private final TeacherRepository TeacherRepository;

    public TeacherController(TeacherRepository TeacherRepository){
        this.TeacherRepository = TeacherRepository;
    }

    @PostMapping("/register-teacher")
    public Teacher registerTeacher(@RequestBody Teacher Teacher){
        return TeacherRepository.save(Teacher);
    }

    @GetMapping("/all-teachers")
    public List<Teacher> getAllTeachers(){
        return TeacherRepository.findAll();
    }
}

package com.johnesleyer.QRApp3.Controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.Teacher;
import com.johnesleyer.QRApp3.Repositories.TeacherRepository;


@RestController
public class TeacherController {
    private final TeacherRepository teacherRepository;

    public TeacherController(TeacherRepository TeacherRepository){
        this.teacherRepository = TeacherRepository;
    }

    @PostMapping("/register-teacher")
    public Teacher registerTeacher(@RequestBody Teacher Teacher){
        return teacherRepository.save(Teacher);
    }

    @GetMapping("/all-teachers")
    public List<Teacher> getAllTeachers(){
        return teacherRepository.findAll();
    }


    @PostMapping("/update-teacher")
    public ResponseEntity<Teacher> updateTeacher(@RequestBody Teacher teacher) {
        Optional<Teacher> existingTeacherOptional = teacherRepository.findById(teacher.getId());

        if (existingTeacherOptional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Teacher existingTeacher = existingTeacherOptional.get();
        existingTeacher.setUsername(teacher.getUsername());
        existingTeacher.setPassword(teacher.getPassword());
        existingTeacher.setFirstName(teacher.getFirstName());
        existingTeacher.setLastName(teacher.getLastName());

        Teacher updatedTeacher = teacherRepository.save(existingTeacher);

        return ResponseEntity.ok(updatedTeacher);
    }

    @DeleteMapping("/delete-teacher")
    public ResponseEntity<Void> deleteTeacher(@RequestBody Teacher teacher) {
        Optional<Teacher> optionalTeacher = teacherRepository.findById(teacher.getId());
        if (optionalTeacher.isPresent()) {
            teacherRepository.delete(optionalTeacher.get());
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}

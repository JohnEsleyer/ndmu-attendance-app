package com.johnesleyer.QRApp3;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class ClassroomController {
    private final ClassroomRepository ClassroomRepository;

    public ClassroomController(ClassroomRepository ClassroomRepository){
        this.ClassroomRepository = ClassroomRepository;
    }

    @PostMapping("/register-classroom")
    public Classroom registerClassroom(@RequestBody Classroom Classroom){
        return ClassroomRepository.save(Classroom);
    }

    @GetMapping("/all-classrooms")
    public List<Classroom> getAllClassrooms(){
        return ClassroomRepository.findAll();
    }
}

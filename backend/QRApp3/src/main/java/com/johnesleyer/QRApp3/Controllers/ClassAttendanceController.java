package com.johnesleyer.QRApp3.Controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.ClassAttendance;
import com.johnesleyer.QRApp3.Repositories.ClassAttendanceRepository;


@RestController
public class ClassAttendanceController {
    private final ClassAttendanceRepository ClassAttendanceRepository;

    public ClassAttendanceController(ClassAttendanceRepository ClassAttendanceRepository){
        this.ClassAttendanceRepository = ClassAttendanceRepository;
    }

    @PostMapping("/register-classAttendance")
    public ClassAttendance registerClassAttendance(@RequestBody ClassAttendance ClassAttendance){
        return ClassAttendanceRepository.save(ClassAttendance);
    }

    @GetMapping("/all-classAttendances")
    public List<ClassAttendance> getAllClassAttendances(){
        return ClassAttendanceRepository.findAll();
    }
}

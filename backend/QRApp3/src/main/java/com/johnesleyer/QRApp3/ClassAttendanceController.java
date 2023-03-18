package com.johnesleyer.QRApp3;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;


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

package com.johnesleyer.QRApp3.Controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.ClassAttendance;
import com.johnesleyer.QRApp3.Entities.Classroom;
import com.johnesleyer.QRApp3.Repositories.ClassAttendanceRepository;


@RestController
public class ClassAttendanceController {
    private final ClassAttendanceRepository classAttendanceRepository;

    public ClassAttendanceController(ClassAttendanceRepository classAttendanceRepository){
        this.classAttendanceRepository = classAttendanceRepository;
    }

    @PostMapping("/register-classAttendance")
    public ClassAttendance registerClassAttendance(@RequestBody ClassAttendance classAttendance){
        return classAttendanceRepository.save(classAttendance);
    }

    @GetMapping("/all-classAttendances")
    public List<ClassAttendance> getAllClassAttendances(){
        return classAttendanceRepository.findAll();
    }
    
    @PostMapping("/attendance-by-dateclass")
    public List<ClassAttendance> getClassAttendanceByDateAndClassroom(@RequestBody Map<String, Object> requestData) {
        String dateString = (String) requestData.get("date");
        DateFormat format = new SimpleDateFormat("MM/dd/yyyy");
        Date date = null;
        try {
            date = format.parse(dateString);
        } catch (ParseException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
        Long classroomId = Long.parseLong(((Map<String, Object>) requestData.get("classroom")).get("id").toString());
        Classroom classroom = new Classroom();
        classroom.setId(classroomId);
        return classAttendanceRepository.findByDateAndClassroom(date, classroom);
    }

    @PostMapping("/count-status-student")
    public ResponseEntity<Map<String, Object>> countStatusByStudent(@RequestBody Map<String, Map<String, Long>> requestBody) {
        Long studentId = requestBody.get("student").get("id");
        List<ClassAttendance> attendances = classAttendanceRepository.findByStudentId(studentId);
        Map<String, Integer> counts = new HashMap<>();
        String[] statusValues = {"absent", "late", "present"};
    
        // Initialize all status counts to 0
        for (String status : statusValues) {
            counts.put(status, 0);
        }
    
        // Loop through all attendances and count by status
        for (ClassAttendance attendance : attendances) {
            String status = attendance.getStatus();
    
            // Increment the count for the status
            counts.put(status, counts.getOrDefault(status, 0) + 1);
        }
    
        // Create the response JSON object
        Map<String, Object> response = new HashMap<>();
        response.put("student", requestBody.get("student"));
        response.putAll(counts);
    
        return ResponseEntity.ok(response);
    }
    
}

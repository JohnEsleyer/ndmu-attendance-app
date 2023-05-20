package com.johnesleyer.QRApp3.Controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.ClassAttendance;
import com.johnesleyer.QRApp3.Entities.Classroom;
import com.johnesleyer.QRApp3.Entities.StudentClassroom;
import com.johnesleyer.QRApp3.Repositories.ClassAttendanceRepository;
import com.johnesleyer.QRApp3.Repositories.StudentClassroomRepository;


@RestController
public class ClassAttendanceController {
    private final ClassAttendanceRepository classAttendanceRepository;
    


    @Autowired
    private final StudentClassroomRepository studentClassroomRepository;

    public ClassAttendanceController(ClassAttendanceRepository classAttendanceRepository, StudentClassroomRepository studentClassroomRepository){
        this.classAttendanceRepository = classAttendanceRepository;
        this.studentClassroomRepository = studentClassroomRepository;
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

    @PostMapping("/status-by-student-classroom")
    public ResponseEntity<Map<String, Object>> getStatusByStudentClassroom(@RequestBody Map<String, Object> request) {
        Long studentId = ((Number) ((Map<String, Object>) request.get("student")).get("id")).longValue();
        Long classroomId = ((Number) ((Map<String, Object>) request.get("classroom")).get("id")).longValue();

        Map<String, Object> response = new HashMap<>();
        response.put("student", request.get("student"));

        // Count attendance by status
        int presentCount = classAttendanceRepository.countByStudentIdAndClassroomIdAndStatus(studentId, classroomId, "present");
        int absentCount = classAttendanceRepository.countByStudentIdAndClassroomIdAndStatus(studentId, classroomId, "absent");
        int lateCount = classAttendanceRepository.countByStudentIdAndClassroomIdAndStatus(studentId, classroomId, "late");

        response.put("present", presentCount);
        response.put("absent", absentCount);
        response.put("late", lateCount);

        return ResponseEntity.ok(response);
    }


    @GetMapping("/students-status-by-classroom")
    public ResponseEntity<List<Map<String, Object>>> getStudentsStatusByClassroom(@RequestBody Map<String, Object> request) {
        Long classroomId = ((Number) ((Map<String, Object>) request.get("classroom")).get("id")).longValue();

        List<StudentClassroom> studentClassrooms = studentClassroomRepository.findByClassroomId(classroomId);
        List<Map<String, Object>> response = new ArrayList<>();

        for (StudentClassroom studentClassroom : studentClassrooms) {
            Long studentId = studentClassroom.getStudent().getId();
            String studentFirstName = studentClassroom.getStudent().getFirstName();
            String studentLastName = studentClassroom.getStudent().getLastName();
            Map<String, Object> studentStatus = new HashMap<>();
            // studentStatus.put("student", Map.of("id", studentId));
            studentStatus.put("studentFirst", Map.of("firstName", studentFirstName));
            studentStatus.put("studentLast", Map.of("lastName", studentLastName));

            int presentCount = classAttendanceRepository.countByStudentIdAndClassroomIdAndStatus(studentId, classroomId, "present");
            int absentCount = classAttendanceRepository.countByStudentIdAndClassroomIdAndStatus(studentId, classroomId, "absent");
            int lateCount = classAttendanceRepository.countByStudentIdAndClassroomIdAndStatus(studentId, classroomId, "late");

            studentStatus.put("present", presentCount);
            studentStatus.put("absent", absentCount);
            studentStatus.put("late", lateCount);

            response.add(studentStatus);
        }

        AttendanceReportGenerator.generateHTMLFile(response);
        return ResponseEntity.ok(response);
    }


    
}

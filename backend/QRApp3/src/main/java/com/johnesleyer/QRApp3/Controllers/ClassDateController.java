package com.johnesleyer.QRApp3.Controllers;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;


import com.johnesleyer.QRApp3.Entities.ClassDate;
import com.johnesleyer.QRApp3.Entities.Classroom;

import com.johnesleyer.QRApp3.Entities.StudentClassroom;
import com.johnesleyer.QRApp3.Repositories.ClassDateRepository;
import com.johnesleyer.QRApp3.Repositories.StudentClassroomRepository;


@RestController
public class ClassDateController {
    private final ClassDateRepository classDateRepository;
    private final StudentClassroomRepository studentClassroomRepository;

    public ClassDateController(ClassDateRepository classDateRepository, StudentClassroomRepository studentClassroomRepository){
        this.classDateRepository = classDateRepository;

        this.studentClassroomRepository = studentClassroomRepository;
    }

    @PostMapping("/register-classDate")
    public ClassDate registerTeacher(@RequestBody ClassDate classDate){
        return classDateRepository.save(classDate);
    }

    @GetMapping("/all-classDates")
    public List<ClassDate> getAllClassDates(){
        return classDateRepository.findAll();
    }

    @PostMapping("/classdate-by-dateclass")
public ResponseEntity<?> getClassAttendanceByDateAndClassroom(@RequestBody Map<String, Object> requestData) {
    String dateString = (String) requestData.get("date");
    DateFormat format = new SimpleDateFormat("MM/dd/yyyy");
    Date date = null;
    try {
        date = format.parse(dateString);
    } catch (ParseException e) {
        e.printStackTrace();
        return ResponseEntity.badRequest().body("Invalid date format.");
    }
    
    LocalDate currentDate = LocalDate.now();
    LocalDate requestedDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    
    Long classroomId = Long.parseLong(((Map<String, Object>) requestData.get("classroom")).get("id").toString());
    Classroom classroom = new Classroom();
    classroom.setId(classroomId);

    if (requestedDate.isBefore(currentDate)) {
        List<ClassDate> classDates = classDateRepository.findByDateAndClassroom(date, classroom);
        if (classDates.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put("response", "past");
            response.put("status", "not set");
            return ResponseEntity.ok().body(response);
        }
        Map<String, Object> response = new HashMap<>();
        response.put("response", "past");
        response.put("status", "set");
        response.put("classDates", classDates);

        return ResponseEntity.ok().body(response);
    } else if (requestedDate.isAfter(currentDate)) {
        List<ClassDate> classDates = classDateRepository.findByDateAndClassroom(date, classroom);
        if (classDates.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put("response", "future");
            response.put("status", "not set");
            return ResponseEntity.ok().body(response);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("response", "future");
        response.put("status", "set");
        response.put("classDates", classDates);
        return ResponseEntity.ok().body(response);
    } else {
        List<ClassDate> classDates = classDateRepository.findByDateAndClassroom(date, classroom);
        if (classDates.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put("response", "present");
            response.put("status", "not set");
            return ResponseEntity.ok().body(response);
        }
        Map<String, Object> response = new HashMap<>();
        response.put("response", "present");
        response.put("status", "set");
        response.put("classDates", classDates);
        return ResponseEntity.ok().body(response);
    }
}

    @PostMapping("/classdates-by-studentdate")
    public List<ClassDate> getClassDatesByStudentAndDate(@RequestBody StudentDateRequest request) throws ParseException {
        List<StudentClassroom> studentClassrooms = studentClassroomRepository.findAllByStudentId(request.getStudent().getId());
        List<ClassDate> classDates = new ArrayList<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        Date date = dateFormat.parse(request.getDate());
        for (StudentClassroom sc : studentClassrooms) {
            List<ClassDate> dates = classDateRepository.findByClassroomAndDate(sc.getClassroom(), date);
            classDates.addAll(dates);
        }
        return classDates;
    }


}

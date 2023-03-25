package com.johnesleyer.QRApp3.Controllers;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.ClassDate;
import com.johnesleyer.QRApp3.Repositories.ClassDateRepository;

@RestController
public class ClassDateController {
    private final ClassDateRepository classDateRepository;

    public ClassDateController(ClassDateRepository classDateRepository){
        this.classDateRepository = classDateRepository;
    }

    @PostMapping("/register-classDate")
    public ClassDate registerTeacher(@RequestBody ClassDate classDate){
        return classDateRepository.save(classDate);
    }

    @GetMapping("/all-classDates")
    public List<ClassDate> getAllClassDates(){
        return classDateRepository.findAll();
    }

    @PostMapping("/class-by-date")
    public List<ClassDate> getClassDatesByDate(@RequestBody Map<String, String> request){
        String dateString = request.get("schedule");
        DateFormat format = new SimpleDateFormat("MM/dd/yyyy");
        Date date = null;
        try {
            date = format.parse(dateString);
        } catch (ParseException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
        return classDateRepository.findBySchedule(new java.sql.Date(date.getTime()));
    }
}

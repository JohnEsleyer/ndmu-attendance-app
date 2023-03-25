package com.johnesleyer.QRApp3.Controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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
}

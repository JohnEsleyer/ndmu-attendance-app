package com.johnesleyer.QRApp3.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.johnesleyer.QRApp3.Entities.Student;
import com.johnesleyer.QRApp3.Repositories.StudentRepository;

@Service
public class StudentService {
    @Autowired 
    private StudentRepository studentRepository;

    public void deleteStudent(Student student){
        studentRepository.delete(student);
    }
}

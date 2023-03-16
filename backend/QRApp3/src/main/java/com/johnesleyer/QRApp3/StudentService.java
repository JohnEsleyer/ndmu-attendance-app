package com.johnesleyer.QRApp3;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StudentService {
    @Autowired
    private StudentRepository studentRepository;

    public Student login(String username, String password) {
        return studentRepository.findByUsernameAndPassword(username, password);
    }
}

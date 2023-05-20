package com.johnesleyer.QRApp3.Controllers;


import java.io.UnsupportedEncodingException;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.Student;
import com.johnesleyer.QRApp3.Entities.Teacher;
import com.johnesleyer.QRApp3.Repositories.StudentRepository;
import com.johnesleyer.QRApp3.Repositories.TeacherRepository;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

@RestController
// @RequestMapping("/api")
public class LoginController {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody LoginRequest loginRequest) throws UnsupportedEncodingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, NoSuchAlgorithmException, NoSuchPaddingException {
        String username = loginRequest.getUsername();
        String password = loginRequest.getPassword();
        
       

        Optional<Student> studentOptional = studentRepository.findByUsername(username);
        Optional<Teacher> teacherOptional = teacherRepository.findByUsername(username);

        if (studentOptional.isPresent()) {
            Student student = studentOptional.get();
            if (password.equals(student.getPassword())) {
                return ResponseEntity.ok().body(new LoginResponse("success", student.getId(), "student"));
            }
        } else if (teacherOptional.isPresent()) {
            Teacher teacher = teacherOptional.get();
            if (password.equals(teacher.getPassword())) {
                return ResponseEntity.ok().body(new LoginResponse("success", teacher.getId(), "teacher"));
            }
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ErrorResponse("Invalid username or password"));
    }
}

package com.johnesleyer.QRApp3.Controllers;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.StudentClassroom;
import com.johnesleyer.QRApp3.Repositories.StudentClassroomRepository;


@RestController
public class StudentClassroomController {
    private final StudentClassroomRepository studentClassroomRepository;


    public StudentClassroomController(StudentClassroomRepository studentClassroomRepository){
        this.studentClassroomRepository = studentClassroomRepository;
    }



    @PostMapping("/register-studentClassroom")
    public StudentClassroom registerStudentClassroom(@RequestBody StudentClassroom studentClassroom){
        return studentClassroomRepository.save(studentClassroom);
    }

    @GetMapping("/all-studentClassrooms")
    public List<StudentClassroom> getAllStudentClassrooms(){
        return studentClassroomRepository.findAll();
    }

    // @PostMapping("/all-classrooms-by-student")
    // public List<StudentClassroom> getAllClassroomsByStudent(@RequestBody Map<String, Map<String, Integer>> requestBody) {
    //     Integer studentId = requestBody.get("student").get("id");
    //     return studentClassroomRepository.findAllByStudentId(studentId);
    // }

    @PostMapping("/all-students-by-classroom")
    public List<StudentClassroom> getAllStudentsByClassroom(@RequestBody Map<String, Map<String, Integer>> requestBody) {
        Integer classroomId = requestBody.get("classroom").get("id");
        return studentClassroomRepository.findAllByClassroomId(classroomId);
    }


    @PostMapping("/all-classrooms-by-student")
    public List<StudentClassroom> getAllClassroomsByStudent(@RequestBody Map<String, Map<String, Integer>> requestBody) {
        Integer studentId = requestBody.get("student").get("id");
        return studentClassroomRepository.findAllByStudentId(studentId);
    }

    @DeleteMapping("/delete-studentClassroom")
    public ResponseEntity<Void> deleteStudentClassroom(@RequestBody DeleteRequest deleteRequest) {
        long studentId = deleteRequest.getStudent().getId();
        long classroomId = deleteRequest.getClassroom().getId();
        
        Optional<StudentClassroom> optionalStudentClassroom = studentClassroomRepository.findByStudentIdAndClassroomId(studentId, classroomId);
        
        if (optionalStudentClassroom.isPresent()) {
            studentClassroomRepository.delete(optionalStudentClassroom.get());
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }



}

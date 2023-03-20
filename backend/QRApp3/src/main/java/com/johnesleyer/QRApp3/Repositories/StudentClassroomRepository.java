package com.johnesleyer.QRApp3.Repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.StudentClassroom;

public interface StudentClassroomRepository extends JpaRepository<StudentClassroom, Integer>{
    List<StudentClassroom> findAllByStudentId(Integer studentId);
}
package com.johnesleyer.QRApp3.Controllers;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.StudentClassroom;

public interface StudentClassroomRepository extends JpaRepository<StudentClassroom, Integer>{
    
}
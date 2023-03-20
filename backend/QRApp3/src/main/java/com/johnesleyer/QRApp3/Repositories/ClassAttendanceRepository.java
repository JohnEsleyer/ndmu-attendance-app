package com.johnesleyer.QRApp3.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.ClassAttendance;

public interface ClassAttendanceRepository extends JpaRepository<ClassAttendance, Integer>{
    
}
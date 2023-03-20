package com.johnesleyer.QRApp3.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.Classroom;

public interface ClassroomRepository extends JpaRepository<Classroom, Integer>{
    
}
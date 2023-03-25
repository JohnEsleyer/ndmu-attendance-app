package com.johnesleyer.QRApp3.Repositories;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.ClassDate;
import com.johnesleyer.QRApp3.Entities.Classroom;


public interface ClassDateRepository extends JpaRepository<ClassDate, Integer>{
    List<ClassDate> findByScheduleAndClassroom(Date date, Classroom classroom);
}
package com.johnesleyer.QRApp3.Repositories;

import java.sql.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.ClassDate;


public interface ClassDateRepository extends JpaRepository<ClassDate, Integer>{
    List<ClassDate> findBySchedule(Date schedule);
}
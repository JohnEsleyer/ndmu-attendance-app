package com.johnesleyer.QRApp3.Repositories;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.ClassAttendance;
import com.johnesleyer.QRApp3.Entities.Classroom;

public interface ClassAttendanceRepository extends JpaRepository<ClassAttendance, Integer>{
    List<ClassAttendance> findByDateAndClassroom(Date date, Classroom classroom);
    List<ClassAttendance> findByStudentId(Long studentId);
    int countByStudentIdAndClassroomIdAndStatus(Long studentId, Long classroomId, String status);
}
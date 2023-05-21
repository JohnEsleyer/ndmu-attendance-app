package com.johnesleyer.QRApp3.Repositories;


import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.Student;

public interface StudentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findByUsername(String username);
    Optional<Student> findById(long id);
    List<Student> findAllByIdNotIn(List<Long> excludedIds);
}


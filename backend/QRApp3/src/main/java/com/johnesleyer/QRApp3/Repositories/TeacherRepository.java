
package com.johnesleyer.QRApp3.Repositories;


import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.Teacher;

public interface TeacherRepository extends JpaRepository<Teacher, Integer> {
    Optional<Teacher> findByUsername(String username);
    Optional<Teacher> findById(long id);
}

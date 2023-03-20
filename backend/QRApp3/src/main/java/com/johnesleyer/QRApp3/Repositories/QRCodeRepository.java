package com.johnesleyer.QRApp3.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.johnesleyer.QRApp3.Entities.QRCode;

public interface QRCodeRepository extends JpaRepository<QRCode, Integer>{
    
}
package com.johnesleyer.QRApp3;

import org.springframework.data.jpa.repository.JpaRepository;

public interface QRCodeRepository extends JpaRepository<QRCode, Integer>{
    
}
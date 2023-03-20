package com.johnesleyer.QRApp3.Controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.johnesleyer.QRApp3.Entities.QRCode;
import com.johnesleyer.QRApp3.Repositories.QRCodeRepository;


@RestController
public class QRCodeController {
    private final QRCodeRepository qrCodeRepository;

    public QRCodeController(QRCodeRepository QRCodeRepository){
        this.qrCodeRepository = QRCodeRepository;
    }

    @PostMapping("/register-qrcode")
    public QRCode registerQRCode(@RequestBody QRCode QRCode){
        return qrCodeRepository.save(QRCode);
    }

    @GetMapping("/all-qrcodes")
    public List<QRCode> getAllQRCodes(){
        return qrCodeRepository.findAll();
    }
}

package com.johnesleyer.QRApp3;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class QRCodeController {
    private final QRCodeRepository QRCodeRepository;

    public QRCodeController(QRCodeRepository QRCodeRepository){
        this.QRCodeRepository = QRCodeRepository;
    }

    @PostMapping("/register-qrcode")
    public QRCode registerQRCode(@RequestBody QRCode QRCode){
        return QRCodeRepository.save(QRCode);
    }

    @GetMapping("/all-qrcodes")
    public List<QRCode> getAllQRCodes(){
        return QRCodeRepository.findAll();
    }
}

package com.johnesleyer.QRApp3.Controllers;

import java.io.IOException;

import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.johnesleyer.QRApp3.Entities.Classroom;

import com.johnesleyer.QRApp3.Repositories.ClassroomRepository;

import com.google.zxing.client.j2se.MatrixToImageWriter;
@RestController
public class ClassroomController {
    private final ClassroomRepository classroomRepository;


    public ClassroomController(ClassroomRepository ClassroomRepository){
        this.classroomRepository = ClassroomRepository;
    }


    private String generateRandomValue(int length){
        // Generate random string 
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i=0;i<length;i++){
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }

    private void generateQRCodeImage(String text, String filePath) throws WriterException, IOException{
        // Generate QR code image and save it to the specified file path
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, 350, 350);
        Path path = FileSystems.getDefault().getPath(filePath);
        MatrixToImageWriter.writeToPath(bitMatrix, "PNG", path);
    }

    @PostMapping("/register-classroom")
    public Classroom registerClassroom(@RequestBody Classroom Classroom) throws WriterException, IOException{
    
        // Create QR code for this classroom
        String qrCodeValue = generateRandomValue(20);
        String qrCodeFileName = Classroom.getClassName() + "_" + generateRandomValue(7) + ".png";
        String qrCodeFilePath = "/media/john/632E12F06D7D80DE/ProjectDocuments/NDMU3/NDMU-Attendance-App/backend/images/" + qrCodeFileName;
        generateQRCodeImage(qrCodeValue, qrCodeFilePath);


        Classroom.setQrURL("https://nice-bullfrog-86.telebit.io/images/" + qrCodeFileName);
        Classroom.setQrValue(qrCodeValue);
        Classroom savedClassroom = classroomRepository.save(Classroom);
        return savedClassroom;
    }

    @GetMapping("/all-classrooms")
    public List<Classroom> getAllClassrooms(){
        return classroomRepository.findAll();
    }

    @PostMapping("/all-classrooms-by-teacher")
    public List<Classroom> getAllClassroomsByTeacher(@RequestBody Map<String, Map<String, Integer>> requestBody) {
        Integer teacherId = requestBody.get("teacher").get("id");
        // Teacher teacher = teacherRepository.findById(request).orElseThrow(() -> new RuntimeException("Teacher not found"));
        return classroomRepository.findAllByTeacherId(teacherId);
    }



}

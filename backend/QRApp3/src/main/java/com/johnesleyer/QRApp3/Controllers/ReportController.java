package com.johnesleyer.QRApp3.Controllers;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ReportController {

    @Value("${report.directory}")
    private String uploadFolderPath;

    @GetMapping("/pdf/{pdfName}")
    public ResponseEntity<Resource> getImage(@PathVariable String pdfName) {
        Path pdfPath = Paths.get(uploadFolderPath, pdfName);
        Resource resource = new FileSystemResource(pdfPath.toFile());

        if (resource.exists()) {
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(resource);
        } else {
            System.out.println("No pdf");
            return ResponseEntity.notFound().build();
        }
    }
}

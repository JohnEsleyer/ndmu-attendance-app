package com.johnesleyer.QRApp3.Controllers;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import org.xhtmlrenderer.pdf.ITextRenderer;

public class AttendanceReportGenerator {

    public static void convertHtmlToPdf(String htmlFilePath, String pdfFilePath) {
        try {
            String url = new File(htmlFilePath).toURI().toURL().toString();
            OutputStream outputStream = new FileOutputStream(pdfFilePath);
            ITextRenderer renderer = new ITextRenderer();
            renderer.setDocument(url);
            renderer.layout();
            renderer.createPDF(outputStream);
            outputStream.close();
            System.out.println("PDF generated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void generateHTMLFile(List<Map<String, Object>> attendanceData) {
        StringBuilder htmlBuilder = new StringBuilder();
        System.out.println("Report generated!");
        // Generate the HTML content
        htmlBuilder.append("<!DOCTYPE html>\n");
        htmlBuilder.append("<html>\n");
        htmlBuilder.append("<head>\n");
        htmlBuilder.append("<title>Attendance Report</title>\n");
        htmlBuilder.append("<style>\n");
        htmlBuilder.append("body {\n");
        htmlBuilder.append("    font-family: Arial, sans-serif;\n");
        htmlBuilder.append("    margin: 0;\n");
        htmlBuilder.append("    padding: 0;\n");
        htmlBuilder.append("    background-color: #ffffff;\n");
        htmlBuilder.append("}\n");
        htmlBuilder.append(".container {\n");
        htmlBuilder.append("    max-width: 800px;\n");
        htmlBuilder.append("    margin: 0 auto;\n");
        htmlBuilder.append("    padding: 20px;\n");
        htmlBuilder.append("    background-color: #ffffff;\n");
        htmlBuilder.append("    border-radius: 5px;\n");
        htmlBuilder.append("    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);\n");
        htmlBuilder.append("}\n");
        htmlBuilder.append("h1 {\n");
        htmlBuilder.append("    text-align: center;\n");
        htmlBuilder.append("    color: #235f37;\n");
        htmlBuilder.append("}\n");
        htmlBuilder.append("table {\n");
        htmlBuilder.append("    border-collapse: collapse;\n");
        htmlBuilder.append("    width: 100%;\n");
        htmlBuilder.append("}\n");
        htmlBuilder.append("th, td {\n");
        htmlBuilder.append("    border: 1px solid #000000;\n");
        htmlBuilder.append("    padding: 8px;\n");
        htmlBuilder.append("    text-align: left;\n");
        htmlBuilder.append("}\n");
        htmlBuilder.append("th {\n");
        htmlBuilder.append("    background-color: #235f37;\n");
        htmlBuilder.append("    color: #ffffff;\n");
        htmlBuilder.append("}\n");
        htmlBuilder.append("td {\n");
        htmlBuilder.append("    color: #000000;\n");
        htmlBuilder.append("}\n");
        htmlBuilder.append("</style>\n");
        htmlBuilder.append("</head>\n");
        htmlBuilder.append("<body>\n");
        htmlBuilder.append("<h1>Attendance Report</h1>\n");
        htmlBuilder.append("<table>\n");
        htmlBuilder.append("<tr>\n");
        htmlBuilder.append("<th>Student First Name</th>\n");
        htmlBuilder.append("<th>Student Last Name</th>\n");
        htmlBuilder.append("<th>Present</th>\n");
        htmlBuilder.append("<th>Absent</th>\n");
        htmlBuilder.append("<th>Late</th>\n");
        htmlBuilder.append("</tr>\n");

        // Add attendance data to the table
        for (Map<String, Object> studentStatus : attendanceData) {
            // Long studentId = ((Number) ((Map<String, Object>) studentStatus.get("student")).get("id")).longValue();
            int presentCount = (int) studentStatus.get("present");
            int absentCount = (int) studentStatus.get("absent");
            int lateCount = (int) studentStatus.get("late");
            String studentFirst = (String) studentStatus.get("studentFirstName");
            String studentLast = (String) studentStatus.get("studentLastName");

            htmlBuilder.append("<tr>\n");
            htmlBuilder.append("<td>").append(studentFirst).append("</td>\n");
            htmlBuilder.append("<td>").append(studentLast).append("</td>\n");
            htmlBuilder.append("<td>").append(presentCount).append("</td>\n");
            htmlBuilder.append("<td>").append(absentCount).append("</td>\n");
            htmlBuilder.append("<td>").append(lateCount).append("</td>\n");
            htmlBuilder.append("</tr>\n");
        }

        htmlBuilder.append("</table>\n");
        htmlBuilder.append("</body>\n");
        htmlBuilder.append("</html>\n");
        // Write the HTML content to a file
        String filePath = "reports/attendace_report.html"; // Update with your desired absolute path
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            writer.write(htmlBuilder.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }

        convertHtmlToPdf(filePath, "reports/attendance_report.pdf");
    }
}

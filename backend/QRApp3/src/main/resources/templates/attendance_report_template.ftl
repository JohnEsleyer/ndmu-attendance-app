<!DOCTYPE html>
<html>
  <head>
    <title>Classroom Attendance Report</title>
    <style>
      <!-- CSS styles -->
     
    </style>
  </head>
  <body>
    <h1>Classroom Attendance Report</h1>
    <table>
      <thead>
        <tr>
          <th>Student Name</th>
          <th>Attendance Status</th>
        </tr>
      </thead>
      <tbody>
        <#list response as studentStatus>
          <tr>
            <td>${studentStatus.student.id}</td>
            <td class="${getStatusClass(studentStatus)}">${getStatusText(studentStatus)}</td>
          </tr>
        </#list>
      </tbody>
    </table>
    <p>Total Students: ${response?size}</p>
    <p>Present: ${getAttendanceCount(response, 'present')}</p>
    <p>Absent: ${getAttendanceCount(response, 'absent')}</p>
    <p>Late: ${getAttendanceCount(response, 'late')}</p>
  </body>
</html>

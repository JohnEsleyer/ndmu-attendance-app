import 'package:flutter/material.dart';
import 'package:final_qr/widgets/teacher_greenwhite_container.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:final_qr/models/user_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';
import 'package:final_qr/models/teacher_data_model.dart';

class AttendanceReportScreen extends StatefulWidget {
  @override
  _AttendanceReportScreenState createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  late String _dropdownValue;
  @override
  Widget build(BuildContext context) {
    return GreenWhiteContainer(
      fontSize: 40,
      title: 'Attendance Report',
      child: Container(
        child: Consumer<TeacherData>(
          builder: (context, teacherData, child) {
            try {
              _dropdownValue =
                  Provider.of<TeacherData>(context).getClassrooms[0];
              return Column(
                children: [
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: _dropdownValue,
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _dropdownValue = value!;
                          });
                        },
                        items: teacherData.getClassrooms
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              );
            } catch (e) {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                  width: 30,
                  height: 30,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

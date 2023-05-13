import 'package:final_qr/widgets/DelayedWidget.dart';
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
  int _indexValue = 0;
  Future<List<dynamic>> fetchStudentsByClass(int classId) async {
    final response = await http.post(
      Uri.parse('$server/all-students-by-classroom'),
      body: jsonEncode({
        "classroom": {
          "id": classId,
        },
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return json.decode(response.body);
    } else {
      print("Error studentsByClass fetch");
      // If that call was not successful, throw an error.
      throw Exception('Failed to load students by class');
    }
  }

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
                            _indexValue = teacherData.getClassrooms
                                .indexWhere((element) => element == value);
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
                  SizedBox(height: 5),
                  FutureBuilder<List<dynamic>>(
                      future: fetchStudentsByClass(
                          teacherData.getClassroomID[_indexValue]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 30,
                            width: 30,
                            child: const CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          );
                        } else {
                          return Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                // var className =
                                //     snapshot.data[index]['className'];
                                // var qrURL = snapshot.data[index]['qrURL'];
                                // var classId = snapshot.data[index]["id"];
                                // var schedule = snapshot.data[index]['schedule'];
                                // var defaultTime = snapshot.data[index]['defaultTime'];
                                String firstName = snapshot.data[index]
                                    ['student']["firstName"];
                                String lastName =
                                    snapshot.data[index]['student']["lastName"];
                                return Column(
                                  children: [
                                    DelayedWidget(
                                      child: Container(
                                          height: 0.10 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          width: 0.90 *
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "$lastName, $firstName",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }),
                ],
              );
            } catch (e) {
              print(e.toString());
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

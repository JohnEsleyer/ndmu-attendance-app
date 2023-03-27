import 'dart:convert';

import 'package:final_qr/models/viewClassroomModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_qr/constants_and_functions.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ViewClassroomTeacher extends StatefulWidget {
  String className;
  int classId;
  ViewClassroomTeacher({required this.className, required this.classId});
  @override
  _ViewClassroomTeacherState createState() => _ViewClassroomTeacherState();
}

class _ViewClassroomTeacherState extends State<ViewClassroomTeacher> {
  bool isPressed = false;
  DateTime selected = DateTime.now();

  Future<List<dynamic>> fetchClassAttendance() async {
    final response = await http.post(
      Uri.parse('$server/attendance-by-dateclass'),
      body: jsonEncode({
        "date": DateFormat("MM/dd/yyyy").format(selected),
        "classroom": {
          "id": widget.classId,
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
      print("Error teacherClassroom fetch");
      // If that call was not successful, throw an error.
      throw Exception('Failed to load classes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            children: [
              SizedBox(width: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 20),
              Text(
                widget.className,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Consumer<ViewClassroomProvider>(
              builder: (context, myChangeNotifier, child) {
            return GestureDetector(
              onDoubleTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: myChangeNotifier.getSelectedDate,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                pickedDate?.subtract(Duration(days: 1));
                if (pickedDate != null &&
                    pickedDate != myChangeNotifier.getSelectedDate) {
                  myChangeNotifier.setSelectedDate(pickedDate);
                  myChangeNotifier
                      .setDates(getDateList(myChangeNotifier.getSelectedDate));
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx > 0) {
                  // Swiped to the right
                  myChangeNotifier.setCurrentIndex(
                      (myChangeNotifier.getCurrentIndex -
                              1 +
                              myChangeNotifier.getDates.length) %
                          myChangeNotifier.getDates.length);
                  setState(() {
                    selected = myChangeNotifier
                        .getDates[myChangeNotifier.getCurrentIndex];
                  });
                } else {
                  // Swiped to the left
                  if (myChangeNotifier.getCurrentIndex < 30) {
                    myChangeNotifier.setCurrentIndex(
                        (myChangeNotifier.getCurrentIndex + 1) %
                            myChangeNotifier.getDates.length);
                    setState(() {
                      selected = myChangeNotifier
                          .getDates[myChangeNotifier.getCurrentIndex];
                    });
                  }
                }
              },
              child: Center(
                child: Hero(
                  tag: DateFormat("MM/dd/yyyy").format(myChangeNotifier
                      .getDates[myChangeNotifier.getCurrentIndex]),
                  child: Text(
                    DateFormat("MM/dd/yyyy").format(myChangeNotifier
                        .getDates[myChangeNotifier.getCurrentIndex]),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.16,
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          isPressed
              ? Expanded(
                  child: FutureBuilder<List<dynamic>>(
                      future: fetchClassAttendance(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: const CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              var lastName =
                                  snapshot.data[index]['student']["lastName"];
                              var firstName =
                                  snapshot.data[index]['student']["firstName"];
                              var status = snapshot.data[index]['status'];
                              var attendanceId = snapshot.data[index]["id"];
                              // var schedule = snapshot.data[index]['schedule'];
                              // var defaultTime = snapshot.data[index]['defaultTime'];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: Container(
                                  height:
                                      0.10 * MediaQuery.of(context).size.height,
                                  width:
                                      0.90 * MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "$lastName, $firstName",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                )
              : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // OutlinedButton(
                      //   onPressed: () {},
                      //   style: ButtonStyle(
                      //     backgroundColor:
                      //         MaterialStatePropertyAll<Color>(Colors.yellow),
                      //   ),
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height * 0.08,
                      //     width: MediaQuery.of(context).size.width * 0.7,
                      //     child: Center(
                      //       child: Text(
                      //         "Set Attendance Time",
                      //         style: TextStyle(
                      //           fontSize: MediaQuery.of(context).size.height * 0.03,
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isPressed = true;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.green),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Center(
                            child: Text(
                              "Start Attendance Now",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isPressed = true;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.yellow),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Center(
                            child: Text(
                              "Start Later",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

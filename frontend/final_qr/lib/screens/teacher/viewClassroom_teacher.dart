import 'dart:async';
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
  DateTime selected = DateTime.now();
  bool isChanged = false;

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

  late Stream<List<dynamic>> _attendanceStream;
  int _refreshInterval = 3;

  @override
  void initState() {
    super.initState();
    // Create a stream that emits new data every 3 seconds
    _attendanceStream =
        Stream.periodic(Duration(seconds: _refreshInterval), (_) {
      return fetchClassAttendance();
    }).asyncMap((future) => future);
  }

  Map<String, Color> statusColors = {
    "absent": Colors.red,
    "present": Colors.green,
    "late": Colors.orange,
  };

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

                  print(DateFormat("MM/dd/yyy").format(pickedDate));
                  setState(() {
                    selected = pickedDate;
                  });
                  isChanged = true;
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

                    isChanged = true;
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
                      isChanged = true;
                    });
                  }
                }
              },
              child: Center(
                child: Hero(
                  tag: DateFormat("MM/dd/yyyy").format(selected),
                  child: Text(
                    DateFormat("MM/dd/yyyy").format(selected),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.16,
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    color: Colors.red,
                  ),
                  Text("Absent"),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    color: Colors.green,
                  ),
                  Text("Present"),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    color: Colors.orange,
                  ),
                  Text("Late"),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Expanded(
            child: StreamBuilder<List<dynamic>>(
                stream: _attendanceStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (isChanged) {
                    snapshot = AsyncSnapshot<List<String>>.nothing();

                    isChanged = false;
                    print(snapshot.data);
                  }

                  if (!snapshot.hasData) {
                    return Container(
                      height: 30,
                      width: 40,
                      child: Center(
                        child: const CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("An error has occured!"));
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
                        var time = snapshot.data[index]["time"];
                        // var schedule = snapshot.data[index]['schedule'];
                        // var defaultTime = snapshot.data[index]['defaultTime'];
                        if (snapshot.data.length == 0) {
                          return Center(
                            child: Text("No attendance found"),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            children: [
                              Container(
                                height:
                                    0.10 * MediaQuery.of(context).size.height,
                                width: 0.90 * MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: statusColors[status],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "$lastName, $firstName",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "$time",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

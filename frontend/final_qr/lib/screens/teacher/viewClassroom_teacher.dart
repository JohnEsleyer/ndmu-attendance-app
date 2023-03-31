import 'dart:async';
import 'dart:convert';

import 'package:final_qr/models/viewClassroomModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_qr/constants_and_functions.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:final_qr/widgets/DelayedWidget.dart';

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
  int _refreshInterval = 1;

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
      body: Container(
        color: Colors.green[900],
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              children: [
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  widget.className,
                  style: TextStyle(
                    color: Colors.white,
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
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.16,
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              "You can swipe the date left or right",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Double tap to open Date Picker",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.628,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Expanded(
                child: StreamBuilder<List<dynamic>>(
                    stream: _attendanceStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (isChanged) {
                        snapshot = AsyncSnapshot<List<String>>.nothing();

                        isChanged = false;
                        print(snapshot.data);
                      }
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
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
                        print("has data");
                        if (snapshot.data.length == 0) {
                          return Center(
                            child: DelayedWidget(
                              delay: Duration(seconds: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No attendance found",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "If you believe there is an attendance for this date,\n please wait for few seconds as there might be \n a delay in the connection.",
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          );
                        }

                        var dateString = snapshot.data[0]['date'];
                        DateFormat format = DateFormat("MM/dd/yyyy");
                        DateTime date = format.parse(dateString);
                        date = date.add(Duration(days: 1));

                        //Recreate DateTime to remove hours, minutes, and seconds.
                        selected = DateTime(
                            selected.year, selected.month, selected.day);
                        print(date.toString());
                        print(selected.toString());
                        if (date == selected) {
                          print("true");
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
                              // print("ListView building.");
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: Column(
                                  children: [
                                    DelayedWidget(
                                      child: Container(
                                        height: 0.10 *
                                            MediaQuery.of(context).size.height,
                                        width: 0.90 *
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Name: $lastName, $firstName",
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Time entered: $time",
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    status,
                                                    style: TextStyle(
                                                      color:
                                                          statusColors[status],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Container(
                            height: 30,
                            width: 40,
                            child: Center(
                              child: const CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            ),
                          );
                        }
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:final_qr/models/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'student_scanqr.dart';

class TodaysAttendance extends StatefulWidget {
  late int userId;
  TodaysAttendance({required this.userId});
  _TodaysAttendanceState createState() => _TodaysAttendanceState();
}

Future<List<dynamic>> _loadClassDates(context) async {
  final response = await http.post(
    Uri.parse(
      '$server/classdates-by-studentdate',
    ),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      {
        "student": {
          "id": Provider.of<UserDataProvider>(context, listen: false)
              .getUserData
              .userId,
        },
        "date": DateFormat('MM/dd/yyyy').format(DateTime.now()),
      },
    ),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    print("200 Success");
    print(response.body);
    return json.decode(response.body);
  } else {
    print("error");
    throw Exception('Failed to load data');
  }
}

class _TodaysAttendanceState extends State<TodaysAttendance> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  DateTime _now = DateTime.now();
  List<String> items = [];

  late Future<List<dynamic>> _classDate;
  bool _isLoading = true;
  int _lates = 0;
  int _absent = 0;
  int _present = 0;

  String convertTo12HourFormat(String timeString) {
    // Parse the input time string into a DateTime object
    DateTime time = DateFormat('HH:mm').parse(timeString);

    // Format the DateTime object as a 12-hour time string
    String formattedTime = DateFormat('h:mm a').format(time);

    // Return the formatted time string
    return formattedTime;
  }

  String addHoursToTime(String timeString, int n) {
    // Parse the input time string into a DateTime object
    DateTime time = DateFormat('HH:mm').parse(timeString);

    // Add n hours to the DateTime object
    time = time.add(Duration(hours: n));

    // Format the DateTime object as a time string
    String formattedTime = DateFormat('HH:mm').format(time);

    // Return the formatted time string
    return formattedTime;
  }

  Future<void> fetchCountStatus() async {
    final url = Uri.parse('$server/count-status-student');
    final requestBody = jsonEncode({
      "student": {"id": widget.userId}
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _lates = data['late'];
          _absent = data['absent'];
          _present = data['present'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load count status');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCountStatus();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _classDate = _loadClassDates(context);
    });
    return Container(
      color: Colors.green[900],
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(height: 35),
          _isLoading
              ? Container(
                  height: 86,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.green[900],
                    ),
                  ),
                )
              : Container(
                  height: 86,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Overall Attendance",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$_present",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "$_lates",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "$_absent",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Days present",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        "Days late",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        "Days absent",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Container(
            height: MediaQuery.of(context).size.height * 0.820,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: FutureBuilder<List<dynamic>>(
                future: _classDate,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            "Today's Attendance",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          child: RefreshIndicator(
                            key: _refreshKey,
                            color: Colors.white,
                            backgroundColor: Colors.green,
                            strokeWidth: 4.0,
                            onRefresh: () async {
                              setState(() {
                                _classDate = _loadClassDates(context);
                              });
                              return Future<void>.delayed(
                                  const Duration(seconds: 3));
                            },
                            child: RefreshIndicator(
                              color: Colors.white,
                              backgroundColor: Colors.green,
                              strokeWidth: 4.0,
                              onRefresh: () {
                                return Future<void>.delayed(
                                    const Duration(seconds: 3));
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.600,
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String attendanceTimeString =
                                        snapshot.data![index]["time"];
                                    TimeOfDay attendanceTime =
                                        TimeOfDay.fromDateTime(
                                      DateTime.parse(
                                          "1970-01-01 $attendanceTimeString:00"),
                                    );

                                    double timeNowDouble =
                                        toDouble(TimeOfDay.now());
                                    double timeAttendance =
                                        toDouble(attendanceTime);

                                    print(timeNowDouble);
                                    print(timeAttendance);
                                    if (timeNowDouble > timeAttendance &&
                                        timeNowDouble < timeAttendance + 1) {
                                      print("Attendance Now");
                                      List<int> classAttended =
                                          Provider.of<UserDataProvider>(context)
                                              .classroomAttended;

                                      if (!classAttended.contains(
                                          snapshot.data![index]['id'])) {
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print("Pressed");
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) => ScanQR(
                                                      snapshot.data![index]
                                                          ["time"],
                                                      snapshot.data![index]
                                                          ['id']),
                                                ));
                                              },
                                              child: Container(
                                                height: 120,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
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
                                                  color: Color.fromARGB(
                                                      255, 32, 182, 2),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              snapshot.data![
                                                                          index]
                                                                      [
                                                                      "classroom"]
                                                                  ["className"],
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              'Attendance has started and will end at \n ${convertTo12HourFormat(addHoursToTime(attendanceTimeString, 1))}',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ShakeWidget(
                                                          autoPlay: true,
                                                          shakeConstant:
                                                              ShakeRotateConstant1(),
                                                          child: Icon(
                                                            Icons
                                                                .notification_important,
                                                            color: Colors.amber,
                                                            size: 40,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print("Pressed");
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) => ScanQR(
                                                      snapshot.data![index]
                                                          ["time"],
                                                      snapshot.data![index]
                                                          ['id']),
                                                ));
                                              },
                                              child: Container(
                                                height: 120,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
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
                                                  color: Colors.amber,
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              snapshot.data![
                                                                          index]
                                                                      [
                                                                      "classroom"]
                                                                  ["className"],
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              'Your attendance have been recorded',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                          size: 40,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        );
                                      }
                                    } else {
                                      print("Attendance Later!");
                                      return Column(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      snapshot.data![index]
                                                              ["classroom"]
                                                          ["className"],
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Attendance is scheduled at ${convertTo12HourFormat(attendanceTimeString)}',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.820,
                      width: double.infinity,
                      child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.green)),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

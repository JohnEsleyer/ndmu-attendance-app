import 'dart:async';
import 'dart:convert';

import 'package:final_qr/models/view_classroom_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_qr/constants_and_functions.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:final_qr/widgets/DelayedWidget.dart';

import 'classroom_settings.dart';

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
  final GlobalKey<State> _key = GlobalKey();

  TimeOfDay selectedTime = TimeOfDay.now();

  int getMinutesDiff(TimeOfDay tod1, TimeOfDay tod2) {
    return (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);
  }

  Future<Map<String, dynamic>> _registerClassDate(TimeOfDay? picked) async {
    if (picked != null) {
      String formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      print("sent");
      final response = await http.post(
        Uri.parse(
          "$server/register-classDate",
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'date': DateFormat('MM/dd/yyyy').format(selected),
          "time": formattedTime,
          'classroom': {
            "id": widget.classId,
          },
        }),
      );
      print(response.statusCode);
      print("request: ${jsonEncode({
            'date': DateFormat('MM/dd/yyyy').format(selected),
            "time": formattedTime,
            'classroom': {
              "id": widget.classId,
            },
          })}");
      print("response: ${response.body}");
      setState(() {
        _key.currentState?.reassemble(); // Trigger a rebuild of the widget
      });
    }
    return {"status": "error"};
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context),
          child: child!,
        );
      },
    );

    _registerClassDate(picked);

    if (picked != null && picked != selectedTime) {
      setState(() async {
        selectedTime = picked;
      });
    }
  }

  Future<Map<String, dynamic>> _getData() async {
    final response = await http.post(
      Uri.parse(
        '$server/classdate-by-dateclass',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'date': DateFormat('MM/dd/yyyy').format(selected),
        'classroom': {
          "id": widget.classId,
        },
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("200 Success");
      return json.decode(response.body);
    } else {
      print("error");
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> _createClassDate(DateTime time) async {
    final response = await http.post(
      Uri.parse(
        '$server/register-classDate',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'date': DateFormat('MM/dd/yyyy').format(selected),
        "time": DateFormat('HH:mm').format(time),
        'classroom': {
          "id": widget.classId,
        },
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("_createClassDate: 200 Success");
      return json.decode(response.body);
    } else {
      print("error");
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green[900],
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Hero(
              tag: "arrow back",
              child: Material(
                color: Colors.green[900],
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
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
                    child: Material(
                      color: Colors.green[900],
                      child: Text(
                        DateFormat("MM/dd/yyyy").format(selected),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.16,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            DelayedWidget(
              delay: Duration(seconds: 2),
              child: Column(
                children: [
                  Text(
                    "You can swipe the date left or right",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Double tap to open Date Picker",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            FutureBuilder<Map<String, dynamic>>(
              future: _getData(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 30,
                    width: 40,
                    child: Center(
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final data = snapshot.data!;
                  if (data["response"] == "present") {
                    if (data["status"] == "not set") {
                      return Container(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                _createClassDate(DateTime.now());
                                var res = await Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secodaryAnimation) =>
                                        ChangeNotifierProvider(
                                      create: (context) =>
                                          ViewClassroomProvider(),
                                      builder: (context, child) {
                                        return ViewClassroomTeacher2(
                                            className: widget.className,
                                            classId: widget.classId,
                                            initialDate: selected);
                                      },
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(0, 1),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                                setState(() {
                                  _key.currentState
                                      ?.reassemble(); // Trigger a rebuild of the widget
                                  print("setState executed");
                                });
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width * 0.90,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 124, 207, 91),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Start Attendance Now",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),
                            GestureDetector(
                              onTap: () {
                                _selectTime(context);
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width * 0.90,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 243, 183, 71),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Set Attendace for Later",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      String timeString = data["classDates"][0]["time"];
                      TimeOfDay timeSched = TimeOfDay.fromDateTime(
                          DateTime.parse("1970-01-01 $timeString:00"));

                      print(timeString);

                      var timeNow = TimeOfDay.now();
                      // Convert timeNow to 24-hour format
                      int hour24 = timeNow.hour;
                      if (timeNow.period == DayPeriod.pm && hour24 < 12) {
                        hour24 += 12;
                      }
                      TimeOfDay timeNowto24 =
                          TimeOfDay(hour: hour24, minute: timeNow.minute);

                      int result = getMinutesDiff(timeSched, timeNowto24);
                      print(result);
                      if (result > 0) {
                        return Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.alarm,
                                color: Colors.white,
                                size: 50,
                              ),
                              Text(
                                "Attendance scheduled at ${timeSched.format(context)}",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 221, 216, 216),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secodaryAnimation) =>
                                        ChangeNotifierProvider(
                                  create: (context) => ViewClassroomProvider(),
                                  builder: (context, child) {
                                    return ViewClassroomTeacher2(
                                        className: widget.className,
                                        classId: widget.classId,
                                        initialDate: selected);
                                  },
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(0, 1),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            width: MediaQuery.of(context).size.width * 0.90,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 243, 183, 71),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "View Attendance",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    if (data["status"] == "set") {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secodaryAnimation) =>
                                      ChangeNotifierProvider(
                                create: (context) => ViewClassroomProvider(),
                                builder: (context, child) {
                                  return ViewClassroomTeacher2(
                                      className: widget.className,
                                      classId: widget.classId,
                                      initialDate: selected);
                                },
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                          width: MediaQuery.of(context).size.width * 0.90,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 243, 183, 71),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "View Attendance",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: Icon(
                              size: 50,
                              color: Colors.white,
                              Icons.toggle_off,
                            ),
                          ),
                          Text(
                            "You have not set an attendance in this date",
                            style: TextStyle(
                              color: Color.fromARGB(255, 207, 238, 218),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ViewClassroomTeacher2 extends StatefulWidget {
  String className;
  int classId;
  DateTime initialDate;

  ViewClassroomTeacher2(
      {Key? key,
      required this.className,
      required this.classId,
      required this.initialDate})
      : super(key: key);
  @override
  _ViewClassroomTeacher2State createState() => _ViewClassroomTeacher2State();
}

class _ViewClassroomTeacher2State extends State<ViewClassroomTeacher2> {
  late DateTime selected = widget.initialDate;
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
            Hero(
              tag: "arrow back",
              child: Material(
                color: Colors.green[900],
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.001),
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
                    child: Material(
                      color: Colors.green[900],
                      child: Text(
                        DateFormat("MM/dd/yyyy").format(selected),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.16,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            DelayedWidget(
              delay: Duration(seconds: 2),
              child: Column(
                children: [
                  Text(
                    "You can swipe the date left or right",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Double tap to open Date Picker",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
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
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                var lastName =
                                    snapshot.data[index]['student']["lastName"];
                                var firstName = snapshot.data[index]['student']
                                    ["firstName"];
                                var status = snapshot.data[index]['status'];
                                var attendanceId = snapshot.data[index]["id"];
                                var time = snapshot.data[index]["time"];
                                // var schedule = snapshot.data[index]['schedule'];
                                // var defaultTime = snapshot.data[index]['defaultTime'];
                                // print("ListView building.");
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25),
                                  child: Column(
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Name: $lastName, $firstName",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                      "Time entered: $time",
                                                      style: TextStyle(
                                                        fontSize: 14,
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
                                                        color: statusColors[
                                                            status],
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
            ),
          ],
        ),
      ),
    );
  }
}

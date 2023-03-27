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
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          DateSwiper(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.yellow),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Center(
                      child: Text(
                        "Set Attendance Time",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                OutlinedButton(
                  onPressed: () {},
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
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.white,
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

class DateSwiper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ViewClassroomProvider>(
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
            myChangeNotifier.setCurrentIndex((myChangeNotifier.getCurrentIndex -
                    1 +
                    myChangeNotifier.getDates.length) %
                myChangeNotifier.getDates.length);
          } else {
            // Swiped to the left
            myChangeNotifier.setCurrentIndex(
                (myChangeNotifier.getCurrentIndex + 1) %
                    myChangeNotifier.getDates.length);
          }
        },
        child: Center(
          child: Text(
            DateFormat("MM/dd/yyyy").format(
                myChangeNotifier.getDates[myChangeNotifier.getCurrentIndex]),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.16,
            ),
          ),
        ),
      );
    });
  }
}

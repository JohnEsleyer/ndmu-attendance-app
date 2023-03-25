import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewClassroomTeacher extends StatefulWidget {
  String className;
  int classId;
  ViewClassroomTeacher({required this.className, required this.classId});
  @override
  _ViewClassroomTeacherState createState() => _ViewClassroomTeacherState();
}

class _ViewClassroomTeacherState extends State<ViewClassroomTeacher> {
  DateTime today = DateTime.now();
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
          Text(
            DateFormat("MM/dd/yyyy").format(today),
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.10),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Container()
        ],
      ),
    );
  }
}

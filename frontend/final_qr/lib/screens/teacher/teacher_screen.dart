import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'teacher_classrooms.dart';
import 'teacher_attendance_report_screen.dart';
import 'package:final_qr/models/teacher_data_model.dart';

class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    List<Widget> _screenOptions = <Widget>[
      AttendanceReportScreen(),
      TeacherClassrooms(),
      Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              const Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        print(_selectedIndex);
      });
    }

    return ChangeNotifierProvider(
      create: (_) => TeacherData(),
      child: Scaffold(
        body: _screenOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Attendance Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.meeting_room),
              label: 'My Classrooms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../student/student_todays_attendance.dart';
import 'admin_classroom_screen.dart';
import 'admin_student_screen.dart';
import 'admin_teacher_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _screenOptions = <Widget>[
      AdminStudentScreen(),
      AdminTeacherScreen(),
      AdminClassroomScreen(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        print(_selectedIndex);
      });
    }

    return Scaffold(
      body: _screenOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Teachers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: 'Classrooms',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:final_qr/screens/student/student_attendance_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_data_model.dart';
import 'student_todays_attendance.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<UserDataProvider>(context).getUserData.userId;
    List<Widget> _screenOptions = <Widget>[
      TodaysAttendance(userId: userId),
      ProfileAttendance(userId: userId),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        print(_selectedIndex);
      });
    }

    return Scaffold(
      // body: _screenOptions.elementAt(_selectedIndex),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Personal Info',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.green[800],
      //   onTap: _onItemTapped,
      // ),
      body: TodaysAttendance(userId: userId),
    );
  }
}

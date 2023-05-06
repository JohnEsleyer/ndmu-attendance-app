import 'package:flutter/material.dart';
import 'student_todays_attendance.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _screenOptions = <Widget>[
      TodaysAttendance(),
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

    return Scaffold(
      body: _screenOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Personal Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';

class AdminTeacherScreen extends StatefulWidget {
  @override
  _AdminTeacherScreenState createState() => _AdminTeacherScreenState();
}

class _AdminTeacherScreenState extends State<AdminTeacherScreen> {
  bool _isLoading = true;
  List<String> _teachers = [];

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  Future<void> _fetchTeachers() async {
    final response = await http.get(Uri.parse('$server/all-teachers'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final teachers =
          data.map((teacher) => teacher['name'] as String).toList();
      setState(() {
        _teachers = teachers;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  Widget _buildAdminTeacherScreen() {
    return ListView.builder(
      itemCount: _teachers.length,
      itemBuilder: (BuildContext context, int index) {
        final teacherName = _teachers[index];
        return ListTile(
          title: Text(teacherName),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromARGB(255, 30, 136, 33),
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 109, 42),
        title: Text('Teacher List'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
          : _buildAdminTeacherScreen(),
    );
  }
}

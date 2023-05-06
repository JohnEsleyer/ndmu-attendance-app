import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';

class AdminStudentScreen extends StatefulWidget {
  @override
  _AdminStudentScreenState createState() => _AdminStudentScreenState();
}

class _AdminStudentScreenState extends State<AdminStudentScreen> {
  bool _isLoading = true;
  List<String> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final response = await http.get(Uri.parse('$server/all-students'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final students =
          data.map((student) => student['name'] as String).toList();
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load students');
    }
  }

  Widget _buildAdminStudentScreen() {
    return ListView.builder(
      itemCount: _students.length,
      itemBuilder: (BuildContext context, int index) {
        final studentName = _students[index];
        return ListTile(
          title: Text(studentName),
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
        title: Text('Student List'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
          : _buildAdminStudentScreen(),
    );
  }
}

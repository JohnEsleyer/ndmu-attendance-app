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
  List<dynamic> _teachers = [];

  @override
  void initState() {
    super.initState();
    _fetchteachers();
  }

  Future<void> _fetchteachers() async {
    final response = await http.get(Uri.parse('$server/all-teachers'));

    if (response.statusCode == 200) {
      print("Success");
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        _teachers = data;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  Widget _buildTeacherList() {
    return ListView.builder(
      itemCount: _teachers.length,
      itemBuilder: (BuildContext context, int index) {
        final teacher = _teachers[index];
        return Card(
          elevation: 3,
          child: ListTile(
            title: Text('${teacher['lastName']}, ${teacher['firstName']}'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTeacher(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('Teacher List'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : _buildTeacherList(),
    );
  }
}

class CreateTeacher extends StatefulWidget {
  @override
  _CreateTeacherState createState() => _CreateTeacherState();
}

class _CreateTeacherState extends State<CreateTeacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

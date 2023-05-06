import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';

class AdminClassroomScreen extends StatefulWidget {
  @override
  _AdminClassroomScreenState createState() => _AdminClassroomScreenState();
}

class _AdminClassroomScreenState extends State<AdminClassroomScreen> {
  bool _isLoading = true;
  List<String> _classrooms = [];

  @override
  void initState() {
    super.initState();
    _fetchClassrooms();
  }

  Future<void> _fetchClassrooms() async {
    final response = await http.get(Uri.parse('$server/all-classrooms'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final classrooms =
          data.map((classroom) => classroom['name'] as String).toList();
      setState(() {
        _classrooms = classrooms;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load classrooms');
    }
  }

  Widget _buildAdminClassroomScreen() {
    return ListView.builder(
      itemCount: _classrooms.length,
      itemBuilder: (BuildContext context, int index) {
        final classroomName = _classrooms[index];
        return ListTile(
          title: Text(classroomName),
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
        title: Text('Classroom List'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
          : _buildAdminClassroomScreen(),
    );
  }
}

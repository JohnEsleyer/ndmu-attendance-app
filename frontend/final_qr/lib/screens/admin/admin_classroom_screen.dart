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
  List<dynamic> _classrooms = [];

  @override
  void initState() {
    super.initState();
    _fetchclassrooms();
  }

  Future<void> _fetchclassrooms() async {
    final response = await http.get(Uri.parse('$server/all-classrooms'));

    if (response.statusCode == 200) {
      print("Success");
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        _classrooms = data;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load classrooms');
    }
  }

  Widget _buildClassroomList() {
    return ListView.builder(
      itemCount: _classrooms.length,
      itemBuilder: (BuildContext context, int index) {
        final classroom = _classrooms[index];
        return Card(
          elevation: 3,
          child: ListTile(
            title: Text('${classroom['className']}'),
            subtitle: Text(
                "Teacher: ${classroom['teacher']['lastName']}, ${classroom['teacher']['firstName']}"),
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
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('Classroom List'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : _buildClassroomList(),
    );
  }
}

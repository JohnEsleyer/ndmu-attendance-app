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
            trailing: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure you want to delete this user?'),
                      content: Text('This action is irreversible.'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final classroomId = classroom['id'];
                            final data = {'id': classroomId};
                            final response = await http.delete(
                              Uri.parse('$server/delete-classroom'),
                              body: jsonEncode(data),
                              headers: {'Content-Type': 'application/json'},
                            );

                            if (response.statusCode == 200) {
                              print("delete Success");
                              // Success
                            } else {
                              // Error
                              print("Error ${response.body}");
                            }
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.delete),
            ),
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
              builder: (context) => CreateClassroom(),
            ),
          );
        },
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

class CreateClassroom extends StatefulWidget {
  @override
  _CreateClassroomState createState() => _CreateClassroomState();
}

class _CreateClassroomState extends State<CreateClassroom> {
  final _formKey = GlobalKey<FormState>();
  final _className = TextEditingController();
  final _teacherId = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _className.dispose();
    _teacherId.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final className = _className.text;
    final teacherId = _teacherId.text;

    final data = {
      'className': className,
      'teacher': {'id': teacherId},
    };

    final response = await http.post(
      Uri.parse('$server/register-classroom'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Successful registration
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text('Your account has been registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Failed registration
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text('Failed to register your account.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _className,
                          decoration: InputDecoration(
                            labelText: 'Classroom Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter classroom name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _teacherId,
                          decoration: InputDecoration(
                            labelText: 'ID of the teacher',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the ID of the teacher';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Create Classroom'),
                        ),
                      ],
                    )),
              ),
            ),
    );
  }
}

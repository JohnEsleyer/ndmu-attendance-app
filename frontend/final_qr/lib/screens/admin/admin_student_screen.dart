import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';
import 'package:http/http.dart' as http;

class AdminStudentScreen extends StatefulWidget {
  @override
  _AdminStudentScreenState createState() => _AdminStudentScreenState();
}

class _AdminStudentScreenState extends State<AdminStudentScreen> {
  bool _isLoading = true;
  List<dynamic> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final response = await http.get(Uri.parse('$server/all-students'));

    if (response.statusCode == 200) {
      print("Success");
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        _students = data;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load students');
    }
  }

  Widget _buildStudentList() {
    return RefreshIndicator(
      onRefresh: _fetchStudents,
      color: Colors.white,
      backgroundColor: Colors.green,
      child: _students.length == 0
          ? Center(
              child: Text('No students found!'),
            )
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (BuildContext context, int index) {
                final student = _students[index];
                return Card(
                  elevation: 3,
                  child: ListTile(
                    title:
                        Text('${student['lastName']}, ${student['firstName']}'),
                    subtitle: Text('School Year: ${student['schoolYear']}'),
                    trailing: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to delete this user?'),
                              content: Text('This action is irreversible.'),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    final studentId = student['id'];
                                    final data = {'id': studentId};
                                    final response = await http.delete(
                                      Uri.parse('$server/delete-student'),
                                      body: jsonEncode(data),
                                      headers: {
                                        'Content-Type': 'application/json'
                                      },
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
            ),
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
              builder: (context) => CreateStudent(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('Student List'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : _buildStudentList(),
    );
  }
}

/**
 * {
    "id": 1,
    "username": "teacher1",
    "password": "pass1",
    "firstName": "John",
    "lastName": "Doe"
}
 */

class CreateStudent extends StatefulWidget {
  @override
  _CreateStudentState createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _yearController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.green,
    content: Text(
      'Student Sucessfuly Created!: Please refresh to see the newly added student',
      style: TextStyle(
        fontSize: 13,
        color: Colors.white,
      ),
    ),
  );
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final year = _yearController.text;

    final data = {
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'schoolYear': year,
    };

    final response = await http.post(
      Uri.parse('$server/register-student'),
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
            content: Text('Student has been registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        title: Text('Register Student'),
        backgroundColor: Colors.green[900],
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
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _yearController,
                          decoration: InputDecoration(
                            labelText: 'School Year',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your school year';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Register'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[900],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
    );
  }
}

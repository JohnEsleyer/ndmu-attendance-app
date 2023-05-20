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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Classroom'),
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
                        SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SelectTeacher(className: _className.text)));
                          },
                          child: Text('Next'),
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

class SelectTeacher extends StatefulWidget {
  String className;
  SelectTeacher({required this.className});
  @override
  _SelectTeacherState createState() => _SelectTeacherState();
}

class _SelectTeacherState extends State<SelectTeacher> {
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
        return GestureDetector(
          onTap: () async {
            final url = Uri.parse('$server/register-classroom');
            final payload = json.encode({
              'className': widget.className,
              'teacher': {'id': teacher['id']},
            });

            final response = await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: payload,
            );

            if (response.statusCode == 200) {
              // Request was successful
              print('Classroom registered successfully!');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Classroom created successfully!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
              // Something went wrong
              print('Error registering classroom: ${response.reasonPhrase}');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Classroom creation failed!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Card(
            elevation: 3,
            child: ListTile(
              title: Text('${teacher['lastName']}, ${teacher['firstName']}'),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('Select Classroom Teacher'),
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

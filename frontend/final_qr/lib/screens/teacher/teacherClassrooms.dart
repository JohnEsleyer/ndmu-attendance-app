import 'package:final_qr/models/userDataModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:final_qr/widgets/classroomContainer.dart';

class TeacherClassrooms extends StatefulWidget {
  @override
  TeacherClassroomsState createState() => TeacherClassroomsState();
}

class TeacherClassroomsState extends State<TeacherClassrooms> {
  Future<List<dynamic>> fetchClasses() async {
    final response = await http.post(
      Uri.parse(
          'https://nice-bullfrog-86.telebit.io/all-classrooms-by-teacher'),
      body: jsonEncode({
        "teacher": {
          "id": Provider.of<UserDataProvider>(context).getUserData.userId,
        },
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return json.decode(response.body);
    } else {
      print("Error teacherClassroom fetch");
      // If that call was not successful, throw an error.
      throw Exception('Failed to load classes');
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            const Text(
              "Classrooms",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            Expanded(
              child: Center(
                child: FutureBuilder<List<dynamic>>(
                    future: fetchClasses(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 30,
                          width: 30,
                          child: const CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var className = snapshot.data[index]['className'];
                            var qrURL = snapshot.data[index]['qrURL'];
                            // var schedule = snapshot.data[index]['schedule'];
                            // var defaultTime = snapshot.data[index]['defaultTime'];

                            return ClassroomContainer(
                              subjectName: className,
                              qrURL: qrURL,
                              index: index,
                            );
                          },
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

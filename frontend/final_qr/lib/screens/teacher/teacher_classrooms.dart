import 'package:final_qr/models/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:final_qr/screens/teacher/classroom_container.dart';
import 'package:final_qr/constants_and_functions.dart';

class TeacherClassrooms extends StatefulWidget {
  @override
  TeacherClassroomsState createState() => TeacherClassroomsState();
}

class TeacherClassroomsState extends State<TeacherClassrooms> {
  Future<List<dynamic>> fetchClasses() async {
    final response = await http.post(
      Uri.parse('$server/all-classrooms-by-teacher'),
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
      color: Colors.green[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: const Text(
                "Classrooms",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              width: MediaQuery.of(context).size.width,
              child: Expanded(
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
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              var className = snapshot.data[index]['className'];
                              var qrURL = snapshot.data[index]['qrURL'];
                              var classId = snapshot.data[index]["id"];
                              // var schedule = snapshot.data[index]['schedule'];
                              // var defaultTime = snapshot.data[index]['defaultTime'];
                              print(qrURL);
                              return ClassroomContainer(
                                className: className,
                                qrURL: qrURL,
                                index: index,
                                classId: classId,
                              );
                            },
                          );
                        }
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

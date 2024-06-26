import 'package:final_qr/models/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:final_qr/screens/teacher/classroom_container.dart';
import 'package:final_qr/constants_and_functions.dart';
import 'package:final_qr/widgets/teacher_greenwhite_container.dart';
import 'package:final_qr/models/teacher_data_model.dart';

class TeacherClassrooms extends StatefulWidget {
  @override
  TeacherClassroomsState createState() => TeacherClassroomsState();
}

class TeacherClassroomsState extends State<TeacherClassrooms> {
  late Future<List<dynamic>> _futureClassrooms;
  int temp = 0;
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

  @override
  Widget build(BuildContext context) {
    return GreenWhiteContainer(
      fontSize: 50,
      title: "Classrooms",
      child: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.green,
        strokeWidth: 4.0,
        onRefresh: () {
          setState(() {
            temp++;
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },
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
                bool firstTime = Provider.of<TeacherData>(context).isFirstTime;
                if (!firstTime) {
                  Provider.of<TeacherData>(context).emptyClassroom();
                } else {
                  Provider.of<TeacherData>(context).setFirstTime(false);
                }

                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var className = snapshot.data[index]['className'];
                    var qrURL = snapshot.data[index]['qrURL'];
                    var classId = snapshot.data[index]["id"];
                    // var schedule = snapshot.data[index]['schedule'];
                    // var defaultTime = snapshot.data[index]['defaultTime'];

                    Provider.of<TeacherData>(context)
                        .appendClassroom(className);
                    Provider.of<TeacherData>(context)
                        .appendClassroomID(classId);
                    if (index == 0) {
                      Provider.of<TeacherData>(context).setSelected(
                          Provider.of<TeacherData>(context).getClassrooms[0]);
                    }
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
    );
  }
}

import 'package:final_qr/models/userDataModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

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
        "teacher": Provider.of<UserDataProvider>(context).getUserData.userId,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return json.decode(response.body);
    } else {
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
            Center(
              child: FutureBuilder<List<dynamic>>(
                  future: fetchClasses(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var className = snapshot.data[index]['className'];
                          var teacherFirstName =
                              snapshot.data[index]['teacher']['firstName'];
                          var teacherLastName =
                              snapshot.data[index]['teacher']['lastName'];
                          var schedule = snapshot.data[index]['schedule'];
                          var defaultTime = snapshot.data[index]['defaultTime'];

                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(className, style: TextStyle(fontSize: 18)),
                                SizedBox(height: 10),
                                Text(
                                    'Teacher: $teacherFirstName $teacherLastName'),
                                SizedBox(height: 5),
                                Text('Schedule: $schedule'),
                                SizedBox(height: 5),
                                Text('Default Time: $defaultTime'),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

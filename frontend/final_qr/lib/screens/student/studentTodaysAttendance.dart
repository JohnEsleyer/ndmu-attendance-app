import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';
import 'dart:async';
import 'dart:convert';

class TodaysAttendance extends StatefulWidget {
  _TodaysAttendanceState createState() => _TodaysAttendanceState();
}

class _TodaysAttendanceState extends State<TodaysAttendance> {
  List<String> items = [];

  Future<void> _refresh() async {
    final response = await http.post(
      Uri.parse(
        '$server/classdate-by-dateclass',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "date": "date",
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("200 Success");
      return json.decode(response.body);
    } else {
      print("error");
      throw Exception('Failed to load data');
    }

    // Parse the response and update the items list
    // setState(() {
    //   items = parseResponse(response);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.115),
          Center(
            child: Text(
              "Today's Attendance",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Container()
        ],
      ),
    );
  }
}

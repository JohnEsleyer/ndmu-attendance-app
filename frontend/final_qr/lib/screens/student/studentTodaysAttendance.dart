import 'package:final_qr/models/userDataModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_qr/constants_and_functions.dart';
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodaysAttendance extends StatefulWidget {
  _TodaysAttendanceState createState() => _TodaysAttendanceState();
}

Future<List<dynamic>> _loadClassDates(context) async {
  final response = await http.post(
    Uri.parse(
      '$server/classdates-by-studentdate',
    ),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      {
        "student": {
          "id": Provider.of<UserDataProvider>(context, listen: false)
              .getUserData
              .userId,
        },
        "date": DateFormat('MM/dd/yyyy').format(DateTime.now()),
      },
    ),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    print("200 Success");
    print(response.body);
    return json.decode(response.body);
  } else {
    print("error");
    throw Exception('Failed to load data');
  }
}

class _TodaysAttendanceState extends State<TodaysAttendance> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  DateTime _now = DateTime.now();
  List<String> items = [];

  late Future<List<dynamic>> _classDate;
  @override
  Widget build(BuildContext context) {
    setState(() {
      _classDate = _loadClassDates(context);
    });
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
          FutureBuilder<List<dynamic>>(
              future: _classDate,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: RefreshIndicator(
                      key: _refreshKey,
                      color: Colors.white,
                      backgroundColor: Colors.green,
                      strokeWidth: 4.0,
                      onRefresh: () async {
                        setState(() {
                          _classDate = _loadClassDates(context);
                        });
                        return Future<void>.delayed(const Duration(seconds: 3));
                      },
                      child: Container(
                        height: 500,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  height: 120,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            snapshot.data![index]["classroom"]
                                                ["className"],
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            snapshot.data![index]["time"],
                                            style: TextStyle(fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    child: CircularProgressIndicator(color: Colors.green),
                  );
                }
              }),
        ],
      ),
    );
  }
}

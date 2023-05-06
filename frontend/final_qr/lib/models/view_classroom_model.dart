import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:final_qr/constants_and_functions.dart';

class ViewClassroom {
  DateTime todayDate = DateTime.now();
  late int classId;
  late DateTime selectedDate;
  late List<DateTime> dates;
  late int currentIndex;

  ViewClassroom() {
    selectedDate = DateTime.now();
    currentIndex = 30;
    dates = getDateList(todayDate);
  }
}

class ViewClassroomProvider extends ChangeNotifier {
  ViewClassroom _viewClassroom = ViewClassroom();

  ViewClassroom get getViewClassroom => _viewClassroom;

  void setClassId(int classId) {
    this._viewClassroom.classId = classId;
    notifyListeners();
  }

  DateTime get getSelectedDate => this._viewClassroom.selectedDate;

  void setSelectedDate(DateTime date) {
    this._viewClassroom.selectedDate = date;
    notifyListeners();
  }

  List<DateTime> get getDates => this._viewClassroom.dates;
  void setDates(List<DateTime> dates) {
    this._viewClassroom.dates = dates;
    notifyListeners();
  }

  int get getCurrentIndex => this._viewClassroom.currentIndex;
  void setCurrentIndex(int currentIndex) {
    this._viewClassroom.currentIndex = currentIndex;
    notifyListeners();
  }

  Future<void> fetchClassDate(String date) async {
    String url = "$server/classdate-by-dateclass";
    Map<String, dynamic> body = {
      "date": date,
      "classroom": {"id": this._viewClassroom.classId}
    };
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // successful response
      print(response.body);
    } else {
      // error handling
      print(response.statusCode);
      print(response.body);
    }
  }
}

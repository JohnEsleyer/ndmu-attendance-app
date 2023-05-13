import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherData extends ChangeNotifier {
  bool _firstTime = true;
  List<String> _classrooms = [];
  List<int> _classroomIDs = [];
  void appendClassroom(String classroom) {
    _classrooms.add(classroom);
  }

  void appendClassroomID(int id) {
    _classroomIDs.add(id);
  }

  void emptyClassroom() {
    _classrooms = [];
    _classroomIDs = [];
  }

  void setFirstTime(bool x) {
    _firstTime = x;
  }

  bool get isFirstTime => _firstTime;
  List<String> get getClassrooms => _classrooms;
  List<int> get getClassroomID => _classroomIDs;
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherData extends ChangeNotifier {
  List<String> _classrooms = [];
  void appendClassroom(String classroom) {
    _classrooms.add(classroom);
  }

  List<String> get getClassrooms => _classrooms;
}

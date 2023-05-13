import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentReportData extends ChangeNotifier {
  String firstName;
  String lastName;
  int year;
  int id;

  StudentReportData(
      {required this.firstName,
      required this.lastName,
      required this.year,
      required this.id});
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_qr/models/student_report_model.dart';

class ReportGeneratorScreen extends StatefulWidget {
  @override
  _ReportGeneratorScreenState createState() => _ReportGeneratorScreenState();
}

class _ReportGeneratorScreenState extends State<ReportGeneratorScreen> {
  String _firstName = "";
  @override
  Widget build(BuildContext context) {
    _firstName = Provider.of<StudentReportData>(context).firstName;
    return Scaffold(
      body: Center(
        child: Text(_firstName),
      ),
    );
  }
}

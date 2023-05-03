import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: AdminScreen(),
      ),
    );

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Admin Screen"),
      ),
    );
  }
}

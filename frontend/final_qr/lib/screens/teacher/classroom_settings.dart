import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClassroomSetting extends StatefulWidget {
  @override
  _ClassroomSettingState createState() => _ClassroomSettingState();
}

class _ClassroomSettingState extends State<ClassroomSetting> {
  String _selectedTime = "15 minutes";

  final String apiUrl = "https://mywebsite.com"; // replace with your own URL

  void _sendPostRequest() async {
    var response = await http.post(Uri.parse(apiUrl), body: {
      'time': _selectedTime,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Selection'),
      ),
      body: Center(
        child: DropdownButton<String>(
          value: _selectedTime,
          hint: Text('Select Time'),
          items: <String>['15 minutes', '20 minutes', '30 minutes']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedTime = newValue!;
              _sendPostRequest();
            });
          },
        ),
      ),
    );
  }
}

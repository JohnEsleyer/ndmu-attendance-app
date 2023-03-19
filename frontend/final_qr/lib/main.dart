import 'package:flutter/material.dart';
import 'login.dart';
import 'student/studentScreen.dart';
import 'package:provider/provider.dart';
import 'models/userDataModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'QRApp',
        initialRoute: "/",
        routes: {
          '/': (context) => const Login(),
          '/student': (context) => StudentScreen(),
        },
      ),
    );
  }
}

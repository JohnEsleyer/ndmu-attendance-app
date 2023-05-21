import 'package:flutter/material.dart';
import 'login.dart';
import 'screens/student/student_screen.dart';
import 'package:provider/provider.dart';
import 'models/user_data_model.dart';
import 'screens/teacher/teacher_screen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'screens/admin/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QRApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Color.fromARGB(
                255, 0, 114, 34), // but now it should be declared like this
          ),
          highlightColor: Colors.green,
          splashColor: Colors.green,
          primaryColor: Colors.green,
        ),
        initialRoute: "/",
        routes: {
          '/': (context) => Login(),
          '/student': (context) => StudentScreen(),
          '/teacher': (context) => TeacherScreen(),
          '/admin': (context) => AdminScreen(),
        },
      ),
    );
  }
}

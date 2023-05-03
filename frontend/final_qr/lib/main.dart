import 'package:flutter/material.dart';
import 'login.dart';
import 'screens/studentScreen.dart';
import 'package:provider/provider.dart';
import 'models/userDataModel.dart';
import 'screens/teacherScreen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:final_qr/screens/admin/admin_home.dart';

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

import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async{
  await dotenv.load(fileName: ".env");
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RoleSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

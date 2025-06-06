import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_helper.dart'; // adjust path

class StudentDashboard extends StatefulWidget {
  final String studentId;
  final String token;

  const StudentDashboard({
    super.key,
    required this.studentId,
    required this.token,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboard();
}


class _StudentDashboard extends State<StudentDashboard> {
  String? studentName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchStudentName();
  }

  Future<void> fetchStudentData() async {
    final url = ApiHelper.getEndpoint("student/${widget.studentId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}', // ✅ Token used here
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        studentName = data['name']; // assuming response has 'name' field
      });
    } else {
      print('Failed to fetch student data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
          'Welcome, $studentName!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class StudentDashboard extends StatefulWidget {
//   final String token;
//   const StudentDashboard({super.key, required this.token});
//
//   @override
//   State<StudentDashboard> createState() => _StudentDashboard();
// }
//
// class _StudentDashboard extends State<StudentDashboard> {
//   final Color _primaryColor = const Color(0xFF4361EE);
//   final Color _secondaryColor = const Color(0xFF3F37C9);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Dashboard'),
//       ),
//     );
//   }
// }
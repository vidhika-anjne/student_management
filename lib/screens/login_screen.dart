import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:student_app/api_helper.dart';
import 'package:student_app/screens/student_dashboard.dart';
import 'admin_dashboard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {

    // const baseUrl = 'http://10.107.19.4:8080/api/v1/auth/login';
    // const baseUrl = 'http://10.254.110.4:8080/api/v1/auth/login';
    final String baseUrl = ApiHelper.getEndpoint("auth/login");


    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String roleFromApi = data['role'];
      final String token = data['token'];

      if (roleFromApi != widget.role) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Role mismatch!")),
        );
        return;
      }

      if (roleFromApi == "ADMIN") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminDashboard(token: token),
          ),
        );
      }
      // else if (roleFromApi == "STUDENT") {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => StudentDashboard(token: token),
      //     ),
      //   );
      // }
      else if (roleFromApi == "STUDENT") {
        final String studentId = data['id'];
        final String token = data['token']; // already retrieved

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDashboard(studentId: studentId, token: token),
          ),
        );
      }


    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login as ${widget.role}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

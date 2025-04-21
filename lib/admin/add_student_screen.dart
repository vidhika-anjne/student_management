import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStudentScreen extends StatefulWidget {
  final String token;

  const AddStudentScreen({super.key, required this.token});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController parentContactNumberController = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();

  String selectedBatch = 'B1'; // Default selected batch

  Future<void> addStudent() async {
    const baseUrl = 'http://10.107.19.4:8080/api/v1/admin/students'; // Update your IP

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'rollNumber': rollNumberController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'contactNumber': contactNumberController.text,
        'parentContactNumber': parentContactNumberController.text,
        'parentEmail': parentEmailController.text,
        'batch': selectedBatch,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student added successfully")),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F9FA), Color(0xFFD6EAF8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(usernameController, 'Username'),
                const SizedBox(height: 16),
                buildTextField(emailController, 'Email'),
                const SizedBox(height: 16),
                buildTextField(passwordController, 'Password', isPassword: true),
                const SizedBox(height: 16),
                buildTextField(rollNumberController, 'Roll Number'),
                const SizedBox(height: 16),
                buildTextField(firstNameController, 'First Name'),
                const SizedBox(height: 16),
                buildTextField(lastNameController, 'Last Name'),
                const SizedBox(height: 16),
                buildTextField(contactNumberController, 'Contact Number'),
                const SizedBox(height: 16),
                buildTextField(parentContactNumberController, 'Parent Contact Number'),
                const SizedBox(height: 16),
                buildTextField(parentEmailController, 'Parent Email'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedBatch,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBatch = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Batch",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: <String>["B1", "B2"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: addStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Add Student'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
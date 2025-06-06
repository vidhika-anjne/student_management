import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_app/api_helper.dart';

class AddStudentScreen extends StatefulWidget {
  final String token;
  const AddStudentScreen({super.key, required this.token});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController parentContactNumberController = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();

  String selectedBatch = 'B1';
  bool _isLoading = false;
  final List<String> _batches = ['B1', 'B2'];

  Future<void> addStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // const baseUrl = 'http://10.254.110.4:8080/api/v1/admin/students';
      final String baseUrl = ApiHelper.getEndpoint("admin/students");

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

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSuccessDialog();
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${responseBody['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    setState(() => selectedBatch = 'B1');
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 10),
            Text('Success', style: GoogleFonts.poppins()),
          ],
        ),
        content: Text('Student added successfully!',
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),),
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Personal Information'),
                _buildTextField(
                  controller: firstNameController,
                  label: 'First Name',
                  icon: Icons.person_outline,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                _buildTextField(
                  controller: lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                _buildTextField(
                  controller: rollNumberController,
                  label: 'Roll Number',
                  icon: Icons.confirmation_number_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                _buildBatchDropdown(),

                const SizedBox(height: 24),
                _buildSectionHeader('Account Details'),
                _buildTextField(
                  controller: usernameController,
                  label: 'Username',
                  icon: Icons.alternate_email,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  !value!.contains('@') ? 'Invalid email' : null,
                ),
                _buildTextField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) => value!.length < 6
                      ? 'Min 6 characters'
                      : null,
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('Contact Information'),
                _buildTextField(
                  controller: contactNumberController,
                  label: 'Contact Number',
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.length < 10
                      ? 'Invalid number'
                      : null,
                ),
                _buildTextField(
                  controller: parentContactNumberController,
                  label: 'Parent Contact',
                  icon: Icons.phone_iphone,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  controller: parentEmailController,
                  label: 'Parent Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildBatchDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedBatch,
        decoration: InputDecoration(
          labelText: "Batch",
          prefixIcon: const Icon(Icons.group_work, color: Colors.blueGrey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        items: _batches.map((batch) => DropdownMenuItem<String>(
          value: batch,
          child: Text(batch, style: GoogleFonts.poppins()),
        )).toList(),
        onChanged: (value) => setState(() => selectedBatch = value!),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : addStudent,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: _isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.person_add_alt_1, size: 24),
        label: Text(
          _isLoading ? 'Adding...' : 'Add Student',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
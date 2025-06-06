import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:student_app/api_helper.dart';

class AddSubjectPage extends StatefulWidget {
  final String token; // Pass JWT token from previous login

  const AddSubjectPage({Key? key, required this.token}) : super(key: key);

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final TextEditingController _subjectController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  Future<void> _addSubject() async {
    final subjectName = _subjectController.text.trim();
    if (subjectName.isEmpty) {
      setState(() {
        _message = "Please enter a subject name.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    final String baseUrl = ApiHelper.getEndpoint("admin/subjects");


    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({'subjectName': subjectName}),
    );

    setState(() {
      _isLoading = false;
      if (response.statusCode == 200) {
        _message = "Subject added successfully!";
        _subjectController.clear();
      } else {
        _message = "Failed to add subject: ${response.body}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Subject')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _addSubject,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Add Subject'),
            ),
            const SizedBox(height: 16),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.contains("successfully")
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

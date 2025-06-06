import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:student_app/api_helper.dart';


class ViewSubjectsPage extends StatefulWidget {
  final String token;

  const ViewSubjectsPage({Key? key, required this.token}) : super(key: key);

  @override
  State<ViewSubjectsPage> createState() => _ViewSubjectsPageState();
}

class _ViewSubjectsPageState extends State<ViewSubjectsPage> {
  List<dynamic> _subjects = [];
  bool _isLoading = true;
  String? _error;

  Future<void> _fetchSubjects() async {
    final url = Uri.parse(ApiHelper.getEndpoint("admin/subjects"));

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> subjects = json.decode(response.body);
        setState(() {
          _subjects = subjects;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load subjects. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Subjects')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : ListView.builder(
        itemCount: _subjects.length,
        itemBuilder: (context, index) {
          final subject = _subjects[index];
          return ListTile(
            title: Text(subject['subjectName'] ?? 'Unnamed Subject'),
          );
        },
      ),
    );
  }
}

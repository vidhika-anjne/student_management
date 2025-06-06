import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_app/api_helper.dart';


class ListStudentsScreen extends StatefulWidget {
  final String token;
  const ListStudentsScreen({super.key, required this.token});

  @override
  State<ListStudentsScreen> createState() => _ListStudentsScreenState();
}

class _ListStudentsScreenState extends State<ListStudentsScreen> {
  List<dynamic> students = [];
  List<dynamic> filteredStudents = [];
  bool isLoading = true;
  bool hasError = false;
  String searchQuery = '';
  String sortBy = 'name';

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      // const url = 'http://10.107.19.4:8080/api/v1/admin/students';
      final String url = ApiHelper.getEndpoint("admin/students");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          students = data;
          filteredStudents = data;
          isLoading = false;
          hasError = false;
        });
        _sortStudents();
      } else {
        _handleError();
      }
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    setState(() {
      isLoading = false;
      hasError = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to load students")),
    );
  }

  void _filterStudents(String query) {
    setState(() {
      searchQuery = query;
      filteredStudents = students.where((student) {
        final fullName = '${student['firstName']} ${student['lastName']}'.toLowerCase();
        final rollNo = student['rollNumber'].toString().toLowerCase();
        return fullName.contains(query.toLowerCase()) ||
            rollNo.contains(query.toLowerCase());
      }).toList();
      _sortStudents();
    });
  }

  void _sortStudents() {
    filteredStudents.sort((a, b) {
      switch (sortBy) {
        case 'name':
          return '${a['firstName']} ${a['lastName']}'
              .compareTo('${b['firstName']} ${b['lastName']}');
        case 'roll':
          return a['rollNumber'].compareTo(b['rollNumber']);
        case 'batch':
          return a['batch'].compareTo(b['batch']);
        default:
          return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchStudents,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) return _buildLoadingState();
    if (hasError) return _buildErrorState();
    return Column(
      children: [
        _buildSearchBar(),
        _buildSortControls(),
        Expanded(child: _buildStudentList()),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text('Fetching Students...',
              style: GoogleFonts.poppins(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 20),
          Text('Failed to load data',
              style: GoogleFonts.poppins(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchStudents,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by name or roll number...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onChanged: _filterStudents,
      ),
    );
  }

  Widget _buildSortControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text('Sort by:', style: GoogleFonts.poppins()),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: sortBy,
            items: const [
              DropdownMenuItem(value: 'name', child: Text('Name')),
              DropdownMenuItem(value: 'roll', child: Text('Roll No')),
              DropdownMenuItem(value: 'batch', child: Text('Batch')),
            ],
            onChanged: (value) {
              setState(() {
                sortBy = value!;
                _sortStudents();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return RefreshIndicator(
      onRefresh: fetchStudents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          final student = filteredStudents[index];
          return _buildStudentCard(student);
        },
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(student),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${student['firstName']} ${student['lastName']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.badge, 'Roll: ${student['rollNumber']}'),
                  _buildDetailRow(Icons.email, 'Email: ${student['email']}'),
                  _buildDetailRow(Icons.school, 'Batch: ${student['batch']}'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showStudentOptions(student),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> student) {
    return CircleAvatar(
      backgroundColor: Colors.blue.shade100,
      radius: 28,
      child: Text(
        '${student['firstName'][0]}${student['lastName'][0]}',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.poppins(fontSize: 14)),
        ],
      ),
    );
  }

  void _showStudentOptions(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Student'),
            onTap: () => _navigateToEdit(student),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Student', style: TextStyle(color: Colors.red)),
            onTap: () => _confirmDelete(student),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(Map<String, dynamic> student) {
    Navigator.pop(context);
    // Implement edit navigation
  }

  void _confirmDelete(Map<String, dynamic> student) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete ${student['firstName']} ${student['lastName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _deleteStudent(student),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteStudent(Map<String, dynamic> student) async {
    // Implement delete functionality
  }
}
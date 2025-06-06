import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_app/api_helper.dart';


class TeacherListPage extends StatefulWidget {
  final String token;
  const TeacherListPage({super.key, required this.token});

  @override
  _TeacherListPageState createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  List<dynamic> _teachers = [];
  List<dynamic> _filteredTeachers = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _searchQuery = '';
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  Future<void> _fetchTeachers() async {
    try {
      // const url = 'http://10.107.19.4:8080/api/v1/admin/teachers';
      final String url = ApiHelper.getEndpoint("admin/teachers");
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
          _teachers = data;
          _filteredTeachers = data;
          _isLoading = false;
          _hasError = false;
        });
        _sortTeachers();
      } else {
        _handleError();
      }
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    setState(() {
      _isLoading = false;
      _hasError = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to load teachers")),
    );
  }

  void _filterTeachers(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTeachers = _teachers.where((teacher) {
        final name = teacher['username'].toString().toLowerCase();
        final email = teacher['email'].toString().toLowerCase();
        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
      _sortTeachers();
    });
  }

  void _sortTeachers() {
    _filteredTeachers.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return a['username'].compareTo(b['username']);
        case 'subject':
          return a['subjectTaught'].compareTo(b['subjectTaught']);
        default:
          return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Directory',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTeachers,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoadingState();
    if (_hasError) return _buildErrorState();
    return Column(
      children: [
        _buildSearchBar(),
        _buildSortControls(),
        Expanded(child: _buildTeacherList()),
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
          Text('Loading Faculty...',
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
            onPressed: _fetchTeachers,
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
          hintText: 'Search by name or email...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onChanged: _filterTeachers,
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
            value: _sortBy,
            items: const [
              DropdownMenuItem(value: 'name', child: Text('Name')),
              DropdownMenuItem(value: 'subject', child: Text('Subject')),
            ],
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
                _sortTeachers();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherList() {
    return RefreshIndicator(
      onRefresh: _fetchTeachers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredTeachers.length,
        itemBuilder: (context, index) {
          final teacher = _filteredTeachers[index];
          return _buildTeacherCard(teacher);
        },
      ),
    );
  }

  Widget _buildTeacherCard(Map<String, dynamic> teacher) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(teacher),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher['username'] ?? 'No Name',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.email, teacher['email'] ?? 'No Email'),
                  if (teacher['subjectTaught'] != null)
                    _buildDetailRow(Icons.subject, teacher['subjectTaught']),
                  if (teacher['classesAssigned'] != null)
                    _buildDetailRow(Icons.class_,
                        'Classes: ${teacher['classesAssigned'].join(', ')}'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showTeacherOptions(teacher),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> teacher) {
    return CircleAvatar(
      backgroundColor: Colors.purple.shade100,
      radius: 28,
      child: Text(
        _getInitials(teacher['username'] ?? 'T'),
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.purple.shade800,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.substring(0, 2);
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 14))),
        ],
      ),
    );
  }

  void _showTeacherOptions(Map<String, dynamic> teacher) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () => _navigateToEdit(teacher),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_ind),
            title: const Text('View Schedule'),
            onTap: () => _viewSchedule(teacher),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Remove Teacher',
                style: TextStyle(color: Colors.red)),
            onTap: () => _confirmDelete(teacher),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(Map<String, dynamic> teacher) {
    Navigator.pop(context);
    // Implement edit navigation
  }

  void _viewSchedule(Map<String, dynamic> teacher) {
    Navigator.pop(context);
    // Implement schedule view
  }

  void _confirmDelete(Map<String, dynamic> teacher) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Removal'),
        content: Text('Remove ${teacher['username']} from faculty?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _deleteTeacher(teacher),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteTeacher(Map<String, dynamic> teacher) async {
    // Implement delete functionality
  }
}
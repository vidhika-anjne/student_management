import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_app/admin/add_student_screen.dart';
import 'package:student_app/admin/list_student_screen.dart';
import 'package:student_app/admin/approve_event_screen.dart';
import 'package:student_app/admin/teacher_list_screen.dart';
import 'package:student_app/admin/add_teacher_screen.dart';
import 'package:student_app/admin/add_subject_screen.dart';
import 'package:student_app/admin/list_subjects_screen.dart';
import 'package:student_app/admin/teacher_assignment_screen.dart';

class AdminDashboard extends StatefulWidget {
  final String token;
  const AdminDashboard({super.key, required this.token});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Color _primaryColor = const Color(0xFF4361EE);
  final Color _secondaryColor = const Color(0xFF3F37C9);

  final List<Map<String, dynamic>> _quickActions = [
    // {
    //   'title': 'Add Student',
    //   'icon': Icons.person_add_alt_1,
    //   'color': Color(0xFF4CC9F0),
    //   'action': (BuildContext context, String token) => Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => AddStudentScreen(token: token)),
    //   )
    // },
    // {
    //   'title': 'View Students',
    //   'icon': Icons.list,
    //   'color': Color(0xFF4895EF),
    //   'action': (BuildContext context, String token) => Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => ListStudentsScreen(token: token)),
    //   )
    // },
    {
      'title': 'Approve Event',
      'icon': Icons.event_available,
      'color': Color(0xFF7209B7),
      'action': (BuildContext context, String token) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ApproveEventScreen(token: token)),
      )
    },
    {
      'title': 'Class Report',
      'icon': Icons.assignment,
      'color': Color(0xFFF72585),
      'action': (_, __) {},
    },
    {
      'title': 'Student Report',
      'icon': Icons.assignment_ind,
      'color': Color(0xFF4895EF),
      'action': (_, __) {},
    },
    {
      'title': 'Attendance Analytics',
      'icon': Icons.analytics,
      'color': Color(0xFF3A0CA3),
      'action': (_, __) {},
    },
    {
      'title': 'Bulk Upload',
      'icon': Icons.cloud_upload,
      'color': Color(0xFF560BAD),
      'action': (_, __) {},
    },
    {
      'title': 'Assign Teacher',
      'icon': Icons.cloud_upload,
      'color': Color(0xFF560BAD),
      'action': (BuildContext context, _) {
        // For example, navigate to the TeacherAssignmentPage:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AssignTeacherPage()),
        );
      },
    }

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: _primaryColor,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview Metrics',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            _buildMetricsRow(),
            const SizedBox(height: 30),
            Text('Quick Actions',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            _buildQuickActionsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.school, size: 40, color: _primaryColor),
                ),
                const SizedBox(height: 10),
                Text('Admin Panel',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: _primaryColor),
            title: Text('Dashboard', style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.person_add, color: _primaryColor),
            title:
            Text('Add Student', style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddStudentScreen(token: widget.token))),
          ),
          ListTile(
            leading: Icon(Icons.list, color: _primaryColor),
            title:
            Text('View Students', style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ListStudentsScreen(token: widget.token))),
          ),
          ListTile(
            leading: Icon(Icons.person_add, color: _primaryColor),
            title:
            Text('Add Teachers', style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddTeacherPage(token: widget.token))),
          ),
          ListTile(
            leading: Icon(Icons.list, color: _primaryColor),
            title:
            Text('View Teachers', style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TeacherListPage(token: widget.token))),
          ),

          ListTile(
            leading: Icon(Icons.add, color: _primaryColor),
            title:
            Text('Add Subjects', style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddSubjectPage(token: widget.token))),
          ),

          ListTile(
            leading: Icon(Icons.list, color: _primaryColor),
            title:
            Text('View Subjects', style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewSubjectsPage(token: widget.token))),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Logout',
                style:
                GoogleFonts.poppins(color: Colors.red, fontSize: 14)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        _buildMetricCard('Students', '72', Icons.people_alt, 0xFF4CC9F0),
        const SizedBox(width: 15),
        _buildMetricCard('Teachers', '10', Icons.school, 0xFF7209B7),
        const SizedBox(width: 15),
        _buildMetricCard('Classes', '9', Icons.class_, 0xFFF72585),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, int color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(color).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: Color(color)),
            ),
            const SizedBox(height: 10),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(color))),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: _quickActions
          .map((action) => Material(
        color: action['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => action['action'](context, widget.token),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: action['color'].withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(action['icon'],
                      size: 30, color: action['color']),
                ),
                const SizedBox(height: 15),
                Text(action['title'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ],
            ),
          ),
        ),
      ))
          .toList(),
    );
  }
}
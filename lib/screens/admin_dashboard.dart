import 'package:flutter/material.dart';
import 'package:student_app/admin/add_student_screen.dart';
import 'package:student_app/admin/list_student_screen.dart';

class AdminDashboard extends StatefulWidget {
  final String token;
  const AdminDashboard({super.key, required this.token});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<String> _menuTitles = [
    'Dashboard',
    'Add Student',
    'Student List',
    'Bulk Upload',
    'Unassigned Students',
    'Add Teacher',
    'Teachers List',
    'Assign Teacher',
    'Add Class',
    'Classes List',
    'Add Club Head',
    'Add Admin',
    'Add Subject',
    'Subjects List',
    'Logout',
  ];

  final List<IconData> _menuIcons = [
    Icons.dashboard,
    Icons.person_add,
    Icons.format_list_bulleted,
    Icons.upload_file,
    Icons.group_remove,
    Icons.school,
    Icons.groups,
    Icons.person_pin_circle,
    Icons.class_,
    Icons.format_list_numbered,
    Icons.emoji_people,
    Icons.admin_panel_settings,
    Icons.book,
    Icons.menu_book,
    Icons.logout,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, Admin!'),
        backgroundColor: Colors.blueAccent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: _menuTitles.length,
          itemBuilder: (context, index) => ListTile(
            leading: Icon(_menuIcons[index], color: Colors.blueAccent),
            title: Text(_menuTitles[index]),
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              Navigator.pop(context);
              // Add navigation logic for each menu item here
              switch (index) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddStudentScreen(token: widget.token),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ListStudentsScreen(token: widget.token),
                    ),
                  );
                  break;
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Metrics
            const Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDashboardCard('Total Students', '120', Icons.person),
                _buildDashboardCard('Active Teachers', '15', Icons.school),
                _buildDashboardCard('Classes', '10', Icons.class_),
              ],
            ),
            const SizedBox(height: 32),
            // Quick Access Buttons
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildQuickActionButton('Add Student', Icons.person_add, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddStudentScreen(token: widget.token),
                    ),
                  );
                }),
                _buildQuickActionButton('Bulk Upload', Icons.upload_file, () {
                  // Add bulk upload navigation logic
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String count, IconData icon) {
    return Expanded(
      child: Card(
        color: Colors.blueAccent.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                count,
                style: const TextStyle(fontSize: 24, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      onPressed: onTap,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:student_app/api_helper.dart';

class ApproveEventScreen extends StatefulWidget {
  final String token;

  const ApproveEventScreen({super.key, required this.token});

  @override
  State<ApproveEventScreen> createState() => _ApproveEventScreenState();
}

class _ApproveEventScreenState extends State<ApproveEventScreen> {
  List<dynamic> pendingEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingEvents();
  }

  Future<void> fetchPendingEvents() async {
    final url = Uri.parse(ApiHelper.getEndpoint("admin/pending-events"));
    // final String baseUrl = ApiHelper.getEndpoint("admin/pending-events");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      setState(() {
        pendingEvents = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  Future<void> approveEvent(String id) async {
    // final url = Uri.parse('http://10.107.19.4:8080/api/admin/approve-event/$id');
    final url = Uri.parse(ApiHelper.getEndpoint("admin/approve-event"));
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      fetchPendingEvents(); // refresh list
    }
  }

  Future<void> rejectEvent(String id) async {
    final url = Uri.parse('http://10.107.19.4:8080/api/admin/reject-event/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      fetchPendingEvents(); // refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve Events')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingEvents.isEmpty
          ? const Center(child: Text('No pending events'))
          : ListView.builder(
        itemCount: pendingEvents.length,
        itemBuilder: (context, index) {
          final event = pendingEvents[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(event['name']),
              subtitle: Text("Organized by: ${event['organizer']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => approveEvent(event['id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => rejectEvent(event['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

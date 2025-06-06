import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_app/api_helper.dart';


class AssignTeacherPage extends StatefulWidget {
  @override
  _AssignTeacherPageState createState() => _AssignTeacherPageState();
}

class _AssignTeacherPageState extends State<AssignTeacherPage> {
  List<dynamic> teachers = [];
  List<dynamic> subjects = [];
  List<dynamic> classes = [];
  List<dynamic> lectureSlots = [];

  String? selectedTeacherId;
  String? selectedSubjectId;
  String? selectedClassId;
  String? selectedLectureType; // THEORY or LAB
  String? selectedBatch;       // B1, B2 or null
  List<String> selectedLectureSlotIds = [];

  final lectureTypes = ['THEORY', 'LAB'];
  final batches = ['B1', 'B2'];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      final tRes = await http.get(Uri.parse(ApiHelper.getEndpoint("teachers")));
      final sRes = await http.get(Uri.parse(ApiHelper.getEndpoint("subjects")));
      final cRes = await http.get(Uri.parse(ApiHelper.getEndpoint("classes")));
      final lRes = await http.get(Uri.parse(ApiHelper.getEndpoint("lecture-slots")));

      if (tRes.statusCode == 200 &&
          sRes.statusCode == 200 &&
          cRes.statusCode == 200 &&
          lRes.statusCode == 200) {
        setState(() {
          teachers = json.decode(tRes.body);
          subjects = json.decode(sRes.body);
          classes = json.decode(cRes.body);
          lectureSlots = json.decode(lRes.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // show error dialog/snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLab = selectedLectureType == 'LAB';

    return Scaffold(
      appBar: AppBar(title: Text('Assign Teacher to Lecture')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: selectedTeacherId,
              hint: Text('Select Teacher'),
              items: teachers
                  .map<DropdownMenuItem<String>>((teacher) => DropdownMenuItem(
                  value: teacher['id'], child: Text(teacher['username'] ?? ''))).toList(),
              onChanged: (val) => setState(() => selectedTeacherId = val),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSubjectId,
              hint: Text('Select Subject'),
              items: subjects
                  .map<DropdownMenuItem<String>>((subject) => DropdownMenuItem(
                  value: subject['id'], child: Text(subject['subjectName'] ?? ''))).toList(),
              onChanged: (val) => setState(() => selectedSubjectId = val),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedClassId,
              hint: Text('Select Class'),
              items: classes
                  .map<DropdownMenuItem<String>>((cls) => DropdownMenuItem(
                  value: cls['id'], child: Text(cls['className'] ?? ''))).toList(),
              onChanged: (val) => setState(() => selectedClassId = val),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLectureType,
              hint: Text('Select Lecture Type'),
              items: lectureTypes
                  .map((lt) => DropdownMenuItem(value: lt, child: Text(lt)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedLectureType = val;
                  if (val != 'LAB') selectedBatch = null;
                });
              },
            ),
            SizedBox(height: 16),
            if (isLab)
              DropdownButtonFormField<String>(
                value: selectedBatch,
                hint: Text('Select Batch'),
                items: batches
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (val) => setState(() => selectedBatch = val),
              ),
            SizedBox(height: 16),
            Text('Select Lecture Slots'),
            Wrap(
              spacing: 8,
              children: lectureSlots.map<Widget>((slot) {
                final slotId = slot['id'];
                final start = slot['startTime'] ?? '';
                final end = slot['endTime'] ?? '';
                final label = '${slot['slotNumber']} ($start - $end)';
                final selected = selectedLectureSlotIds.contains(slotId);
                return FilterChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (bool val) {
                    setState(() {
                      if (val) {
                        selectedLectureSlotIds.add(slotId);
                      } else {
                        selectedLectureSlotIds.remove(slotId);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (selectedTeacherId == null ||
                    selectedSubjectId == null ||
                    selectedClassId == null ||
                    selectedLectureType == null ||
                    (isLab && selectedBatch == null) ||
                    selectedLectureSlotIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all required fields')),
                  );
                  return;
                }

                // Build assignment requests for each selected slot
                for (var slotId in selectedLectureSlotIds) {
                  final assignment = {
                    "teacher": {"id": selectedTeacherId},
                    "assignedClass": {"id": selectedClassId},
                    "subject": {"id": selectedSubjectId},
                    "lectureType": selectedLectureType,
                    "batch": isLab ? selectedBatch : null,
                    "lectureSlot": {"id": slotId},
                  };

                  print('Assignment: $assignment');

                  // TODO: Call API for each assignment or batch call
                }
              },
              child: Text('Assign'),
            )
          ],
        ),
      ),
    );
  }
}

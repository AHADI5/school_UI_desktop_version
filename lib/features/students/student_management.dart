import 'package:flutter/material.dart';
import 'package:school_desktop/features/students/models/student_discipline.dart';
import 'package:school_desktop/features/students/models/student_information.dart';
import 'package:school_desktop/features/students/screens/attendance.dart';
import 'package:school_desktop/features/students/service/discipline_service.dart';
import 'package:school_desktop/features/students/service/student_service.dart';
import 'package:school_desktop/utils/constants.dart';

import 'student_form.dart';

class StudentWidget extends StatefulWidget {
  const StudentWidget({Key? key}) : super(key: key);

  @override
  _StudentWidgetState createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  StudentInfo? selectedStudent;
  List<StudentInfo> students = [];
  List<StudentInfo> filteredStudents = [];
  String searchQuery = '';
  bool isLoading = true;
  final StudentService studentService = StudentService();
  final DisciplineService disciplineService = DisciplineService();

  Discipline? disciplineData; // Store discipline data for selected student

  @override
  void initState() {
    super.initState();
    _fetchStudents(); // Fetch students on initialization
  }

  Future<void> _fetchStudents() async {
    setState(() {
      isLoading = true;
    });

    final fetchedStudents =
        await studentService.fetchStudents('$classRoomUrl/1/getAllStudents');
    setState(() {
      students = fetchedStudents ?? [];
      filteredStudents = students;
      isLoading = false;
    });
  }

  Future<void> _fetchDiscipline(int studentId) async {
    setState(() {
      isLoading = true;
    });

    final fetchedDiscipline = await disciplineService.fetchDisciplines('$disciplineUrl/$studentId');
    setState(() {
      disciplineData = fetchedDiscipline;
      isLoading = false;
    });
  }

  void filterStudents(String query) {
    setState(() {
      searchQuery = query;
      filteredStudents = students
          .where((student) =>
              student.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addNewStudent() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20.0),
          content: SingleChildScrollView(
            child: StudentForm(
              onAdd: (Students newStudent) async {
                setState(() {
                  isLoading = true;
                });

                final createdStudent = await studentService.createStudent(
                    '$studentUrl/register-student', newStudent);
                if (createdStudent != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Student added successfully!')),
                  );
                }

                setState(() {
                  isLoading = false;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewStudent,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  color: Colors.white,
                  child: Column(
                    children: [
                      if (isLoading) CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search Students',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: filterStudents,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: filteredStudents.map((student) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStudent = student;
                                  _fetchDiscipline(student
                                      .studentID); // Fetch discipline data
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: selectedStudent == student
                                      ? Colors.blue[100]
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      child: Text(student.name[0]),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(student.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: selectedStudent != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Profile',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text('ID: ${selectedStudent!.studentID}'),
                          Text('Name: ${selectedStudent!.name}'),
                          Text('Genre: ${selectedStudent!.gender}'),
                          const SizedBox(height: 20),
                          DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                const TabBar(
                                  tabs: [
                                    Tab(text: 'Présence'),
                                    Tab(text: 'Discipline'),
                                    Tab(text: 'Sorties'),
                                  ],
                                ),
                                SizedBox(
                                  height: 300,
                                  child: TabBarView(
                                    children: [
                                      AttendanceHistoryPage(
                                          attendanceResponses: disciplineData
                                                  ?.attendanceResponses ??
                                              []),
                                      Center(
                                          child: ListView(
                                        children: disciplineData?.incidents
                                                .map((incident) => ListTile(
                                                      title:
                                                          Text(incident.title),
                                                      subtitle:
                                                          Text(incident.date),
                                                    ))
                                                .toList() ??
                                            [],
                                      )),
                                      const Center(
                                          child: Text('Performance Content')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('Select a student to view details.')),
            ),
          ],
        ),
      ),
    );
  }
}

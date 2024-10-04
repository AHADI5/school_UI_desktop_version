// Teacher_widget.dart
import 'package:flutter/material.dart';
import 'Teacher_form.dart'; // Import the new form widget

class TeacherWidget extends StatefulWidget {
  const TeacherWidget({Key? key}) : super(key: key);

  @override
  _TeacherWidgetState createState() => _TeacherWidgetState();
}

class _TeacherWidgetState extends State<TeacherWidget> {
  Teacher? selectedTeacher;
  List<Teacher> Teachers = [
    Teacher(
      1,
      'Alice',
      '1A',
      'Intermédiaire',
      'Féminin',
      'Parent A, 0123456789, parentA@example.com', // Parent info: Name, Phone, Email
      'Quartier A, Avenue 1, Commune X, No. 10',   // Address info: Quartier, Avenue, Commune, No
    ),
    Teacher(
      2,
      'Bob',
      '2B',
      'Avancé',
      'Masculin',
      'Parent B, 0987654321, parentB@example.com',
      'Quartier B, Avenue 2, Commune Y, No. 20',
    ),
    Teacher(
      3,
      'Charlie',
      '1A',
      'Débutant',
      'Masculin',
      'Parent C, 0123498765, parentC@example.com',
      'Quartier C, Avenue 3, Commune Z, No. 30',
    ),
    Teacher(
      4,
      'David',
      '1B',
      'Intermédiaire',
      'Masculin',
      'Parent D, 0987612345, parentD@example.com',
      'Quartier D, Avenue 4, Commune W, No. 40',
    ),
    Teacher(
      5,
      'Eve',
      '2A',
      'Avancé',
      'Féminin',
      'Parent E, 0123412345, parentE@example.com',
      'Quartier E, Avenue 5, Commune V, No. 50',
    ),
  ];

  List<Teacher> filteredTeachers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredTeachers = Teachers;
  }

  void filterTeachers(String query) {
    setState(() {
      searchQuery = query;
      filteredTeachers = Teachers
          .where((Teacher) => Teacher.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

void _addNewTeacher() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(20.0),
        content: SingleChildScrollView(
          child: TeacherForm(
            onAdd: (newTeacher) {
              setState(() {
                Teachers.add(newTeacher);
                filteredTeachers = Teachers; // Reset the filtered list
              });

              // Show success message using the root context to access Scaffold
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Teacher added successfully!')),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog without adding
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
        onPressed: _addNewTeacher,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Teacher list
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Search bar
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search Teachers',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: filterTeachers,
                        ),
                      ),
                      // Responsive Teacher list
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: filteredTeachers.map((Teacher) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTeacher = Teacher;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4, // Set a width for responsiveness
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: selectedTeacher == Teacher ? Colors.blue[100] : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 2), // Changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(Teacher.name[0]),
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(Teacher.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Text('Class: ${Teacher.className}', style: const TextStyle(fontSize: 12)),
                                          Text('Option: ${Teacher.option}', style: const TextStyle(fontSize: 12)),
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

            // Add space between the left and right side
            const SizedBox(width: 20), // Space between left and right side

            // Right side: Display selected Teacher's information
            Expanded(
              flex: 2,
              child: selectedTeacher != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Teacher Profile',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text('ID: ${selectedTeacher!.id}'),
                          Text('Name: ${selectedTeacher!.name}'),
                          Text('Class: ${selectedTeacher!.className}'),
                          Text('Option: ${selectedTeacher!.option}'),
                          Text('Genre: ${selectedTeacher!.gender}'),
                          Text('Parent: ${selectedTeacher!.parent}'),
                          Text('Address: ${selectedTeacher!.address}'),
                          const SizedBox(height: 20),
                          // Tabs for "Attendance", "Discipline", "Performance"
                          const DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(text: 'Attendance'),
                                    Tab(text: 'Discipline'),
                                    Tab(text: 'Performance'),
                                  ],
                                ),
                                SizedBox(
                                  height: 300, // Placeholder for tab content
                                  child: TabBarView(
                                    children: [
                                      Center(child: Text('Attendance Content')),
                                      Center(child: Text('Discipline Content')),
                                      Center(child: Text('Performance Content')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(child: Text('Select a Teacher to view details.')),
            ),
          ],
        ),
      ),
    );
  }
}

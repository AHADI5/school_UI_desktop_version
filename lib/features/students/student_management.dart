// student_widget.dart
import 'package:flutter/material.dart';
import 'student_form.dart'; // Import the new form widget

class StudentWidget extends StatefulWidget {
  const StudentWidget({Key? key}) : super(key: key);

  @override
  _StudentWidgetState createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  Student? selectedStudent;
  List<Student> students = [
    Student(
      1,
      'Alice',
      '1A',
      'Intermédiaire',
      'Féminin',
      'Parent A, 0123456789, parentA@example.com', // Parent info: Name, Phone, Email
      'Quartier A, Avenue 1, Commune X, No. 10',   // Address info: Quartier, Avenue, Commune, No
    ),
    Student(
      2,
      'Bob',
      '2B',
      'Avancé',
      'Masculin',
      'Parent B, 0987654321, parentB@example.com',
      'Quartier B, Avenue 2, Commune Y, No. 20',
    ),
    Student(
      3,
      'Charlie',
      '1A',
      'Débutant',
      'Masculin',
      'Parent C, 0123498765, parentC@example.com',
      'Quartier C, Avenue 3, Commune Z, No. 30',
    ),
    Student(
      4,
      'David',
      '1B',
      'Intermédiaire',
      'Masculin',
      'Parent D, 0987612345, parentD@example.com',
      'Quartier D, Avenue 4, Commune W, No. 40',
    ),
    Student(
      5,
      'Eve',
      '2A',
      'Avancé',
      'Féminin',
      'Parent E, 0123412345, parentE@example.com',
      'Quartier E, Avenue 5, Commune V, No. 50',
    ),
  ];

  List<Student> filteredStudents = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
  }

  void filterStudents(String query) {
    setState(() {
      searchQuery = query;
      filteredStudents = students
          .where((student) => student.name.toLowerCase().contains(query.toLowerCase()))
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
            onAdd: (newStudent) {
              setState(() {
                students.add(newStudent);
                filteredStudents = students; // Reset the filtered list
              });

              // Show success message using the root context to access Scaffold
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Student added successfully!')),
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
        onPressed: _addNewStudent,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Student list
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
                            labelText: 'Search Students',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: filterStudents,
                        ),
                      ),
                      // Responsive student list
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
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4, // Set a width for responsiveness
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: selectedStudent == student ? Colors.blue[100] : Colors.white,
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
                                      child: Text(student.name[0]),
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Text('Class: ${student.className}', style: const TextStyle(fontSize: 12)),
                                          Text('Option: ${student.option}', style: const TextStyle(fontSize: 12)),
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

            // Right side: Display selected student's information
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
                          Text('ID: ${selectedStudent!.id}'),
                          Text('Name: ${selectedStudent!.name}'),
                          Text('Class: ${selectedStudent!.className}'),
                          Text('Option: ${selectedStudent!.option}'),
                          Text('Genre: ${selectedStudent!.gender}'),
                          Text('Parent: ${selectedStudent!.parent}'),
                          Text('Address: ${selectedStudent!.address}'),
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
                  : Center(child: Text('Select a student to view details.')),
            ),
          ],
        ),
      ),
    );
  }
}

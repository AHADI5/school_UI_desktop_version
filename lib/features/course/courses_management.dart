import 'package:flutter/material.dart';

class CourseManagement extends StatefulWidget {
  @override
  _CourseManagementState createState() => _CourseManagementState();
}

class _CourseManagementState extends State<CourseManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample data for courses
  final List<String> courses = [
    'Course A',
    'Course B',
    'Course C',
    'Course D',
  ];

  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side: List of courses
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(courses[index]),
                  onTap: () {
                    setState(() {
                      selectedCourse = courses[index];
                    });
                  },
                );
              },
            ),
          ),
          VerticalDivider(),
          // Right side: Management section
          Expanded(
            flex: 3,
            child: selectedCourse != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Gestion de $selectedCourse',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Tabs for management section
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'Matériel requis'),
                          Tab(text: 'Informations générales'),
                          Tab(text: 'Objectifs du cours'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Center(child: Text('Matériel requis')),
                            Center(child: Text('Informations générales')),
                            Center(child: Text('Objectifs du cours')),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text('Sélectionnez un cours.'),
                  ),
          ),
        ],
      ),
    );
  }
}

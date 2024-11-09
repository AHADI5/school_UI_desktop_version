import 'package:flutter/material.dart';

class ClassroomManagement extends StatefulWidget {
  @override
  _ClassroomManagementState createState() => _ClassroomManagementState();
}

class _ClassroomManagementState extends State<ClassroomManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample data for classrooms
  final List<String> classrooms = [
    'Classroom A',
    'Classroom B',
    'Classroom C',
    'Classroom D',
  ];

  String? selectedClassroom;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
          // Left side: List of classrooms
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: classrooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(classrooms[index]),
                  onTap: () {
                    setState(() {
                      selectedClassroom = classrooms[index];
                    });
                  },
                );
              },
            ),
          ),
          const VerticalDivider(),
          // Right side: Management section
          Expanded(
            flex: 3,
            child: selectedClassroom != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Gestion de $selectedClassroom',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Tabs for management section
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Élèves inscrits'),
                          Tab(text: 'Cours'),
                          Tab(text: 'Horaires'),
                          Tab(text: 'Infos générales'),
                          Tab(text: 'Matériels requis'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: const [
                            Center(child: Text('Élèves inscrits')),
                            Center(child: Text('Cours')),
                            Center(child: Text('Horaires')),
                            Center(child: Text('Infos générales')),
                            Center(child: Text('Matériels requis')),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text('Sélectionnez une salle de classe.'),
                  ),
          ),
        ],
      ),
    );
  }
}

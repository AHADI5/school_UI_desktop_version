import 'package:flutter/material.dart';
import 'package:school_desktop/features/parents/models/parent.dart';
import 'package:school_desktop/features/parents/service/parents_service.dart';
import 'package:school_desktop/utils/constants.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({Key? key}) : super(key: key);

  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  Parent? selectedParent;
  ParentService parentService = ParentService();
  List<Parent> parents = [];
  List<Parent> filteredParents = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParents();
  }

  Future<void> fetchParents() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch data using the service
      List<Parent>? fetchedParents = await parentService.fetchParents('$studentUrl/2/parents');
      setState(() {
        parents = fetchedParents!;
        filteredParents = fetchedParents;
        isLoading = false;
      });
    } catch (error) {
      // Handle error and stop loading state
      setState(() {
        isLoading = false;
      });
      // You might want to show an error message here
      print("Failed to fetch parents: $error");
    }
  }

  void filterParents(String query) {
    setState(() {
      searchQuery = query;
      filteredParents = parents
          .where((parent) =>
              parent.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Parent list
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
                            labelText: 'Search Parents',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: filterParents,
                        ),
                      ),
                      const SizedBox(height: 10),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: filteredParents.map((parent) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedParent = parent;
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: selectedParent == parent
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
                                          child: Text(parent.name[0]),
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${parent.name} ${parent.lastName}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('Phone: ${parent.phone}',
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                              Text('Email: ${parent.email}',
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 20), // Space between left and right side

            // Right side: Display selected parent's information
            Expanded(
              flex: 2,
              child: selectedParent != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parent Profile',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                         
                          Text(
                              'Name: ${selectedParent!.name} ${selectedParent!.lastName}'),
                          Text('Phone: ${selectedParent!.phone}'),
                          Text('Email: ${selectedParent!.email}'),
                          const SizedBox(height: 20),
                          DefaultTabController(
                            length: 4,
                            child: Column(
                              children: [
                                const TabBar(
                                  tabs: [
                                    Tab(text: 'Student List'),
                                    Tab(text: 'Messages'),
                                    Tab(text: 'Requests'),
                                    Tab(text: 'Rendez-vous'),
                                  ],
                                ),
                                SizedBox(
                                  height: 300,
                                  child: TabBarView(
                                    children: [
                                      // Student List Tab
                                      selectedParent!.students.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: selectedParent!
                                                  .students.length,
                                              itemBuilder: (context, index) {
                                                final student = selectedParent!
                                                    .students[index];
                                                return ListTile(
                                                  title: Text(
                                                      '${student.name} ${student.lastName}'),
                                                  subtitle: Text(
                                                      'Class: ${student.classRoomName}'),
                                                );
                                              },
                                            )
                                          : const Center(
                                              child:
                                                  Text('No students found.')),
                                      // Messages Tab
                                      const Center(
                                          child: Text('Messages Content')),
                                      // Requests Tab
                                      const Center(
                                          child: Text('Requests Content')),
                                      // Rendez-vous Tab
                                      const Center(
                                          child: Text('Rendez-vous Content')),
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
                      child: Text('Select a parent to view details.')),
            ),
          ],
        ),
      ),
    );
  }
}

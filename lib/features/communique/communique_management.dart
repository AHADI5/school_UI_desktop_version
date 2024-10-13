// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:flutter_quill/flutter_quill.dart';

// class SchoolHomePage extends StatefulWidget {
//   const SchoolHomePage({super.key});

//   @override
//   SchoolHomePageState createState() => SchoolHomePageState();
// }

// class SchoolHomePageState extends State<SchoolHomePage> {
//   String selectedFilter = "Personal"; // Default filter selection
//   String searchQuery = ""; // To store the search query

//   String? selectedRecipient; // Track the currently selected recipient

//   // Dummy data for communications with each recipient
//   final Map<String, List<String>> communications = {
//     "Kevin Nicholas": ["Sometimes I wish..."],
//     "Kenda Jenner": ["La saeta, al final...", "Those were the good times..."],
//     "Lydia Paulina": ["I lost my way..."],
//     "Katherine Imani": ["Calling you late at night..."],
//     "Gabriel Jesus": ["I wish I could forget..."],
//     "Kevin de Bruyne": ["I've seen all the pain..."],
//     "Lukaku Tohlong": ["I let you take all my pride..."],
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // Left Column (User list)
//           Expanded(
//             flex: 2,
//             child: Container(
//               color: Colors.grey[50],
//               child: Column(
//                 children: [
//                   // Row for search bar and filter icon button
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         // Search bar
//                         Expanded(
//                           // Wrap TextField in Expanded to fill available space
//                           child: TextField(
//                             onChanged: (value) {
//                               setState(() {
//                                 searchQuery = value; // Update search query
//                               });
//                             },
//                             decoration: const InputDecoration(
//                               labelText: 'Search',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                         // Filter icon button
//                         IconButton(
//                           icon: const Icon(Icons.filter_list),
//                           onPressed: () {
//                             // Show filter options in a dialog
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: const Text('Select Filter'),
//                                   content: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       RadioListTile<String>(
//                                         title: const Text('Personal'),
//                                         value: 'Personal',
//                                         groupValue: selectedFilter,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             selectedFilter =
//                                                 value!; // Update filter selection
//                                           });
//                                           Navigator.of(context)
//                                               .pop(); // Close dialog
//                                         },
//                                       ),
//                                       RadioListTile<String>(
//                                         title: const Text('Group'),
//                                         value: 'Group',
//                                         groupValue: selectedFilter,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             selectedFilter =
//                                                 value!; // Update filter selection
//                                           });
//                                           Navigator.of(context)
//                                               .pop(); // Close dialog
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   // User list based on search query and filter
//                   Expanded(
//                     child: ListView(
//                       children: communications.keys
//                           .where((recipient) => recipient
//                               .toLowerCase()
//                               .contains(searchQuery
//                                   .toLowerCase())) // Filter by search query
//                           .map((recipient) {
//                         // Modify this condition if needed to filter by type
//                         if (selectedFilter == "Personal") {
//                           // Assuming all entries are personal for now
//                           return buildUserTile(
//                               recipient, communications[recipient]!.first);
//                         } else {
//                           // For groups, you can implement additional logic
//                           return Container(); // Return an empty container for group filter
//                         }
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Right Column (Message thread for selected recipient)
//           Expanded(
//             flex: 5,
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               child: selectedRecipient == null
//                   ? const Center(
//                       child: Text(
//                         "Select a recipient to view communications",
//                         style: TextStyle(color: Colors.grey, fontSize: 18),
//                       ),
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header with recipient's details
//                         Row(
//                           children: [
//                             CircleAvatar(child: Text(selectedRecipient![0])),
//                             const SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   selectedRecipient!,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 Text(
//                                   "${selectedRecipient!.toLowerCase().replaceAll(' ', '')}@mail.com",
//                                   style: const TextStyle(color: Colors.grey),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),

//                         // Messages list for the selected recipient
//                         Expanded(
//                           child: ListView(
//                             children: communications[selectedRecipient]!
//                                 .map((message) => buildMessageBubble(message))
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ],
//       ),

//       // Floating Action Button (FAB) to add new communique
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle the logic for adding a new communique
//           _showAddCommuniqueDialog(context);
//         },
//         tooltip: "Add New Communique",
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget buildMessageBubble(String message) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Text(
//         message,
//         style: const TextStyle(fontSize: 16, height: 1.5),
//       ),
//     );
//   }

//   // Build a list tile for each recipient
//   Widget buildUserTile(String name, String messagePreview) {
//     return ListTile(
//       leading: CircleAvatar(child: Text(name[0])),
//       title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text(messagePreview),
//       trailing: const Text("18:30 PDT", style: TextStyle(color: Colors.grey)),
//       onTap: () {
//         // Update the selected recipient when clicked
//         setState(() {
//           selectedRecipient = name;
//         });
//       },
//     );
//   }

//   // Redesigned and Simplified Dialog Box for adding a communique
//   void _showAddCommuniqueDialog(BuildContext context) {
//     quill.QuillController quillController = quill.QuillController.basic();
//     TextEditingController titleController = TextEditingController();
//     TextEditingController recipientController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.all(16.0),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.6,
//             height: MediaQuery.of(context).size.height *
//                 0.7, // Adjusted height to accommodate fields
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Dialog Title
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(14.0),
//                       child: Text(
//                         'Nouveau communiqué',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),

//                 // Title Field
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: TextField(
//                     controller: titleController,
//                     decoration: const InputDecoration(
//                       labelText: 'Titre du communiqué',
//                     ),
//                   ),
//                 ),

//                 // Recipient Field
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: TextField(
//                     controller: recipientController,
//                     decoration: const InputDecoration(
//                       labelText: 'Destinataire',
//                     ),
//                   ),
//                 ),

//                 //Tool Bat

//                 const SizedBox(height: 10),
//                 QuillSimpleToolbar(
//                   controller: quillController,
//                   configurations: const QuillSimpleToolbarConfigurations(
//                     toolbarIconAlignment: WrapAlignment.start,
//                     showInlineCode: false,
//                     showClearFormat: false,
//                     showIndent: false,
//                     showSearchButton: false,
//                     multiRowsDisplay: false,
//                     color: Color.fromARGB(255, 240, 246, 249),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // Text Editor (Quill)
//                 Expanded(
//                   child: quill.QuillEditor.basic(
//                     controller: quillController,
//                     configurations: const quill.QuillEditorConfigurations(
//                         padding: EdgeInsets.all(8.0)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             IconButton(
//                 onPressed: () {}, icon: const Icon(Icons.attach_file_outlined)),
//             IconButton(onPressed: () {}, icon: const Icon(Icons.photo)),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle the communiqué logic (you can customize this part)

//                 Navigator.of(context).pop(); // Close dialog after processing
//               },
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(
//                     Colors.lightBlue), // Light blue background
//                 foregroundColor: MaterialStateProperty.all<Color>(
//                     Colors.white), // White text
//               ),
//               child: const Text('Envoyer'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:school_desktop/features/communique/model/Communique.dart';
import 'package:school_desktop/features/communique/model/recipients.dart';
import 'package:school_desktop/features/communique/service/recepient_service.dart';
import 'package:school_desktop/utils/constants.dart';

class SchoolHomePage extends StatefulWidget {
  const SchoolHomePage({super.key});

  @override
  SchoolHomePageState createState() => SchoolHomePageState();
}

class SchoolHomePageState extends State<SchoolHomePage> {
  final SectionService sectionService = SectionService();
  List<Section> sections = [];
  List<CommuniqueModel> communiques = [];
  String? selectedGroup;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSections();
  }

  // Fetches sections dynamically from the server
  Future<void> fetchSections() async {
    List<Section>? fetchedSections =
        await sectionService.fetchSections('$classRoomUrl/${2}/communicationCorespondent');
    setState(() {
      sections = fetchedSections ?? [];
      isLoading = false;
    });
  }

  // Fetches communiqués dynamically based on the selected group
  Future<void> fetchCommuniques(String groupName) async {
    setState(() {
      communiques = [
        CommuniqueModel(
          communiqueID: 1,
          title: "Communiqué for $groupName",
          content: "Important information for $groupName",
          publishedDate: DateTime.now(),
          recipientType: "Group",
          groupName: groupName,
          recipients: ['example1@example.com', 'example2@example.com'],
        ),
        CommuniqueModel(
          communiqueID: 2,
          title: "Another Communiqué for $groupName",
          content: "Additional details for $groupName",
          publishedDate: DateTime.now(),
          recipientType: "Group",
          groupName: groupName,
          recipients: ['example3@example.com', 'example4@example.com'],
        ),
      ];
    });
  }

  // Opens the dialog to create a new communiqué
  void _showAddCommuniqueDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Communiqué'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
              DropdownButton<String>(
                hint: const Text("Select Group"),
                value: selectedGroup,
                onChanged: (String? value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
                items:
                    sections.map<DropdownMenuItem<String>>((Section section) {
                  return DropdownMenuItem<String>(
                    value: section.sectionName,
                    child: Text(section.sectionName),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to save communiqué
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Left Column: Section list
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey[200],
                    child: ListView.builder(
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(sections[index].sectionName),
                          onTap: () {
                            fetchCommuniques(sections[index].sectionName);
                            setState(() {
                              selectedGroup = sections[index].sectionName;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                // Right Column: Communiqués list
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.white,
                    child: selectedGroup == null
                        ? const Center(
                            child: Text('Select a group to view communiqués'))
                        : ListView.builder(
                            itemCount: communiques.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(communiques[index].title),
                                subtitle: Text(communiques[index].content),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCommuniqueDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

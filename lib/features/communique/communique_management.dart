import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:school_desktop/features/communique/model/Communique.dart';
import 'package:school_desktop/features/communique/model/communiqueSent.dart';
import 'package:school_desktop/features/communique/model/recipients.dart';
import 'package:school_desktop/features/communique/service/communique_service.dart';
import 'package:school_desktop/features/communique/service/recepient_service.dart';
import 'package:school_desktop/utils/constants.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class SchoolHomePage extends StatefulWidget {
  const SchoolHomePage({super.key});

  @override
  SchoolHomePageState createState() => SchoolHomePageState();
}

class SchoolHomePageState extends State<SchoolHomePage> {
  final Logger _logger = Logger();
  final SectionService sectionService = SectionService();
  final CommuniqueService _communiqueService = CommuniqueService();
  List<Section> sections = [];
  List<CommuniqueResponse> communiques = [];
  String? selectedGroup;
  bool isLoading = true;
  Map<String, List<String>> parentGroups = {};

  //A list to contain   a list of parent reviews
  List<CommuniqueReviewRegisterResponse> communiqueReviews = [];
  CommuniqueResponse? selectedCommunique;

  @override
  void initState() {
    super.initState();
    fetchSectionsAndGroupParents();
  }

  Future<void> fetchSectionsAndGroupParents() async {
    List<Section>? fetchedSections = await sectionService
        .fetchSections('$classRoomUrl/${2}/communicationCorespondent');
    if (fetchedSections != null) {
      setState(() {
        sections = fetchedSections.map((section) {
          section.sectionName = utf8.decode(section.sectionName.runes.toList());
          for (var level in section.parentPerLevelList) {
            for (var classroom in level.parentPerClassRoomList) {
              classroom.classRoomName =
                  utf8.decode(classroom.classRoomName.runes.toList());
            }
          }
          return section;
        }).toList();
        isLoading = false;
        groupParentEmails();
      });
    }
  }

  void groupParentEmails() {
    Map<String, List<String>> groupedParents = {};
    for (var section in sections) {
      String sectionGroupName = section.sectionName[0];
      groupedParents[sectionGroupName] = [];
      for (var level in section.parentPerLevelList) {
        String levelGroupName = "${section.sectionName[0]}-L${level.level}";
        groupedParents[levelGroupName] = [];
        for (var classroom in level.parentPerClassRoomList) {
          String classroomGroupName =
              "${section.sectionName[0]}-L${level.level}-${classroom.classRoomName}";
          groupedParents[classroomGroupName] = classroom.parentEmails;
          groupedParents[levelGroupName]?.addAll(classroom.parentEmails);
          groupedParents[sectionGroupName]?.addAll(classroom.parentEmails);
        }
      }
    }
    parentGroups = groupedParents;
    _logger.i("The parent Groups is $groupedParents");
  }

  Future<void> fetchCommuniques(String groupName) async {
    //Encode group name to v
    var url = '$communiqueUrl/2/communicationsByGroupName/$groupName';

    final fetchedCommuniques = await _communiqueService.fetchCommuniques(
      url, // Replace with the actual URL
    );
    _logger.i(" Fetched communique  :  $fetchedCommuniques");

    setState(() {
      communiques = fetchedCommuniques ?? [];
    });
  }

  void _showAddCommuniqueDialog(BuildContext context) {
    quill.QuillController quillController = quill.QuillController.basic();
    TextEditingController titleController = TextEditingController();
    TextEditingController recipientController = TextEditingController();
    bool isLoading = false;

    // Pre-fill recipient emails if a group is selected
    if (selectedGroup != null && parentGroups[selectedGroup] != null) {
      recipientController.text = parentGroups[selectedGroup]!.join(', ');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          'Nouveau communiqué',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title Field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titre du communiqué',
                      ),
                    ),
                  ),

                  // Recipient Field with Tags
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: recipientController,
                      decoration: const InputDecoration(
                        labelText: 'Destinataires',
                        hintText: 'Emails',
                      ),
                      readOnly: true,
                      maxLines: null,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tool Bar
                  QuillSimpleToolbar(
                    controller: quillController,
                    configurations: const QuillSimpleToolbarConfigurations(
                      toolbarIconAlignment: WrapAlignment.start,
                      showInlineCode: false,
                      showClearFormat: false,
                      showIndent: false,
                      showSearchButton: false,
                      multiRowsDisplay: false,
                      color: Color.fromARGB(255, 240, 246, 249),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Text Editor (Quill)
                  Expanded(
                    child: quill.QuillEditor.basic(
                      controller: quillController,
                      configurations: const quill.QuillEditorConfigurations(
                          padding: EdgeInsets.all(8.0)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.photo)),

              // Send Button with Loader
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        String title = titleController.text;
                        String content = quillController.document.toPlainText();
                        String recipientType = "GROUP"; // Assuming group type
                        String recipientGroupName = selectedGroup ?? "";
                        List<dynamic> recipientIDs =
                            parentGroups[selectedGroup] ?? [];

                        // Create Message instance
                        Message message = Message(
                          title: title,
                          content: content,
                          recipientType: recipientType,
                          recipientGroupName: recipientGroupName,
                          recipientIDs: recipientIDs,
                        );

                        // Send message and receive CommuniqueResponse
                        try {
                          CommuniqueResponse? response =
                              await _communiqueService.createCommunique(
                                  '$communiqueUrl/2/newCommunique', message);

                          // Process or display the CommuniqueResponse as needed
                          print(
                              'Communique created with ID: ${response?.communiqueID}');

                          Navigator.of(context)
                              .pop(); // Close dialog after processing
                        } catch (error) {
                          // Handle error
                          print("Failed to create communique: $error");
                        }

                        setState(() {
                          isLoading = false;
                        });
                      },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text('Envoyer'),
              ),
            ],
          ),
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
                // Left Column: Groups List
                Expanded(
                  flex: 1,
                  child: _buildGroupsList(),
                ),
                // Right Column: Communiqués and Details

                Expanded(
                  flex: 4,
                  child: selectedGroup == null
                      ? const Center(
                          child: Text('Select a group to view communiqués'))
                      : _buildCommuniquesSection(),
                ),
              ],
            ),
    );
  }

  Widget _buildGroupsList() {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.group,
                size: 24,
                color: Colors.black,
              ),
              SizedBox(width: 8),
              Text(
                'Groups',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: parentGroups.keys.length,
              itemBuilder: (context, index) {
                final groupName = parentGroups.keys.elementAt(index);
                final isSelected = groupName == selectedGroup;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGroup = groupName;
                      fetchCommuniques(groupName);
                      selectedCommunique = null; // Reset selected communique
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(
                              255, 228, 232, 241) // Background if selected
                          : Colors.transparent, // No background if not selected
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getAvatarColor(groupName),
                        child: Text(
                          groupName[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(groupName),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// Define a function to generate a unique color for each group
  Color getAvatarColor(String groupName) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.cyan,
      Colors.amber,
    ];
    // Use the hashCode of the group name to assign a color from the list
    return colors[groupName.hashCode % colors.length];
  }

Widget _buildCommuniquesSection() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: communiques.length,
            itemBuilder: (context, index) {
              final communique = communiques[index];

              // Decode title and content if needed
              final title = utf8.decode(communique.title?.runes.toList() ?? []);
              final content = utf8.decode(communique.content?.runes.toList() ?? []);

              // Retrieve reviewer counts
              final totalReviewers = communique.reviewRegisterResponses?.length ?? 0;
              final trueStatusCount = communique.reviewRegisterResponses?.where((reviewer) => reviewer.status == true).length ?? 0;
              final falseStatusCount = totalReviewers - trueStatusCount;

              return Card(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      title: Text(
                        title.isNotEmpty ? title : "No Title",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        content.isNotEmpty ? content : "No Content",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd – kk:mm').format(communique.publishedDate!),
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Handle modify action
                              print('Modify communique: $title');
                            },
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              // Handle menu actions
                              if (value == 'Print') {
                                print('Print communique: $title');
                              } else if (value == 'Delete') {
                                print('Delete communique: $title');
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Print',
                                child: Text('Print'),
                              ),
                              const PopupMenuItem(
                                value: 'Delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          selectedCommunique = communique;
                        });
                      },
                    ),
                    // Reviewer count section at the bottom
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                      child: Text(
                        "$trueStatusCount | $falseStatusCount | $totalReviewers",
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (selectedCommunique != null)
          _buildReviewersList()
        else
          const Center(child: Text('Select a communique to view reviewers')),
        const Divider(),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () => _showAddCommuniqueDialog(context),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            tooltip: 'Add Communiqué',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildReviewersList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review title
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Révue du communiqué',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  // Review container
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 228, 232, 241),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount:
                          selectedCommunique!.reviewRegisterResponses?.length ??
                              0,
                      itemBuilder: (context, index) {
                        final reviewer =
                            selectedCommunique!.reviewRegisterResponses![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Reviewer name
                              Expanded(
                                flex: 2,
                                child: Text(
                                  reviewer.recipient ?? "Unknown",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                              // Date of review
                              Expanded(
                                flex: 1,
                                child: Text(
                                  reviewer.date != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(reviewer.date!)
                                      : "Non signé",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                              ),
                              // Review status icon
                              Icon(
                                reviewer.status == true
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: reviewer.status == true
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

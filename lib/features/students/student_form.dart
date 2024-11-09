// import 'package:flutter/material.dart';

// // Models
// class Parent {
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String phone;
//   final int schoolID;

//   Parent({
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.phone,
//     required this.schoolID,
//   });

//   // Factory method to create a Parent from JSON
//   factory Parent.fromJson(Map<String, dynamic> json) {
//     return Parent(
//       email: json['email'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       phone: json['phone'],
//       schoolID: json['schoolID'],
//     );
//   }

//   // Method to convert a Parent to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'email': email,
//       'firstName': firstName,
//       'lastName': lastName,
//       'phone': phone,
//       'schoolID': schoolID,
//     };
//   }
// }

// class Address {
//   final String quarter;
//   final String houseNumber;
//   final String avenue;

//   Address({
//     required this.quarter,
//     required this.houseNumber,
//     required this.avenue,
//   });

//   // Factory method to create an Address from JSON
//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(
//       quarter: json['quarter'],
//       houseNumber: json['houseNumber'],
//       avenue: json['avenue'],
//     );
//   }

//   // Method to convert an Address to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'quarter': quarter,
//       'houseNumber': houseNumber,
//       'avenue': avenue,
//     };
//   }
// }

// class Students {
//   final String name;
//   final String lastName;
//   final String firstName;
//   final String gender;
//   final int classID;
//   final Parent parent;
//   final Address address;

//   Students({
//     required this.name,
//     required this.lastName,
//     required this.firstName,
//     required this.gender,
//     required this.classID,
//     required this.parent,
//     required this.address,
//   });

//   // Factory method to create a Student from JSON
//   factory Students.fromJson(Map<String, dynamic> json) {
//     return Students(
//       name: json['name'],
//       lastName: json['lastName'],
//       firstName: json['firstName'],
//       gender: json['gender'],
//       classID: json['classID'],
//       parent: Parent.fromJson(json['parent']),
//       address: Address.fromJson(json['address']),
//     );
//   }

//   // Method to convert a Student instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'lastName': lastName,
//       'firstName': firstName,
//       'gender': gender,
//       'classID': classID,
//       'parent': parent.toJson(),
//       'address': address.toJson(),
//     };
//   }
// }

// // Student Form Widget
// class StudentForm extends StatefulWidget {
//   final Function(Students) onAdd;

//   const StudentForm({super.key, required this.onAdd});

//   @override
//   _StudentFormState createState() => _StudentFormState();
// }

// class _StudentFormState extends State<StudentForm> {
//   int _currentStep = 0;
//   final _formKey = GlobalKey<FormState>();

//   // Step 1: Student info
//   String firstName = '';
//   String lastName = '';
//   String middleName = '';
//   int classId = 1;
//   String gender = 'Masculin';

//   // Step 2: Parent info
//   String parentFirstName = '';
//   String parentLastName = '';
//   String parentPhone = '';
//   String parentEmail = '';
//   int schoolID = 2;

//   // Step 3: Address info
//   String quarter = '';
//   String houseNumber = '';
//   String avenue = '';

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(20.0),
//         width: double.infinity,
//         constraints: BoxConstraints(
//           maxWidth: 600,
//           maxHeight: MediaQuery.of(context).size.height * 0.8,
//         ),
//         child: Form(
//           key: _formKey,
//           child: Stepper(
//             currentStep: _currentStep,
//             onStepContinue: _currentStep < 2
//                 ? () => setState(() => _currentStep += 1)
//                 : _submitForm,
//             onStepCancel: _currentStep > 0
//                 ? () => setState(() => _currentStep -= 1)
//                 : null,
//             steps: [
//               _buildStudentStep(),
//               _buildParentStep(),
//               _buildAddressStep(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Step _buildStudentStep() {
//     return Step(
//       title: const Text('Student Info'),
//       isActive: _currentStep >= 0,
//       content: Column(
//         children: [
//           _buildTextField('First Name', (value) => firstName = value),
//           _buildTextField('Last Name', (value) => lastName = value),
//           _buildTextField('Middle Name', (value) => middleName = value),
//           _buildTextField('Class', (value) {
//             classId = int.tryParse(value) ?? classId; // Parse to int
//           }),
//           _buildGenderDropdown(),
//         ],
//       ),
//     );
//   }

//   Step _buildParentStep() {
//     return Step(
//       title: const Text('Parent Info'),
//       isActive: _currentStep >= 1,
//       content: Column(
//         children: [
//           _buildTextField(
//               'Parent First Name', (value) => parentFirstName = value),
//           _buildTextField(
//               'Parent Last Name', (value) => parentLastName = value),
//           _buildTextField('Parent Phone', (value) => parentPhone = value,
//               keyboardType: TextInputType.phone),
//           _buildTextField('Parent Email', (value) => parentEmail = value,
//               keyboardType: TextInputType.emailAddress),
//           _buildTextField('School ID', (value) {
//             schoolID = int.tryParse(value) ?? schoolID; // Parse to int
//           }),
//         ],
//       ),
//     );
//   }

//   Step _buildAddressStep() {
//     return Step(
//       title: const Text('Address Info'),
//       isActive: _currentStep >= 2,
//       content: Column(
//         children: [
//           _buildTextField('Quarter', (value) => quarter = value),
//           _buildTextField('House Number', (value) => houseNumber = value),
//           _buildTextField('Avenue', (value) => avenue = value),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(String label, Function(String) onChanged,
//       {TextInputType keyboardType = TextInputType.text}) {
//     return TextFormField(
//       decoration: InputDecoration(labelText: label),
//       onChanged: onChanged,
//       keyboardType: keyboardType,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please fill out this field';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildGenderDropdown() {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(labelText: 'Gender'),
//       value: gender,
//       items: const [
//         DropdownMenuItem(value: 'Masculin', child: Text('Masculin')),
//         DropdownMenuItem(value: 'Féminin', child: Text('Féminin')),
//       ],
//       onChanged: (value) {
//         if (value != null) {
//           setState(() {
//             gender = value;
//           });
//         }
//       },
//     );
//   }

//   void _submitForm() {
//     if (_formKey.currentState?.validate() == true) {
//       // Create the Parent and Address objects
//       Parent parent = Parent(
//         email: parentEmail,
//         firstName: parentFirstName,
//         lastName: parentLastName,
//         phone: parentPhone,
//         schoolID: schoolID,
//       );

//       Address address = Address(
//         quarter: quarter,
//         houseNumber: houseNumber,
//         avenue: avenue,
//       );

//       // Create a new student object
//       Students newStudent = Students(
//         name: firstName,
//         lastName: lastName,
//         firstName: middleName,
//         gender: gender,
//         classID: classId,
//         parent: parent,
//         address: address,
//       );

//       // Add the student using the callback
//       widget.onAdd(newStudent);

//       // Close the dialog or navigate back
//       Navigator.of(context).pop();
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_desktop/features/classrooms/model/class_room.dart';
import 'package:school_desktop/features/classrooms/service/classroom_sercice.dart';
import 'package:school_desktop/utils/constants.dart';

// Models
class Parent {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final int schoolID;

  Parent({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.schoolID,
  });

  // Factory method to create a Parent from JSON
  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      schoolID: json['schoolID'],
    );
  }

  // Method to convert a Parent to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'schoolID': schoolID,
    };
  }
}

class Address {
  final String quarter;
  final String houseNumber;
  final String avenue;

  Address({
    required this.quarter,
    required this.houseNumber,
    required this.avenue,
  });

  // Factory method to create an Address from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      quarter: json['quarter'],
      houseNumber: json['houseNumber'],
      avenue: json['avenue'],
    );
  }

  // Method to convert an Address to JSON
  Map<String, dynamic> toJson() {
    return {
      'quarter': quarter,
      'houseNumber': houseNumber,
      'avenue': avenue,
    };
  }
}

class Students {
  final String name;
  final String lastName;
  final String firstName;
  final String gender;
  final int classID;
  final Parent parent;
  final Address address;

  Students({
    required this.name,
    required this.lastName,
    required this.firstName,
    required this.gender,
    required this.classID,
    required this.parent,
    required this.address,
  });

  // Factory method to create a Student from JSON
  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
      name: json['name'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      gender: json['gender'],
      classID: json['classID'],
      parent: Parent.fromJson(json['parent']),
      address: Address.fromJson(json['address']),
    );
  }

  // Method to convert a Student instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'firstName': firstName,
      'gender': gender,
      'classID': classID,
      'parent': parent.toJson(),
      'address': address.toJson(),
    };
  }
}

// Student Form Widget
class StudentForm extends StatefulWidget {
  final Function(Students) onAdd;

  const StudentForm({super.key, required this.onAdd});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1: Student info
  String firstName = '';
  String lastName = '';
  String middleName = '';
  int? classId;
  String gender = 'Masculin';

  // Step 2: Parent info
  String parentFirstName = '';
  String parentLastName = '';
  String parentPhone = '';
  String parentEmail = '';
  int schoolID = 2;

  // Step 3: Address info
  String quarter = '';
  String houseNumber = '';
  String avenue = '';

  // Services
  final ClassroomService _classroomService = ClassroomService();
  List<Classroom> classrooms = [];

  @override
  void initState() {
    super.initState();
    _loadClassrooms();
  }

  Future<void> _loadClassrooms() async {
    final fetchedClassrooms =
        await _classroomService.fetchClassrooms('$classRoomUrl/1/classrooms');
    if (fetchedClassrooms != null) {
      setState(() {
        classrooms = fetchedClassrooms;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _currentStep < 2
                ? () => setState(() => _currentStep += 1)
                : _submitForm,
            onStepCancel: _currentStep > 0
                ? () => setState(() => _currentStep -= 1)
                : null,
            steps: [
              _buildStudentStep(),
              _buildParentStep(),
              _buildAddressStep(),
            ],
          ),
        ),
      ),
    );
  }

  Step _buildStudentStep() {
    return Step(
      title: const Text('Student Info'),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          _buildTextField('First Name', (value) => firstName = value),
          _buildTextField('Last Name', (value) => lastName = value),
          _buildTextField('Middle Name', (value) => middleName = value),
          _buildClassDropdown(),
          _buildGenderDropdown(),
        ],
      ),
    );
  }

  Step _buildParentStep() {
    return Step(
      title: const Text('Parent Info'),
      isActive: _currentStep >= 1,
      content: Column(
        children: [
          _buildTextField(
              'Parent First Name', (value) => parentFirstName = value),
          _buildTextField(
              'Parent Last Name', (value) => parentLastName = value),
          _buildTextField('Parent Phone', (value) => parentPhone = value,
              keyboardType: TextInputType.phone),
          _buildTextField('Parent Email', (value) => parentEmail = value,
              keyboardType: TextInputType.emailAddress),
          _buildTextField('School ID', (value) {
            schoolID = int.tryParse(value) ?? schoolID; // Parse to int
          }),
        ],
      ),
    );
  }

  Step _buildAddressStep() {
    return Step(
      title: const Text('Address Info'),
      isActive: _currentStep >= 2,
      content: Column(
        children: [
          _buildTextField('Quarter', (value) => quarter = value),
          _buildTextField('House Number', (value) => houseNumber = value),
          _buildTextField('Avenue', (value) => avenue = value),
        ],
      ),
    );
  }

  Widget _buildClassDropdown() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: 'Class'),
      value: classId,
      items: classrooms.map((classroom) {
        return DropdownMenuItem<int>(
          value: classroom.classRoomID,
          child: Text(
              '${classroom.level} ${classroom.letter} ${utf8.decode(classroom.optionName.runes.toList())}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          classId = value;
        });
      },
      validator: (value) => value == null ? 'Please select a classroom' : null,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Gender'),
      value: gender,
      items: const [
        DropdownMenuItem(value: 'Masculin', child: Text('Masculin')),
        DropdownMenuItem(value: 'Féminin', child: Text('Féminin')),
      ],
      onChanged: (value) {
        setState(() {
          gender = value!;
        });
      },
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill out this field';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      // Create the Parent and Address objects
      Parent parent = Parent(
        email: parentEmail,
        firstName: parentFirstName,
        lastName: parentLastName,
        phone: parentPhone,
        schoolID: schoolID,
      );

      Address address = Address(
        quarter: quarter,
        houseNumber: houseNumber,
        avenue: avenue,
      );

      // Create a new student object
      Students newStudent = Students(
        name: firstName,
        lastName: lastName,
        firstName: middleName,
        gender: gender,
        classID: classId!,
        parent: parent,
        address: address,
      );

      // Add the student using the callback
      widget.onAdd(newStudent);

      // Close the dialog or navigate back
      Navigator.of(context).pop();
    }
  }
}

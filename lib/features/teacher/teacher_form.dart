import 'package:flutter/material.dart';

class Teacher {
  final int id;
  final String name; // Combined name
  final String className;
  final String option; // Placeholder for potential future options
  final String gender; // Field for gender
  final String parent; // Parent information
  final String address; // Address information

  Teacher(this.id, this.name, this.className, this.option, this.gender, this.parent, this.address);
}

class TeacherForm extends StatefulWidget {
  final Function(Teacher) onAdd; // Callback function for adding a Teacher

  const TeacherForm({super.key, required this.onAdd});

  @override
  _TeacherFormState createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  int _currentStep = 0;

  // Step 1: Teacher info
  String firstName = '';
  String lastName = '';
  String middleName = '';
  String className = '';
  String gender = 'Masculin'; // Default gender

  // Step 2: Parent info
  String parentFirstName = '';
  String parentLastName = '';
  String parentPhone = '';
  String parentEmail = '';

  // Step 3: Address info
  String quartier = '';
  String avenue = '';
  String commune = '';
  String numero = '';

  // Controllers to validate input
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 600, // Set max width for larger screens
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _currentStep < 2
                ? () => setState(() => _currentStep += 1)
                : _submitForm, // Continue to the next step or submit the form
            onStepCancel: _currentStep > 0
                ? () => setState(() => _currentStep -= 1)
                : null, // Go back to the previous step
            steps: [
              _buildTeacherStep(),
              _buildParentStep(),
              _buildAddressStep(),
            ],
          ),
        ),
      ),
    );
  }

  // Step 1: Teacher info
  Step _buildTeacherStep() {
    return Step(
      title: const Text('Teacher Info'),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          _buildTextField('Prénom', (value) => firstName = value),
          _buildTextField('Nom', (value) => lastName = value),
          _buildTextField('Post Nom', (value) => middleName = value),
          _buildTextField('Classe', (value) => className = value),
          _buildGenderDropdown(),
        ],
      ),
    );
  }

  // Step 2: Parent info
  Step _buildParentStep() {
    return Step(
      title: const Text('Parent Info'),
      isActive: _currentStep >= 1,
      content: Column(
        children: [
          _buildTextField('Nom du parent', (value) => parentFirstName = value),
          _buildTextField('Post nom du parent', (value) => parentLastName = value),
          _buildTextField('Téléphone', (value) => parentPhone = value, keyboardType: TextInputType.phone),
          _buildTextField('Email', (value) => parentEmail = value, keyboardType: TextInputType.emailAddress),
        ],
      ),
    );
  }

  // Step 3: Address info
  Step _buildAddressStep() {
    return Step(
      title: const Text('Address Info'),
      isActive: _currentStep >= 2,
      content: Column(
        children: [
          _buildTextField('Quartier', (value) => quartier = value),
          _buildTextField('Avenue', (value) => avenue = value),
          _buildTextField('Commune', (value) => commune = value),
          _buildTextField('Numéro', (value) => numero = value),
        ],
      ),
    );
  }

  // Text field builder with optional keyboard type
  Widget _buildTextField(String label, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
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

  // Gender dropdown builder
  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Genre'),
      value: gender,
      items: [
        const DropdownMenuItem(value: 'Masculin', child: Text('Masculin')),
        const DropdownMenuItem(value: 'Féminin', child: Text('Féminin')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            gender = value;
          });
        }
      },
    );
  }

  // Submit form and add Teacher
  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      int id = DateTime.now().millisecondsSinceEpoch; // Generate a unique ID
      String fullName = '$firstName $middleName $lastName'; // Combine names
      String parentInfo = '$parentFirstName $parentLastName, $parentPhone, $parentEmail'; // Combine parent info
      String addressInfo = '$quartier, $avenue, $commune, $numero'; // Combine address info

      // Create a new Teacher object
      Teacher newTeacher = Teacher(id, fullName, className, 'Unknown', gender, parentInfo, addressInfo);

      // Add the Teacher using the callback
      widget.onAdd(newTeacher);

      // Close the dialog or navigate back
      Navigator.of(context).pop();
    }
  }
}

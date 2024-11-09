class StudentInfo {
  final int idEnroll;
  final int studentID;
  final DateTime dateEnrolled;
  final String name;
  final String gender;
  final String parentEmail;

  StudentInfo({
    required this.idEnroll,
    required this.studentID,
    required this.dateEnrolled,
    required this.name,
    required this.gender,
    required this.parentEmail,
  });

  // Factory method to create an Enrollment from JSON
  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      idEnroll: json['idEnroll'],
      studentID: json['studentID'],
      dateEnrolled: DateTime.parse(json['dateEnrolled']),
      name: json['name'],
      gender: json['gender'],
      parentEmail: json['parentEmail'],
    );
  }

  // Method to convert an Enrollment instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'idEnroll': idEnroll,
      'studentID': studentID,
      'dateEnrolled': dateEnrolled.toIso8601String(),
      'name': name,
      'gender': gender,
      'parentEmail': parentEmail,
    };
  }
}

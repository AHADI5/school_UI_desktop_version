class Parent {

  final String name;
  final String lastName;
  final String email;
  final String phone;
  final List<Student> students;

  Parent({

    required this.name,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.students,
  });

  // Factory constructor for creating a new Parent instance from JSON
  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(

      name: json['name'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      students: (json['students'] as List<dynamic>)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList(),
    );
  }

  // Method to convert a Parent instance to JSON
  Map<String, dynamic> toJson() {
    return {

      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'students': students.map((student) => student.toJson()).toList(),
    };
  }
}

class Student {
  final String name;
  final String lastName;
  final int studentID;
  final String classRoomName;

  Student({
    required this.name,
    required this.lastName,
    required this.studentID,
    required this.classRoomName,
  });

  // Factory constructor for creating a new Student instance from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      studentID: json['studentID'] as int,
      classRoomName: json['classRoomName'] as String,
    );
  }

  // Method to convert a Student instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'studentID': studentID,
      'classRoomName': classRoomName,
    };
  }
}

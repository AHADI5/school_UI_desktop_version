class Classroom {
  final int classRoomID;
  final int level;
  final String letter;
  final int studentNumber;
  final int courseNumber;
  final String optionName;
  final String teacherName;

  Classroom({
    required this.classRoomID,
    required this.level,
    required this.letter,
    required this.studentNumber,
    required this.courseNumber,
    required this.optionName,
    required this.teacherName,
  });

  // Factory method to create a Classroom from JSON
  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      classRoomID: json['classRoomID'],
      level: json['level'],
      letter: json['letter'],
      studentNumber: json['studentNumber'],
      courseNumber: json['courseNumber'],
      optionName: json['optionName'],
      teacherName: json['teacherName'],
    );
  }

  // Method to convert a Classroom instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'classRoomID': classRoomID,
      'level': level,
      'letter': letter,
      'studentNumber': studentNumber,
      'courseNumber': courseNumber,
      'optionName': optionName,
      'teacherName': teacherName,
    };
  }
}

class Discipline {
  final int disciplineID;
  final String owner;
  final List<AttendanceResponse> attendanceResponses;
  final List<Incident> incidents;

  Discipline(
      {required this.disciplineID,
      required this.owner,
      required this.attendanceResponses,
      required this.incidents,
    });

  factory Discipline.fromJson(Map<String, dynamic> json) {
    return Discipline(
      disciplineID: json['disciplineID'],
      owner: json['owner'],
      attendanceResponses: (json['attendanceResponses'] as List)
          .map((item) => AttendanceResponse.fromJson(item))
          .toList(),
      incidents: (json['incidents'] as List)
          .map((item) => Incident.fromJson(item))
          .toList(),
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disciplineID': disciplineID,
      'owner': owner,
      'attendanceResponses':
          attendanceResponses.map((e) => e.toJson()).toList(),
      'incidents': incidents.map((e) => e.toJson()).toList(),
    };
  }
}

class AttendanceResponse {
  final String attendanceDate;
  final int studentID;
  final String disciplineOwner;
  final bool isPresent;
  final String attendanceStatus;

  AttendanceResponse({
    required this.attendanceDate,
    required this.studentID,
    required this.disciplineOwner,
    required this.isPresent,
    required this.attendanceStatus,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      attendanceDate: json['attendanceDate'],
      studentID: json['studentID'],
      disciplineOwner: json['disciplineOwner'],
      isPresent: json['isPresent'],
      attendanceStatus: json['attendanceStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceDate': attendanceDate,
      'studentID': studentID,
      'disciplineOwner': disciplineOwner,
      'isPresent': isPresent,
      'attendanceStatus': attendanceStatus,
    };
  }
}

class Incident {
  final String title;
  final String description;
  final String date;
  final String disciplineDecision;
  final String rule;
  final String sanctionType;
  final int occurrenceNumber;

  Incident({
    required this.title,
    required this.description,
    required this.date,
    required this.disciplineDecision,
    required this.rule,
    required this.sanctionType,
    required this.occurrenceNumber
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      title: json['title'],
      description: json['Description'],
      date: json['date'],
      disciplineDecision: json['disciplineDecision'],
      rule: json['rule'],
      sanctionType: json['sanctionType'], occurrenceNumber: json['occurrenceNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'disciplineDecision': disciplineDecision,
      'rule': rule,
      'sanctionType': sanctionType,
      'occurrenceNumber' : occurrenceNumber
    };
  }
}

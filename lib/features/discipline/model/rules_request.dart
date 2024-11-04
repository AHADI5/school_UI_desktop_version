class RuleRequest {
  String title;
  int schoolID;
  String content;
  List<Violation> violation;

  RuleRequest({
    required this.title,
    required this.schoolID,
    required this.content,
    required this.violation,
  });

  // Factory constructor for creating a new RuleRequest instance from a JSON map.
  factory RuleRequest.fromJson(Map<String, dynamic> json) {
    return RuleRequest(
      title: json['title'] ?? '',
      schoolID: json['schoolID'] ?? 0,
      content: json['content'] ?? '',
      violation: (json['violationType'] as List<dynamic>)
          .map((violation) => Violation.fromJson(violation))
          .toList(),
    );
  }

  // Method to convert RuleRequest instance to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'schoolID': schoolID,
      'content': content,
      'violation': violation.map((violation) => violation.toJson()).toList(),
    };
  }
}

class Violation {
  String description;
  int occurrenceNumber;
  String sanctionPredefinedType;
  String sanctionType;
  String title;

  Violation({
    required this.description,
    required this.occurrenceNumber,
    required this.sanctionPredefinedType,
    required this.sanctionType,
    required this.title,
  });

  // Factory constructor for creating a new violation instance from a JSON map.
  factory Violation.fromJson(Map<String, dynamic> json) {
    return Violation(
      description: json['description'] ?? '',
      occurrenceNumber: json['occurrenceNumber'] ?? 0,
      sanctionPredefinedType: json['sanctionPredefinedType'] ?? '',
      sanctionType: json['sanctionType'] ?? '',
      title: json['title'] ?? '',
    );
  }

  // Method to convert violation instance to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'occurrenceNumber': occurrenceNumber,
      'sanctionPredefinedType': sanctionPredefinedType,
      'sanctionType': sanctionType,
      'title': title,
    };
  }
}

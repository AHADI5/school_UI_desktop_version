class Rule {
  final int ruleID;
  final String title;
  final String content;
  final List<ViolationType> violationType;

  Rule({
    required this.ruleID,
    required this.title,
    required this.content,
    required this.violationType,
  });

  // Factory constructor to create a Rule instance from JSON
  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      ruleID: json['ruleID'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      violationType: (json['violationType'] as List<dynamic>)
          .map((violation) => ViolationType.fromJson(violation))
          .toList(),
    );
  }

  // Method to convert a Rule instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ruleID': ruleID,
      'title': title,
      'content': content,
      'violationType': violationType.map((violation) => violation.toJson()).toList(),
    };
  }
}

class ViolationType {
  final int occurrenceNumber;
  final String sanctionType;

  ViolationType({
    required this.occurrenceNumber,
    required this.sanctionType,
  });

  // Factory constructor to create a ViolationType instance from JSON
  factory ViolationType.fromJson(Map<String, dynamic> json) {
    return ViolationType(
      occurrenceNumber: json['occurrenceNumber'] as int,
      sanctionType: json['sanctionType'] as String,
    );
  }

  // Method to convert a ViolationType instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'occurrenceNumber': occurrenceNumber,
      'sanctionType': sanctionType,
    };
  }
}

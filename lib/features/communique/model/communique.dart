class CommuniqueModel {
  int communiqueID;
  String title;
  String content;
  DateTime publishedDate;
  String recipientType;
  List<String> recipients;

  CommuniqueModel({
    required this.communiqueID,
    required this.title,
    required this.content,
    required this.publishedDate,
    required this.recipientType,
    required this.recipients,
  });

  // Factory method to create a CommuniqueModel from JSON
  factory CommuniqueModel.fromJson(Map<String, dynamic> json) {
    return CommuniqueModel(
      communiqueID: json['communiqueID'],
      title: json['title'],
      content: json['content'],
      publishedDate: DateTime.parse(json['publishedDate']),
      recipientType: json['recipientType'],
      recipients: List<String>.from(json['recipients']),
    );
  }

  // Method to convert a CommuniqueModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'communiqueID': communiqueID,
      'title': title,
      'content': content,
      'publishedDate': publishedDate.toIso8601String(),
      'recipientType': recipientType,
      'recipients': recipients,
    };
  }
}

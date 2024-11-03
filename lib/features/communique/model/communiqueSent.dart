class Message {
  final String title;
  final String content;
  final String recipientType ;
  final String recipientGroupName;
  final List<dynamic> recipientIDs;

  Message({
    required this.title,
    required this.content,
    required this.recipientType,
    required this.recipientGroupName,
    required this.recipientIDs,
  });

  // Factory constructor to create an instance from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      title: json['title'] as String,
      content: json['content'] as String,
      recipientType: json['recipientType'] as String,
      recipientGroupName: json['recipientGroupName'] as String,
      recipientIDs: List<dynamic>.from(json['recipientIDs'] ?? []),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'recipientType': recipientType,
      'recipientGroupName': recipientGroupName,
      'recipientIDs': recipientIDs,
    };
  }
}

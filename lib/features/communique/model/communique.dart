class CommuniqueReviewRegisterResponse {
  final String? recipient;
  final DateTime? date;
  final bool? status;

  CommuniqueReviewRegisterResponse({
    this.recipient,
    this.date,
    this.status,
  });

  // Factory constructor to create an instance from JSON
  factory CommuniqueReviewRegisterResponse.fromJson(Map<String, dynamic> json) {
    return CommuniqueReviewRegisterResponse(
      recipient: json['recipient'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      status: json['status'] as bool?,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'date': date?.toIso8601String(),
      'status': status,
    };
  }
}

class CommuniqueResponse {
  final String? title;
  final String? content;
  final DateTime? publishedDate;
  final int? communiqueID;
  final List<CommuniqueReviewRegisterResponse>? reviewRegisterResponses;

  CommuniqueResponse({
    this.title,
    this.content,
    this.publishedDate,
    this.communiqueID,
    this.reviewRegisterResponses,
  });

  // Factory constructor to create an instance from JSON
  factory CommuniqueResponse.fromJson(Map<String, dynamic> json) {
    return CommuniqueResponse(
      title: json['title'] as String?,
      content: json['content'] as String?,
      publishedDate: json['publishedDate'] != null
          ? DateTime.parse(json['publishedDate'])
          : null,
      communiqueID: json['communiqueID'] as int?,
      reviewRegisterResponses: (json['reviewRegisterResponses'] as List?)
          ?.map((item) => CommuniqueReviewRegisterResponse.fromJson(item))
          .toList(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'publishedDate': publishedDate?.toIso8601String(),
      'communiqueID': communiqueID,
      'reviewRegisterResponses':
          reviewRegisterResponses?.map((response) => response.toJson()).toList(),
    };
  }
}

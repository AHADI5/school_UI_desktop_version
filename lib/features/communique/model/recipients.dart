class Section {
  int sectionID; // Updated to int
  String sectionName;
  List<ParentPerLevel> parentPerLevelList;

  Section({
    required this.sectionID,  // Updated constructor
    required this.sectionName,
    required this.parentPerLevelList,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      sectionID: json['sectionID'],  // Updated to int
      sectionName: json['sectionName'],
      parentPerLevelList: (json['parentPerLevelList'] as List)
          .map((i) => ParentPerLevel.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionID': sectionID,  // Updated to int
      'sectionName': sectionName,
      'parentPerLevelList':
          parentPerLevelList.map((i) => i.toJson()).toList(),
    };
  }
}

class ParentPerLevel {
  int level;
  List<ParentPerClassRoom> parentPerClassRoomList;

  ParentPerLevel({
    required this.level,
    required this.parentPerClassRoomList,
  });

  factory ParentPerLevel.fromJson(Map<String, dynamic> json) {
    return ParentPerLevel(
      level: json['level'],
      parentPerClassRoomList: (json['paretPerClassRoomList'] as List)
          .map((i) => ParentPerClassRoom.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'paretPerClassRoomList':
          parentPerClassRoomList.map((i) => i.toJson()).toList(),
    };
  }
}

class ParentPerClassRoom {
  int classRoomID;  // Updated to int
  String classRoomName;
  List<String> parentEmails;

  ParentPerClassRoom({
    required this.classRoomID,  // Updated constructor
    required this.classRoomName,
    required this.parentEmails,
  });

  factory ParentPerClassRoom.fromJson(Map<String, dynamic> json) {
    return ParentPerClassRoom(
      classRoomID: json['classRoomID'],  // Updated to int
      classRoomName: json['classRoomName'],
      parentEmails: List<String>.from(json['parentEmails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classRoomID': classRoomID,  // Updated to int
      'classRoomName': classRoomName,
      'parentEmails': parentEmails,
    };
  }
}

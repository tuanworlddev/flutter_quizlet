class HistoryModel {
  final String courseId;
  final DateTime viewedAt;
  final String userId;

  HistoryModel({
    required this.courseId,
    required this.viewedAt,
    required this.userId,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      courseId: map['courseId'],
      viewedAt: DateTime.parse(map['viewedAt']),
      userId: map['userId']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'viewedAt': viewedAt.toIso8601String(),
      'userId': userId
    };
  }
}

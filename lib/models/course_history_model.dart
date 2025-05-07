class CourseHistoryModel {
  final String courseId;
  final DateTime viewedAt;

  CourseHistoryModel({
    required this.courseId,
    required this.viewedAt,
  });

  factory CourseHistoryModel.fromMap(Map<String, dynamic> map) {
    return CourseHistoryModel(
      courseId: map['courseId'],
      viewedAt: DateTime.parse(map['viewedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'viewedAt': viewedAt.toIso8601String(),
    };
  }
}

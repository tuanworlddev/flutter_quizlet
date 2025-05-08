class TestResultModel {
  final String id;
  final String userId;
  final String testId;
  final Map<int, String?> answers;
  final double score;
  final DateTime completedAt;

  TestResultModel({
    required this.id,
    required this.userId,
    required this.testId,
    required this.answers,
    required this.score,
    required this.completedAt,
  });

  factory TestResultModel.fromMap(Map<String, dynamic> map) {
    return TestResultModel(
      id: map['id'],
      userId: map['userId'],
      testId: map['testId'],
      answers: (map['answers'] as Map<String, dynamic>).map((k, v) => MapEntry(int.parse(k), v as String?)),
      score: map['score'],
      completedAt: DateTime.parse(map['completedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'testId': testId,
      'answers': answers.map((k, v) => MapEntry(k.toString(), v)),
      'score': score,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
import 'package:flutter_quizlet/models/question_model.dart';

class TestModel {
  final String id;
  final String courseId;
  final String title;
  final List<QuestionModel> questions;
  final DateTime createdAt;

  TestModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.questions,
    required this.createdAt,
  });

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'],
      courseId: map['courseId'],
      title: map['title'],
      questions: (map['questions'] as List)
          .map((q) => QuestionModel.fromMap(q))
          .toList(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
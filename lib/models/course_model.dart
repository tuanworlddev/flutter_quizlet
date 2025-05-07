import 'package:flutter_quizlet/models/flashcard_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String category;
  final DateTime createdAt;
  final String? description;
  final List<FlashcardModel>? flashcards;

  CourseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    this.description,
    this.flashcards,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
      description: map['description'],
      flashcards: map['flashcards'] != null
          ? List<FlashcardModel>.from(
              map['flashcards'].map((x) => FlashcardModel.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'flashcards': flashcards?.map((e) => e.toMap()).toList(),
    };
  }
}

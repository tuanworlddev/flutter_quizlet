import 'package:flutter_quizlet/models/flashcard_model.dart';

class CourseModel {
  final String id;
  final String userId;
  final String title;
  final String category;
  final String description;
  final List<FlashcardModel> flashcards;
  final DateTime createdAt;

  const CourseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.description,
    required this.createdAt,
    required this.flashcards,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      category: map['category'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      flashcards: List<FlashcardModel>.from(
        map['flashcards'].map((x) => FlashcardModel.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'flashcards': flashcards.map((e) => e.toMap()).toList(),
    };
  }

  CourseModel copyWith({
    String? userId,
    String? title,
    String? category,
    String? description,
    DateTime? createdAt,
    List<FlashcardModel>? flashcards,
  }) {
    return CourseModel(
      id: id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      flashcards: flashcards ?? this.flashcards,
    );
  }
}

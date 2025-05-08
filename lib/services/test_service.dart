import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/models/test_model.dart';
import 'package:flutter_quizlet/models/question_model.dart';

class TestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TestModel> generateTestForCourse(CourseModel course, {int questionCount = 10}) async {
    try {
      final flashcards = course.flashcards;
      if (flashcards.isEmpty) {
        throw Exception('No flashcards available to generate test');
      }

      final random = Random();
      final selectedFlashcards = (flashcards..shuffle(random))
          .take(min(questionCount, flashcards.length))
          .toList();

      final questions = selectedFlashcards.map((flashcard) {
        final correctAnswer = flashcard.back;
        final otherFlashcards = flashcards
            .where((f) => f.id != flashcard.id)
            .toList()
          ..shuffle(random);
        final wrongAnswers = otherFlashcards
            .take(3)
            .map((f) => f.back)
            .toList();
        final options = [correctAnswer, ...wrongAnswers]..shuffle(random);

        return QuestionModel(
          question: flashcard.front,
          correctAnswer: correctAnswer,
          options: options,
        );
      }).toList();

      final test = TestModel(
        id: '${course.id}_${DateTime.now().millisecondsSinceEpoch}',
        courseId: course.id,
        title: 'Test for ${course.title}',
        questions: questions,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('tests').doc(test.id).set(test.toMap());

      return test;
    } catch (e) {
      throw Exception('Failed to generate test: $e');
    }
  }
}
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/models/flashcard_model.dart';
import 'package:flutter_quizlet/services/auth_service.dart';
import 'package:flutter_quizlet/services/course_service.dart';
import 'package:flutter_quizlet/services/upload_service.dart';

class EditCourseProvider with ChangeNotifier {
  final _courseService = CourseService();
  final _uploadService = UploadService();
  final _authService = AuthService();
  late CourseModel _course;

  CourseModel get course => _course;

  void setCourse(CourseModel course) {
    _course = course;
  }

  void addFlashCard(FlashcardModel flashcard) {
    _course.flashcards.add(flashcard);
    notifyListeners();
  }

  void changeCourse(CourseModel course) {
    _course = course;
    notifyListeners();
  }

  void changeFlashcard(int index, FlashcardModel flashcard) {
    _course.flashcards[index] = flashcard;
    notifyListeners();
  }

  void removeFlashcard(int index) {
    _course.flashcards.removeAt(index);
    for (int i = 0; i < _course.flashcards.length; i++) {
      _course.flashcards[i] = FlashcardModel(
        id: _course.flashcards[i].id,
        front: _course.flashcards[i].front,
        back: _course.flashcards[i].back,
        imageUrl: _course.flashcards[i].imageUrl,
        audioUrl: _course.flashcards[i].audioUrl,
        order: i,
      );
    }
    notifyListeners();
  }

  void reorderFlashcards(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final flastcard = _course.flashcards.removeAt(oldIndex);
    _course.flashcards.insert(newIndex, flastcard);
    for (int i = 0; i < _course.flashcards.length; i++) {
      _course.flashcards[i] = FlashcardModel(
        id: _course.flashcards[i].id,
        front: _course.flashcards[i].front,
        back: _course.flashcards[i].back,
        imageUrl: _course.flashcards[i].imageUrl,
        audioUrl: _course.flashcards[i].audioUrl,
        order: i,
      );
    }
    notifyListeners();
  }

  Future<void> _uploadFiles() async {
    for (int i = 0; i < _course.flashcards.length; i++) {
      String? imageUrl = _course.flashcards[i].imageUrl;
      String? audioUrl = _course.flashcards[i].audioUrl;

      if (imageUrl != null) {
        imageUrl = await _uploadService.uploadImage(File(imageUrl));
      }

      if (audioUrl != null) {
        audioUrl = await _uploadService.uploadAudio(File(audioUrl));
      }

      // Update flashcard with URLs
      _course.flashcards[i] = FlashcardModel(
        id: _course.flashcards[i].id,
        front: _course.flashcards[i].front,
        back: _course.flashcards[i].back,
        imageUrl: imageUrl,
        audioUrl: audioUrl,
        order: _course.flashcards[i].order,
      );
    }
    notifyListeners();
  }

  Future<void> updateCourse() async {
    try {
      final User? currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      await _courseService.createCourse(_course);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

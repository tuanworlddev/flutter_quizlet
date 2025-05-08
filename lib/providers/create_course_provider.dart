import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/models/flashcard_model.dart';
import 'package:flutter_quizlet/services/auth_service.dart';
import 'package:flutter_quizlet/services/course_service.dart';
import 'package:flutter_quizlet/services/upload_service.dart';

class CreateCourseProvider with ChangeNotifier {
  final _courseService = CourseService();
  final _uploadService = UploadService();
  final _authService = AuthService();
  final List<FlashcardModel> _flashcards = [];

  List<FlashcardModel> get flashcards => _flashcards;

  void addFlashCard(FlashcardModel flashcard) {
    _flashcards.add(flashcard);
    notifyListeners();
  }

  void changeFlashcard(int index, FlashcardModel flashcard) {
    _flashcards[index] = flashcard;
    notifyListeners();
  }

  void removeFlashcard(int index) {
    _flashcards.removeAt(index);
    for (int i = 0; i < _flashcards.length; i++) {
      _flashcards[i] = FlashcardModel(
        id: _flashcards[i].id,
        front: _flashcards[i].front,
        back: _flashcards[i].back,
        imageUrl: _flashcards[i].imageUrl,
        audioUrl: _flashcards[i].audioUrl,
        order: i,
      );
    }
    notifyListeners();
  }

  void reorderFlashcards(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final flastcard = _flashcards.removeAt(oldIndex);
    _flashcards.insert(newIndex, flastcard);
    for (int i = 0; i < _flashcards.length; i++) {
      _flashcards[i] = FlashcardModel(
        id: _flashcards[i].id,
        front: _flashcards[i].front,
        back: _flashcards[i].back,
        imageUrl: _flashcards[i].imageUrl,
        audioUrl: _flashcards[i].audioUrl,
        order: i,
      );
    }
    notifyListeners();
  }

  Future<void> _uploadFiles() async {
    for (int i = 0; i < _flashcards.length; i++) {
      String? imageUrl = _flashcards[i].imageUrl;
      String? audioUrl = _flashcards[i].audioUrl;

      if (imageUrl != null) {
        imageUrl = await _uploadService.uploadImage(File(imageUrl));
      }

      if (audioUrl != null) {
        audioUrl = await _uploadService.uploadAudio(File(audioUrl));
      }

      // Update flashcard with URLs
      _flashcards[i] = FlashcardModel(
        id: _flashcards[i].id,
        front: _flashcards[i].front,
        back: _flashcards[i].back,
        imageUrl: imageUrl,
        audioUrl: audioUrl,
        order: _flashcards[i].order,
      );
    }
    notifyListeners();
  }

  Future<void> createCourse(
    String id,
    String title,
    String category,
    String description,
  ) async {
    try {
      final User? currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      await _uploadFiles();

      CourseModel course = CourseModel(
        id: id,
        userId: currentUser.uid,
        title: title,
        category: category,
        description: description,
        createdAt: DateTime.now(),
        flashcards: _flashcards,
      );

      await _courseService.createCourse(course);

      _flashcards.clear();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

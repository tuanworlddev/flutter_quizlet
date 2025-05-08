import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/services/auth_service.dart';
import 'package:flutter_quizlet/services/course_service.dart';

class YourLibraryProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();
  final AuthService _authService = AuthService();
  List<CourseModel> _courses = [];

  List<CourseModel> get courses => _courses;

  void feachYourCourse() async {
    final User? cureentUser = await _authService.getCurrentUser();
    if (cureentUser != null) {
      _courseService.streamCourseByUser(cureentUser.uid).listen((courses) {
        _courses = courses;
        notifyListeners();
      });
    }
  }
}
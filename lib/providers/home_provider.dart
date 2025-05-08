import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/services/course_service.dart';

class HomeProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();
  List<CourseModel> _courses = [];

  List<CourseModel> get courses => _courses;

  void streamCourses() {
    _courseService.streamAllCourses().listen((courses) {
      _courses = courses;
      notifyListeners();
    });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/services/course_service.dart';

class CourseProvider with ChangeNotifier {
  final _courseService = CourseService();

  Future<CourseModel?> getCourseById(String courseId) async {
    try {
      return _courseService.getCourseById(courseId);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
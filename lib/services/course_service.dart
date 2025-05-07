import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quizlet/models/course_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCourse(CourseModel course) async {
    try {
      await _firestore.collection('courses').doc(course.id).set(course.toMap());
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }
}
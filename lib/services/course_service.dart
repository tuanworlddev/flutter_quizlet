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

  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('courses').doc(courseId).delete();
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }

  Future<CourseModel?> getCourseById(String courseId) async {
    try {
      final ref = await _firestore.collection("courses").doc(courseId).get();
      if (ref.exists) {
        return CourseModel.fromMap(ref.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error get course by id: $e');      
    }
  }

  Stream<List<CourseModel>> streamCourseByUser(String userId) {
    return _firestore
        .collection('courses')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => CourseModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Stream<List<CourseModel>> streamAllCourses() {
    return _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => CourseModel.fromMap(doc.data()))
                  .toList(),
        );
  }
}

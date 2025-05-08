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

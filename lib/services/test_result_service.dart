import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quizlet/models/test_result_model.dart';

class TestResultService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTestResult(TestResultModel result) async {
    try {
      await _firestore.collection('test_results').doc(result.id).set(result.toMap());
    } catch (e) {
      throw Exception('Failed to save test result: $e');
    }
  }

  Stream<List<TestResultModel>> streamTestResultsByUser(String userId) {
    return _firestore
        .collection('test_results')
        .where('userId', isEqualTo: userId)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TestResultModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}
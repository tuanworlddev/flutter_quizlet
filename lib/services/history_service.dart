import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quizlet/models/history_model.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateHistory(HistoryModel history) async {
    try {
      final docId = '${history.userId}_${history.courseId}';

      await _firestore
          .collection("histories")
          .doc(docId)
          .set(history.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error creating or updating history: $e');
    }
  }

  Stream<List<HistoryModel>> streamHistoriesByUser(String userId) {
    return _firestore
        .collection("histories")
        .where('userId', isEqualTo: userId)
        .orderBy('viewedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => HistoryModel.fromMap(doc.data()))
                  .toList(),
        );
  }
}

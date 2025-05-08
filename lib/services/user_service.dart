import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quizlet/models/custom_user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(CustomUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception('Error create user: $e');
    }
  }

  Future<CustomUser?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return CustomUser.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error get user: $e');
    }
  }
}

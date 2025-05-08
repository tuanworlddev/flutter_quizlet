import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/history_model.dart';
import 'package:flutter_quizlet/services/auth_service.dart';
import 'package:flutter_quizlet/services/history_service.dart';

class HistoryProvider with ChangeNotifier {
  final _authService = AuthService();
  final _historyService = HistoryService();
  List<HistoryModel> _histories = [];
  List<HistoryModel> get histories => _histories;

  Future<void> createHistory(String courseId) async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        await _historyService.createOrUpdateHistory(
          HistoryModel(
            courseId: courseId,
            viewedAt: DateTime.now(),
            userId: currentUser.uid,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void streamHistories() async {
    final currentUser = await _authService.getCurrentUser();
    if (currentUser != null) {
      _historyService.streamHistoriesByUser(currentUser.uid).listen((
        histories,
      ) {
        _histories = histories;
        notifyListeners();
      });
    }
  }
}

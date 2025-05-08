import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/custom_user.dart';
import 'package:flutter_quizlet/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  Future<CustomUser?> getUserById(String uid) async {
    try {
      return await _userService.getUserById(uid);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  Future<void> init() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword({ required String email, required String password }) async {
    final User? user = await _authService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    final User? user = await _authService.signIntWithGoogle();
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail({ required String email, required String password, required String displayName, required File photo }) async {
    final User? user = await _authService.signUpWithEmail(email: email, password: password, displayName: displayName, photo: photo);
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
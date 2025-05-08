import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quizlet/models/custom_user.dart';
import 'package:flutter_quizlet/services/upload_service.dart';
import 'package:flutter_quizlet/services/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final UserService userService = UserService();
  final UploadService uploadService = UploadService();

  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Error sign in with email and password: $e');
      return null;
    }
  }

  Future<User?> signIntWithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
      if (googleAccount == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await firebaseAuth
          .signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        userService.createUser(
          CustomUser(
            uid: user.uid,
            displayName: user.displayName!,
            email: user.email!,
            photoURL: user.photoURL,
          ),
        );
      }
      return user;
    } catch (e) {
      print('Error sign with google: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required File photo,
  }) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(displayName);
      final String? photoUrl = await uploadService.uploadImage(photo);
      if (photoUrl != null) {
        await userCredential.user?.updatePhotoURL(photoUrl);
      }
      await userCredential.user?.reload();
      final user = firebaseAuth.currentUser;
      if (user != null) {
        userService.createUser(
          CustomUser(
            uid: user.uid,
            displayName: user.displayName!,
            email: user.email!,
            photoURL: user.photoURL,
          ),
        );
      }
      return user;
    } catch (e) {
      print('Error sign up: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }
}

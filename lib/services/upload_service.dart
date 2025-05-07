import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  
  Future<String?> uploadImage(File file) async {
    try {
      final ref = firebaseStorage.ref().child('images/${DateTime.now().toString()}');
      await ref.putFile(file);
      return ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error upload image: $e');
    }
  }

  Future<String?> uploadAudio(File file) async {
    try {
      final ref = firebaseStorage.ref().child('audios/${DateTime.now().toString()}');
      await ref.putFile(file);
      return ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error upload audio: $e');
    }
  }
}
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  
  Future<String?> uploadFile(File file) async {
    try {
      final ref = firebaseStorage.ref().child('images/${DateTime.now().toString()}');
      await ref.putFile(file);
      return ref.getDownloadURL();
    } catch (e) {
      print('Error upload file: $e');
      return null;
    }
  }
}
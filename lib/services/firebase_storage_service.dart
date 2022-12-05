import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<String> uploadAbsensiImage(String filePath, String fileName) async {
    final now = DateTime.now();
    final audioReff = FirebaseStorage.instance
        .ref()
        .child('absensi/${now.year}${now.month}${now.day}/$fileName');
    await audioReff.putFile(File(filePath));
    return audioReff.getDownloadURL();
  }

  Future<String> uploadFile(String filePath, String cloudStoragePath) async {
    final fileReff = FirebaseStorage.instance.ref().child(cloudStoragePath);
    await fileReff.putFile(File(filePath));
    return fileReff.getDownloadURL();
  }
}

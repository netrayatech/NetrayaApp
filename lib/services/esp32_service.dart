import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netraya/models/esp32.dart';

class ESP32Service {
  final String _uid;
  ESP32Service() : _uid = FirebaseAuth.instance.currentUser!.uid;
  final _esp32Reff = FirebaseFirestore.instance.collection('esp32');

  Future<List<ESP32>> getListEsp32() {
    return _esp32Reff.get().then(ESP32.fromQuerySnapshot);
  }
}

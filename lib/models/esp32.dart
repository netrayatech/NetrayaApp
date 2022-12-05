import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ESP32 {
  final String uuid;
  final String location;

  ESP32(this.uuid, this.location);

  static List<ESP32> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ESP32(
        data['uuid'],
        data['location'],
      );
    }).toList();
  }
}

class ESP32Provider with ChangeNotifier {
  final List<ESP32> _listEsp32;

  ESP32Provider(this._listEsp32);

  List<ESP32> get listEsp32 => _listEsp32;
}

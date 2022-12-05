import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsCuti {
  final int jatahCuti;
  final List<dynamic> types;

  SettingsCuti({required this.jatahCuti, required this.types});

  static SettingsCuti? fromDocSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) return null;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return SettingsCuti(jatahCuti: data['jatah_cuti'], types: data['types']);
  }
}

class SettingsCutiProvider with ChangeNotifier {
  SettingsCuti? _cuti;

  SettingsCuti? get cuti => _cuti;

  void setCuti(SettingsCuti cuti) {
    _cuti = cuti;
    notifyListeners();
  }
}

class General {
  final Map<String, dynamic> shift1;
  final Map<String, dynamic> shift2;
  final Map<String, dynamic> normalShift;

  General({required this.shift1, required this.shift2, required this.normalShift});

  static General? fromDocSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) return null;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return General(shift1: data['shift1'], shift2: data['shift2'], normalShift: data['normal_shift']);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netraya/models/settings.dart';

class SettingsService {
  final _dataCounterReference = FirebaseFirestore.instance.collection('settings');

  Future<General?> getGeneralData() async {
    return _dataCounterReference.doc('general').get().then(General.fromDocSnapshot);
  }
}

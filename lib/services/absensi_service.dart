import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netraya/constants/firestore_model_naming.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/models/settings.dart';
import 'package:netraya/services/firebase_storage_service.dart';

class AbsensiService {
  final String _uid;
  AbsensiService() : _uid = FirebaseAuth.instance.currentUser!.uid;
  final _absensiReff = FirebaseFirestore.instance.collection('absensi');
  final _absensiCounterReff = FirebaseFirestore.instance.collection('absensi_counter');
  final _dataReff = FirebaseFirestore.instance.collection('settings');
  final _firebaseStorageService = FirebaseStorageService();

  Future<List<Absen>> getAbsensi() {
    return _absensiReff
        .where(AbsenFieldNaming.uid, isEqualTo: _uid)
        .where(AbsenFieldNaming.status, isEqualTo: 'present')
        .orderBy(AbsenFieldNaming.date, descending: true)
        .get()
        .then(Absen.fromQuerySnapshot);
  }

  Future<List<Absen>> getAbsensiByDate(DateTime date) {
    return _absensiReff
        .where(AbsenFieldNaming.uid, isEqualTo: _uid)
        .where(AbsenFieldNaming.date, isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day, 0))
        .where(AbsenFieldNaming.date, isLessThan: DateTime(date.year, date.month, date.day + 1, 0))
        .orderBy(AbsenFieldNaming.date, descending: true)
        .get()
        .then(Absen.fromQuerySnapshot);
  }

  Future<Absen?> clockIn(Absen absen) async {
    String downloadableUrl = await _firebaseStorageService.uploadAbsensiImage(absen.localPath, '$_uid#IN');
    absen = absen.copyWith(uid: _uid, clockInSelfieImagePath: downloadableUrl);
    late DocumentReference docsReff;
    if (absen.id.isNotEmpty) {
      _absensiReff.doc(absen.id).update(absen.clockInToMap());
      return absen;
    } else {
      docsReff = await _absensiReff.add(absen.clockInToMap());
    }
    return docsReff.get().then(Absen.fromDocSnapshot);
  }

  Future<dynamic> clockOut(Absen absen) async {
    String downloadableUrl = await _firebaseStorageService.uploadAbsensiImage(absen.localPath, '$_uid#OUT');
    absen = absen.copyWith(uid: _uid, clockOutSelfieImagePath: downloadableUrl);
    _absensiReff.doc(absen.id).update(absen.clockOutToMap());

    return _absensiReff.doc(absen.id).get().then(Absen.fromDocSnapshot);
  }

  Future<Map<String, dynamic>> getAbsensiCounter() async {
    final docSnapshot = await _absensiCounterReff.doc(_uid).get();
    Map<String, dynamic> data = {};
    if (docSnapshot.data() == null) {
      data.addAll({
        DateTime.now().year.toString(): {'alpha': 0, 'cuti': 0, 'masuk': 0, 'cuti_tahunan': 0}
      });
    } else {
      data = docSnapshot.data()!;
    }
    return Future.value(data);
  }

  Stream<Map<String, dynamic>> get absensiCounter {
    return _absensiCounterReff.doc(_uid).snapshots().map((event) {
      Map<String, dynamic> data = {};
      if (event.data() == null) {
        data.addAll({
          DateTime.now().year.toString(): {'alpha': 0, 'cuti': 0, 'masuk': 0, 'cuti_tahunan': 0}
        });
      } else {
        data = event.data()!;
      }
      return data;
    });
  }

  Future<SettingsCuti?> getCuti() {
    return _dataReff.doc('cuti').get().then(SettingsCuti.fromDocSnapshot);
  }

  Future updateCounter(Map<String, dynamic> absensiCounter) async {
    return _absensiCounterReff.doc(_uid).set(absensiCounter);
  }
}

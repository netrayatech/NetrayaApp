import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netraya/constants/firestore_model_naming.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/models/app_user.dart';

class MonitorStaffService {
  final _absensiReff = FirebaseFirestore.instance.collection('absensi');
  final _userDataReference = FirebaseFirestore.instance.collection('users');

  Future<List<AppUserTemp>> getUsers() {
    return _userDataReference.orderBy(AppUserFieldNaming.createdAt).get().then(AppUserTemp.fromQuerySnapshot);
  }

  Future<List<Absen>> getAbsensi({required DateTime date}) {
    return _absensiReff
        .where(AbsenFieldNaming.date, isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day, 0))
        .where(AbsenFieldNaming.date, isLessThan: DateTime(date.year, date.month, date.day + 1, 0))
        .get()
        .then(Absen.fromQuerySnapshot);
  }
}

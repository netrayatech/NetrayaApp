import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/constants/firestore_model_naming.dart';
import 'package:netraya/models/cuti.dart';
import 'package:netraya/services/absensi_service.dart';

class CutiService {
  final String _uid;
  final AbsensiService absensiService = AbsensiService();
  CutiService() : _uid = FirebaseAuth.instance.currentUser!.uid;
  final _cutiReff = FirebaseFirestore.instance.collection('cuti');

  Future<List<Cuti>> getMyCuti() {
    return _cutiReff
        .where(CutiFieldNaming.uid, isEqualTo: _uid)
        .orderBy(CutiFieldNaming.requestedAt, descending: true)
        .get()
        .then(Cuti.fromQuerySnapshot);
  }

  Future<List<Cuti>> getMyYearlyLeaveReq() {
    return _cutiReff
        .where(CutiFieldNaming.uid, isEqualTo: _uid)
        .where(CutiFieldNaming.status, isEqualTo: AppCode.submitted)
        .where(CutiFieldNaming.jenisCuti, isEqualTo: 'Cuti Tahunan')
        .get()
        .then(Cuti.fromQuerySnapshot);
  }

  Future cutiRequest(Cuti cuti) async {
    final now = DateTime.now();
    cuti = cuti.copyWith(uid: _uid);

    int totalCuti =
        cuti.tanggalMulai!.difference(cuti.tanggalBerakhir!).inDays.abs() + 1;

    for (int i = 0; i < totalCuti; i++) {
      if (cuti.tanggalMulai!.add(Duration(days: i)).weekday ==
          DateTime.sunday) {
        totalCuti--;
      }
    }
    Map<String, dynamic> absensiCounter =
        await absensiService.getAbsensiCounter();
    List<Cuti> allMyYearlyReq = await getMyYearlyLeaveReq();
    int totalCutiTahunan = absensiCounter[now.year.toString()]['cuti_tahunan'];
    totalCutiTahunan += totalCuti;

    for (Cuti curr in allMyYearlyReq) {
      int currTotalCuti =
          cuti.tanggalMulai!.difference(curr.tanggalBerakhir!).inDays.abs() + 1;

      for (int i = 0; i < currTotalCuti; i++) {
        if (curr.tanggalMulai!.add(Duration(days: i)).weekday ==
            DateTime.sunday) {
          currTotalCuti--;
        }
      }
      totalCutiTahunan += currTotalCuti;
    }

    if (totalCutiTahunan > 12) {
      return Future.error(
          "Tidak bisa mengajukan cuti Tahunan, Kuota cuti tahunan terlampaui.");
    }
    return _cutiReff.add(cuti.toMapRequest());
  }
}

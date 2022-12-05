import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/constants/firestore_model_naming.dart';

class Cuti {
  final String uid;
  final String jenisCuti;
  final DateTime? tanggalMulai;
  final DateTime? tanggalBerakhir;
  final String catatan;
  final int status;
  final DateTime? requestedAt;

  Cuti({
    required this.uid,
    this.jenisCuti = '',
    this.tanggalMulai,
    this.tanggalBerakhir,
    this.catatan = '',
    this.status = 0,
    this.requestedAt,
  });

  static List<Cuti> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Cuti(
        uid: doc.id,
        jenisCuti: data[CutiFieldNaming.jenisCuti],
        tanggalMulai: DateTime.parse(
            data[CutiFieldNaming.tanggalMulai].toDate().toString()),
        tanggalBerakhir: DateTime.parse(
            data[CutiFieldNaming.tanggalBerakhir].toDate().toString()),
        catatan: data[CutiFieldNaming.catatan],
        status: data[CutiFieldNaming.status],
        requestedAt: DateTime.parse(
            data[CutiFieldNaming.requestedAt].toDate().toString()),
      );
    }).toList();
  }

  Map<String, dynamic> toMapRequest() {
    return {
      CutiFieldNaming.uid: uid,
      CutiFieldNaming.jenisCuti: jenisCuti,
      CutiFieldNaming.tanggalMulai: tanggalMulai,
      CutiFieldNaming.tanggalBerakhir: tanggalBerakhir,
      CutiFieldNaming.catatan: catatan,
      CutiFieldNaming.status: AppCode.submitted,
      CutiFieldNaming.requestedAt: FieldValue.serverTimestamp(),
    };
  }

  Cuti copyWith({
    String? uid,
    String? jenisCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalBerakhir,
    int? status,
    String? catatan,
  }) {
    return Cuti(
      uid: uid ?? this.uid,
      jenisCuti: jenisCuti ?? this.jenisCuti,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalBerakhir: tanggalBerakhir ?? this.tanggalBerakhir,
      catatan: catatan ?? this.catatan,
      status: status ?? this.status,
    );
  }
}
